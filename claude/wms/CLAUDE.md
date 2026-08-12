# Gemio WMS - ERP Inventory Management System

## Mission
Backend-maximized ERP system. All business logic lives in SQL Server (T-SQL triggers, stored procedures). Frontend development is minimized.

## Database

The `mes_*` stack is **duplicated across several databases**. Deploying to one does not affect
the others — always confirm the target before deploying, and check where the real `eep_trd` data is.

| Server | Database | Role | eep_trd |
|--------|----------|------|---------|
| `192.168.50.53,8000` (`drlee / ACpos#1234`) | `acpay` | **Live data — the one actually in use** | 110 rows |
| `163.17.141.61,8081` (`casper / CasChrAliJimJam`) | `gemio_wms` | Reference / development schema | 0 rows |
| `163.17.141.61,8081` | `acpay`, `acpay_std`, `gemio` | Other copies, mes stack not fully deployed | 218 rows each |

Deployment status of `sp_recalc_mmbe` + the `EXEC sp_recalc_mmbe` version of `sp_recalc_itea`:
deployed to `gemio_wms` and to `192.168.50.53/acpay`. **Not** deployed to `163.17.141.61/acpay`,
`acpay_std`, or `gemio` — mmbe stays empty there by design until someone deploys it.

## Architecture

### Tables (only these may be modified)
| Table | Key | Purpose |
|-------|-----|---------|
| `mes_itio` | iono, ioseq, ioseqseq | Inventory movement transactions (source of truth) |
| `mes_level` | — | 4-level hierarchy: posino -> wareno -> plantno -> compno (**not created / not used**; hierarchy is read from `mes_itio`) |
| `mes_itea1` | iodate, itemno, compno | Daily balance at **company** level |
| `mes_itea2` | iodate, itemno, plantno | Daily balance at **plant** level |
| `mes_itea3` | iodate, itemno, wareno | Daily balance at **warehouse** level |
| `mes_itea4` | iodate, itemno, posino | Daily balance at **position** level |
| `mes_mmbe1` | itemno, compno | **Current** balance (last movement date) at company level |
| `mes_mmbe2` | itemno, plantno | **Current** balance (last movement date) at plant level |
| `mes_mmbe3` | itemno, wareno | **Current** balance (last movement date) at warehouse level |
| `mes_mmbe4` | itemno, posino | **Current** balance (last movement date) at position level |

### Core T-SQL Objects
| Object | Type | Purpose |
|--------|------|---------|
| `tr_mes_itio_sync` | Trigger (AFTER INSERT/UPDATE/DELETE) | Captures affected (itemno, posino, wareno, plantno, compno) into `#affected`, calls `sp_recalc_itea` |
| `sp_recalc_itea` | Stored Procedure | Recalculates all 4 itea levels using window functions, then calls `sp_recalc_mmbe` |
| `sp_recalc_mmbe` | Stored Procedure | Copies each combination's **MAX(iodate)** itea row into the matching mmbe table |
| `tr_111_eep_trd_mes_itio` | Trigger on `eep_trd` | Feeds inbound movements into `mes_itio` (posino = wareno) |
| `tr_111_eep_tod_mes_itio` | Trigger on `eep_Tod` | Feeds movements into `mes_itio` |
| `tr_111_eep_tdd_mes_itio` | Trigger on `eep_tdd` | Feeds movements into `mes_itio` |

Both SPs read the caller-created `#affected` temp table (nested SPs inherit the caller's temp tables).

### Data Flow
```
mes_itio (INSERT/UPDATE/DELETE)
    -> tr_mes_itio_sync (trigger)  -- builds #affected from inserted + deleted
        -> sp_recalc_itea (stored procedure)
            -> mes_itea4 (posino level, from itio directly)
            -> mes_itea3 (wareno level, from itio directly)
            -> mes_itea2 (plantno level, from itio directly)
            -> mes_itea1 (compno level, from itio directly)
            -> sp_recalc_mmbe (stored procedure)
                -> mes_mmbe4 / mmbe3 / mmbe2 / mmbe1  -- MAX(iodate) row per (itemno, 階層碼)
```

### Business Rules
- `ioqty > 0` = Inbound (InboundQuantity)
- `ioqty < 0` = Outbound (OutboundQuantity, stored as positive value)
- `OpeningQuantity` = running sum of net qty from all prior dates
- `ClosingQuantity = OpeningQuantity + InboundQuantity - OutboundQuantity`
- itea rows only exist for dates that have transactions (no zero-movement filler rows)
- mmbe holds exactly one row per (itemno, hierarchy code) — the last movement date's itea row
- When a combination loses all its movements, its itea **and** mmbe rows are removed
- Hierarchy (wareno, plantno, compno) comes from `mes_itio` directly (not `mes_level`)
- Missing lower level falls back upward — no `posino` => `posino = wareno` (all codes are `nvarchar(40)`)
- `iodate` is `char(8)` `YYYYMMDD`, so lexical order = chronological order; `MAX(iodate)` is the last movement date

### Handled Scenarios
1. Date change (`iodate` update) - recalculates both old and new date ranges
2. Row deletion - removes qty and recalculates forward balances
3. posino/itemno change - recalculates both old and new dimension combinations
4. Set-based multi-row UPDATE in a single statement
5. All movements for a combination deleted - itea and mmbe rows disappear

## Verification Criterion
All 4 itea levels must satisfy for every row:
```
OpeningQuantity + InboundQuantity - OutboundQuantity = ClosingQuantity
```
And for every level N: `mes_mmbeN` must equal the `MAX(iodate)` row set of `mes_iteaN`.

## Constraints
- Only modify the tables listed above
- Update CLAUDE.md and SKILL.md after every task completion
- Push changes to GitHub: `tocasper-eng/gemio_wms`

## GitHub
- Repository: `tocasper-eng/gemio_wms`
- Email: `tocasper@g.ncu.edu.tw`
