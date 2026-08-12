# Gemio WMS - Skills & Completed Tasks

## Completed Skills

### 2026-08-10: Current-Balance Snapshot (mmbe1-4)

**Objective:** After the itea recalculation, write **the last movement date's** result into
`mes_mmbe1`~`mes_mmbe4`. Key is only `(itemno, 階層碼)` — one row per combination.

**Objects Created / Changed:**

1. **Tables (deployed):** `mes_mmbe1` (itemno, compno), `mes_mmbe2` (itemno, plantno),
   `mes_mmbe3` (itemno, wareno), `mes_mmbe4` (itemno, posino).
   DDL already existed in `4_資料庫物件/` but had never been executed against `gemio_wms`.

2. **Stored Procedure `sp_recalc_mmbe`** (new, `4_資料庫物件/sp_recalc_mmbe.sql`):
   - Reads the caller's `#affected` temp table (same contract as `sp_recalc_itea`)
   - Per level: DELETE affected `(itemno, 階層碼)` rows, then re-INSERT from `mes_iteaN`
     where `iodate = (SELECT MAX(iodate) ... same combination)`
   - Because the re-INSERT is driven by `mes_iteaN`, a combination whose movements were all
     deleted simply produces no row — the mmbe row disappears without any special-case code

3. **Stored Procedure `sp_recalc_itea`** (changed): appended `EXEC sp_recalc_mmbe;` after the
   LEVEL 1 insert. The trigger `tr_mes_itio_sync` was **not** touched.

**Key Design Decisions:**
- `iodate` is `char(8)` `YYYYMMDD`, so `MAX(iodate)` is a plain string max — no date parsing,
  no conversion, and it stays sargable
- mmbe derived from itea (not re-aggregated from itio) — a single source of truth, and the
  itea verification criterion automatically covers mmbe
- Nested SP rather than inlining into `sp_recalc_itea`: `#affected` is visible to nested
  procedures, so the split costs nothing and keeps each SP readable
- Delete-then-reinsert per affected combination (same strategy as itea), so a combination
  dropping to zero rows self-cleans

**Test Results (7 scenarios, all levels verified after each):**

| # | Scenario | Result |
|---|----------|--------|
| 1 | INSERT across multiple dates / items / positions | OK |
| 2 | UPDATE `iodate` 20260506 -> 20260430 (backdating) — opening balances of later dates shift | OK |
| 3 | DELETE a movement — forward balances recalculated | OK |
| 4 | UPDATE `posino` — old combination cleaned, new one created at both itea and mmbe | OK |
| 5 | UPDATE `itemno` — same, across item dimension | OK |
| 6 | Delete every movement of a combination — itea **and** mmbe rows gone (0 rows) | OK |
| 7 | Set-based UPDATE touching many rows in one statement | OK |

Checks run after every scenario:
- `OpeningQuantity + InboundQuantity - OutboundQuantity = ClosingQuantity` on itea1-4
- `mes_mmbeN` EXCEPT `MAX(iodate)` row set of `mes_iteaN` = empty, in both directions
- `mes_mmbe4.ClosingQuantity` = `SUM(ioqty)` from `mes_itio` per (itemno, posino), FULL JOIN
  so orphans on either side are caught

**Gotcha:** `DELETE FROM mes_itio` (all rows) correctly cascades through the trigger and
empties all 8 derived tables — the `deleted` pseudo-table supplies every affected combination.

### 2026-08-10 (cont.): Deployed to the live database + backfill

**Symptom reported:** `UPDATE eep_trd SET zoomno='2'` ran, but `mes_mmbe1` was still empty.

**Root cause:** the mmbe code had only been deployed to `gemio_wms` (the database named in
`3_資料庫資訊`), but the real `eep_trd` data lives in `192.168.50.53,8000 / acpay`. In `gemio_wms`
`eep_trd` has **0 rows**, so no update there can produce anything. In `acpay` the mmbe *tables*
existed, but `sp_recalc_mmbe` did not and `sp_recalc_itea` had no `EXEC` — nothing ever wrote to them.

**Diagnostic that pinned it down:** on `192.168.50.53/acpay`, `mes_itea1~4` were populated
(45/45/102/102 rows) while all four `mes_mmbe*` were 0. A populated itea with an empty mmbe can
only mean the mmbe step is missing — not a trigger or data problem.

**Actions:**
1. Diffed the live `sp_recalc_itea` (via `OBJECT_DEFINITION`) against the repo copy — identical
   except the missing `EXEC`, so no local customization would be lost
2. Backed up all 9 `mes_*` tables and the live SP definition to CSV/SQL first
3. Deployed with **`ALTER PROCEDURE`, not `DROP`+`CREATE`** — a DROP leaves a window where a
   concurrent `mes_itio` change would fail with "could not find stored procedure"
4. Backfilled `mes_mmbe*` from the existing `mes_itea*` (45/45/102/102 rows). A deploy alone does
   nothing to history — mmbe would only fill in as combinations happen to be touched again
5. End-to-end test on live data: `UPDATE eep_trd SET zoomno = zoomno WHERE num = 1` (a no-op
   update still fires the AFTER UPDATE trigger). All four mmbe tables came back byte-identical,
   proving `eep_trd -> mes_itio -> mes_itea -> mes_mmbe` is wired and idempotent

**Gotchas learned:**
- The `mes_*` stack exists in **five** databases (`gemio_wms`, `acpay` on two servers, `acpay_std`,
  `gemio`). Deploying to one does nothing for the others — always ask which one is live
- `tr_100_62k_10_eep_trd` on `eep_trd` is `AFTER INSERT` only, so a no-op UPDATE is safe for
  end-to-end testing — it won't rewrite `menuflag`
- No database on either server had `zoomno='2'` after the reported UPDATE (all `'1'` or `NULL`),
  so that statement never committed. Worth checking the data before trusting "I ran X" as a premise


### 2026-08-07: Real-time Inventory Balance Sync (itea1-4)

**Objective:** When `mes_itio` changes, automatically update `mes_itea1` through `mes_itea4`.

**Objects Created:**

1. **Tables** (6 total in `gemio_wms`):
   - `mes_itio` - Inventory movements (with `iodate` column)
   - `mes_level` - 4-level hierarchy master
   - `mes_itea1` - Company-level daily balance
   - `mes_itea2` - Plant-level daily balance
   - `mes_itea3` - Warehouse-level daily balance
   - `mes_itea4` - Position-level daily balance

2. **Stored Procedure:** `sp_recalc_itea`
   - Expects `#affected` temp table with `(itemno, posino, wareno, plantno, compno)`
   - Uses CTE + window functions for running balance calculation
   - Delete-then-reinsert strategy for affected combinations
   - Hierarchy (wareno, plantno, compno) comes from `mes_itio` directly, not `mes_level`

3. **Trigger:** `tr_mes_itio_sync`
   - AFTER INSERT, UPDATE, DELETE on `mes_itio`
   - Collects affected `(itemno, posino, wareno, plantno, compno)` from both `inserted` and `deleted`
   - Calls `sp_recalc_itea`

**Test Results:**
- INSERT: Correct daily balance created across all 4 levels
- Multi-day INSERT: Running OpeningQuantity cascades correctly
- UPDATE iodate: Old date removed, new date recalculated, forward balances adjusted
- UPDATE posino: Old posino cleaned, new posino populated, hierarchy levels updated
- DELETE: Row removed, forward balances recalculated
- Verification: `OpeningQuantity + InboundQuantity - OutboundQuantity = ClosingQuantity` holds for all rows in all 4 levels

**Key Design Decisions:**
- Full recalculation per affected (itemno, dimension) combination rather than incremental delta - simpler, always correct
- Hierarchy resolved directly from `mes_itio` columns (wareno, plantno, compno), independent of `mes_level`
- No dependency on `mes_level` for trigger/SP to function correctly
