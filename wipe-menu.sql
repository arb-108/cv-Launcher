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
