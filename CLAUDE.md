# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **SQL Server database schema and business logic repository** for an ERP/Accounting Payment System (ACPAY). All code is T-SQL targeting SQL Server. The system manages contracts, payments, customers, vendors, inventory, manufacturing, and HR for a Taiwanese enterprise.

**Primary database:** `acpay`
**Secondary database:** `cfp`
**Language:** T-SQL with Chinese column names and comments (Traditional Chinese / Taiwan)

## Architecture

### Module Numbering System

Directories use numeric/alphabetic prefixes mapping to business domains:

| Prefix | Domain | Example Table |
|--------|--------|---------------|
| 00 | Timers & Monitoring | `timer_eep`, `timer_cust` |
| 91 | Configuration & Master Data | `eep_depa`, `eep_curr` |
| 92 | Accounting & Chart of Accounts | `eep_acci`, `eep_coce` |
| 93 | Human Resources | `eep_empl`, `eep_atte` |
| 94 | Sales & Customers | `eep_cust`, `eep_sale`, `eep_area` |
| 95 | Purchasing & Vendors | `eep_fact`, `eep_purc` |
| 96 | Inventory & Materials | `eep_ware`, `eep_item` |
| 97 | Manufacturing | `eep_mach` |
| 98 | Production | `eep_wkct`, `eep_bom` |
| 99 | System Configuration | `eep_comp`, `eep_sysp` |
| a0 | Customer Service | — |
| b0 | Work Orders | — |
| e0 | Contract Changes | `pos`, `pos_log` |
| z1 | Utility Functions | `uf_strzero`, `uf_契約編號` |

Each module directory is named: `{prefix}_{Chinese description}_{table_name}` (e.g., `94A_客戶代碼_eep_cust`).

### File Naming Conventions

| Prefix | Type | Purpose |
|--------|------|---------|
| `tb_` | Table | CREATE TABLE definitions |
| `tr_` | Trigger | AFTER INSERT/UPDATE/DELETE triggers |
| `ep_` | Event Procedure | Post-save logic (存後), timer execution |
| `up_` | Update Procedure | Business logic procedures |
| `vi_` | View | SELECT views for reporting |
| `uf_` | Function | User-defined scalar functions |

Trigger naming: `tr_{sequence}_{module}_{sub}_{table}` — the sequence number (010, 100, 110) controls execution order.

### Standard Audit Trail Columns

Every `eep_*` table includes:

- `menuflag char(20)` — Menu identifier, auto-set by AFTER INSERT trigger (format: `{module}_00_{uf_strzero(num,13)}`)
- `flowflag char(50)` — Process flow state
- `chjernoi nvarchar(99)` — Created-by info (建檔資訊)
- `chjernou nvarchar(99)` — Updated-by info (修改資訊)
- `chjernoc` — Closed-by info (結案)
- `chjernop` — Posted-by info (過帳)
- `chjernov` — Voided-by info (作廢)
- `chjernoz` — Approved-by info (核准)
- `remark nvarchar(max)` — Rich remarks/documentation

### Timer/Monitoring Pattern (00/)

31 timer modules monitor business events. Each contains:
- `ep_timer_{entity}.sql` — Execution procedure
- `ep_timer_{entity}_del.sql` — Cleanup procedure
- `tr_{seq}_timer_{entity}.sql` — Triggers

### Contract Change Pattern (e0_主約變更/)

The `up_e01_zy.sql` procedure implements field-level change tracking, comparing old vs. new values and recording diffs as `舊值→新值` in the remark field.

## Deployment Order

SQL scripts must be executed against the target database in this order:

1. Tables (`tb_*.sql`) — schema definitions
2. Functions (`uf_*.sql`) — dependencies for triggers/procedures
3. Views (`vi_*.sql`)
4. Stored Procedures (`ep_*.sql`, `up_*.sql`)
5. Triggers (`tr_*.sql`) — depend on tables and functions existing

Each SQL file follows the pattern: DROP IF EXISTS → SET options → CREATE.

## Working with This Codebase

- Use the MCP SQL Server tools (`mcp__sqlserver-nutc__*`) to query and execute against the live database
- When modifying a module, read the table definition first to understand column names
- The `menuflag` column is the key link between the ERP UI menu system and database records
- `uf_strzero(num, length)` is a core utility that zero-pads integers to a specified width
- Column comments in table DDL (after `--`) document the Chinese field name/purpose
