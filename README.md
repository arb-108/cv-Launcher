sqlcmd -S .\SQLEXPRESS -E -d RestaurantPOS -Q "SELECT 'Orders' AS T, COUNT() AS N FROM Orders UNION ALL SELECT 'MenuItems', COUNT() FROM MenuItems UNION ALL SELECT 'Categories', COUNT(*) FROM Categories;"

sqlcmd -S .\SQLEXPRESS -E -Q "DROP DATABASE RestaurantPOS;"

sqlcmd -S .\SQLEXPRESS -E -Q "ALTER DATABASE RestaurantPOS SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE RestaurantPOS;"


sqlcmd -S .\SQLEXPRESS -E -Q "SELECT name FROM sys.databases WHERE name='RestaurantPOS';"


Get-WmiObject Win32_PnPEntity | Where-Object {$_.DeviceID -like "*USB00*"} | Select Name, DeviceID

{
  "server": ".\\SQLEXPRESS",
  "database": "RestaurantPOS",
  "integratedSecurity": true,
  "username": null,
  "password": null
}
