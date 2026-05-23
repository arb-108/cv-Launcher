sqlcmd -S .\SQLEXPRESS -E -d RestaurantPOS -Q "SELECT 'Orders' AS T, COUNT() AS N FROM Orders UNION ALL SELECT 'MenuItems', COUNT() FROM MenuItems UNION ALL SELECT 'Categories', COUNT(*) FROM Categories;"

sqlcmd -S .\SQLEXPRESS -E -Q "DROP DATABASE RestaurantPOS;"
