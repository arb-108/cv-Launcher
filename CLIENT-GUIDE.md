# MASTER CHEF — Restaurant POS
## Client Setup & Operations Guide

Welcome! This guide walks you through getting your Point-of-Sale system ready
for business: logging in, clearing the sample data, adding your own menu,
assigning printers, running shifts, and taking backups.

> **Your database server name is:** `.\SQLEXPRESS`
> You'll need this whenever a command below asks for it.

---

## 1. First Login

1. Launch **Restaurant POS** from the desktop icon.
2. Log in with the default administrator account:
   - **Username:** `admin`
   - **PIN:** `1234`
3. **Important — change this PIN** after first login:
   *Settings → Users & Roles → edit the admin user → set a new PIN.*

---

## 2. Set Your Restaurant Details

*Settings → General*

- Restaurant Name (prints on every receipt)
- Address
- Phone
- Currency symbol

These appear on all printed bills and reports.

---

## 3. Clear the Sample Menu (one-time, before you go live)

The system ships with demo menu items so you can try it out. Before real
trading, clear them so you can enter your own menu.

> ⚠️ **Close the Restaurant POS app first**, and only do this once during setup.

### Step A — Back up first (always)

Open **Command Prompt as Administrator** and run:

```cmd
sqlcmd -S .\SQLEXPRESS -E -Q "BACKUP DATABASE RestaurantPOS TO DISK='C:\ProgramData\RestaurantPOS\Backups\before-menu-wipe.bak' WITH FORMAT, INIT, COMPRESSION;"
```

### Step B — Create the cleanup script

```cmd
notepad C:\Temp\wipe-menu.sql
```

Click **Yes** to create the file, paste the text below exactly, then press **Ctrl+S** to save:

```sql
USE RestaurantPOS;
GO

BEGIN TRANSACTION;

-- Clear demo orders (they reference the demo menu items)
DELETE FROM KitchenOrderItems;
DELETE FROM KitchenOrders;
DELETE FROM OrderItemModifiers;
DELETE FROM OrderItems;
DELETE FROM Payments;
UPDATE CashDrawerLogs      SET OrderId = NULL WHERE OrderId IS NOT NULL;
UPDATE LoyaltyTransactions SET OrderId = NULL WHERE OrderId IS NOT NULL;
DELETE FROM Orders;

-- Clear menu-item links
DELETE FROM Recipes;
DELETE FROM MenuItemVariants;
DELETE FROM MenuItemModifierGroups;
DELETE FROM DealItems;
DELETE FROM Deals;
DELETE FROM StockMovements;

-- Delete the demo menu items
DELETE FROM MenuItems;

-- (OPTIONAL) also delete the demo categories — remove the two dashes to enable:
-- DELETE FROM Categories;

-- Reset numbering so your new items start at 1
DBCC CHECKIDENT ('MenuItems',              RESEED, 0);
DBCC CHECKIDENT ('MenuItemVariants',       RESEED, 0);
DBCC CHECKIDENT ('MenuItemModifierGroups', RESEED, 0);
DBCC CHECKIDENT ('Recipes',                RESEED, 0);
DBCC CHECKIDENT ('Deals',                  RESEED, 0);
DBCC CHECKIDENT ('DealItems',              RESEED, 0);
DBCC CHECKIDENT ('Orders',                 RESEED, 0);
DBCC CHECKIDENT ('OrderItems',             RESEED, 0);
DBCC CHECKIDENT ('Payments',               RESEED, 0);
DBCC CHECKIDENT ('StockMovements',         RESEED, 0);

COMMIT;

-- Confirm the menu is empty
SELECT 'MenuItems' AS [Table], COUNT(1) AS [Rows] FROM MenuItems
UNION ALL SELECT 'Orders',     COUNT(1) FROM Orders
UNION ALL SELECT 'Categories', COUNT(1) FROM Categories;
GO
```

### Step C — Run the script

```cmd
sqlcmd -S .\SQLEXPRESS -E -d RestaurantPOS -i C:\Temp\wipe-menu.sql
```

You should see `MenuItems` and `Orders` showing **0**. The menu is now empty.

---

## 4. Add Your Own Menu

1. Launch Restaurant POS and log in.
2. Go to **Menu Settings**.
3. (If you deleted categories) Add your categories first.
4. Click **Add Product** and enter each item — name, price, category, etc.

New items are numbered automatically starting from 1.

---

## 5. Set Up Your Printers

*Settings → Printers*

1. Click **Add Printer** for each thermal/receipt printer:
   - Give it a **Name** (e.g. "Counter", "Kitchen")
   - Pick the matching **System Printer** (the Windows printer)
   - Set **Width** to `80` for standard 80 mm thermal rolls
2. In **Print Role → Printer Assignments**, choose which printer does each job:
   - **Kitchen Slip (K-Slip)** → your kitchen printer
   - **Bill / Receipt (& Reprint)** → your counter printer
   - **Reports** → wherever you print A4 reports

Each choice saves instantly. You can use the same printer for more than one role.

---

## 6. Daily Operations

### Shifts
- **Open a shift** at the start of the day: *Shift Management → Open Shift*
  (enter your opening cash float).
- Take orders normally throughout the day.
- **Close the shift** at the end: *Shift Management → Close Shift*
  (count the drawer, the system shows any discrepancy).
  - Leave **"Create database backup when closing shift"** ticked to back up
    automatically every time you close — it keeps the 7 most recent backups.

### Billing tab
The **Billing** tab on the main screen shows the orders for the **current open
shift only**. Closing the shift and opening a new one starts a fresh list.

### Reprint a receipt
- From the **Orders** screen, find the order and click **Receipt** → **Print**.

---

## 7. Backups

*Settings → Backup*

- **Backup Now** — creates a backup immediately and copies it to any connected
  USB drive. Keeps the 7 most recent automatically.
- **Change…** — pick a different folder to store backups (e.g. an external drive).
- **Reset** — return to the default location
  (`C:\ProgramData\RestaurantPOS\Backups`).

> 💡 We recommend keeping the auto-backup-on-shift-close option enabled and
> also plugging in a USB drive once a week for an off-machine copy.

---

## 8. Troubleshooting

### "Database Connection Failed" on startup
SQL Server may not be running. Open **Command Prompt as Administrator** and run:

```cmd
net start "MSSQL$SQLEXPRESS"
```

Then reopen the app. If it still fails, confirm the server name is `.\SQLEXPRESS`
in the app's database settings dialog.

### Check the system is reachable
```cmd
sqlcmd -S .\SQLEXPRESS -E -d RestaurantPOS -Q "SELECT COUNT(1) FROM MenuItems;"
```
A number means everything is connected correctly.

### A receipt printed too small / half the paper width
The system locks the printer to the standard font automatically — this is
already handled. If a brand-new printer still misbehaves, run its self-test page
once and make sure it's set to **80 mm** width.

### Restore from a backup
*Settings → Backup → Import* and select a `.bak` file. This safely merges in
data without overwriting what's already there.

---

## 9. Support Checklist (before contacting support)

When reporting an issue, please note:
- What screen you were on
- The exact error message (a photo of the screen is perfect)
- Whether a shift was open
- Roughly what time it happened (for the logs)

Application logs are stored at:
`C:\Users\<your-windows-user>\AppData\Local\RestaurantPOS\logs`

---

**MASTER CHEF Restaurant POS** — thank you for choosing us. Enjoy your service! 🍽️
