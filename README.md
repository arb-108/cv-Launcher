sqlcmd -S .\SQLEXPRESS -E -d RestaurantPOS -Q "SELECT 'Orders' AS T, COUNT() AS N FROM Orders UNION ALL SELECT 'MenuItems', COUNT() FROM MenuItems UNION ALL SELECT 'Categories', COUNT(*) FROM Categories;"

sqlcmd -S .\SQLEXPRESS -E -Q "DROP DATABASE RestaurantPOS;"

sqlcmd -S .\SQLEXPRESS -E -Q "ALTER DATABASE RestaurantPOS SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE RestaurantPOS;"


sqlcmd -S .\SQLEXPRESS -E -Q "SELECT name FROM sys.databases WHERE name='RestaurantPOS';"


printer :

Get-WmiObject Win32_PnPEntity | Where-Object {$_.DeviceID -like "*USB00*"} | Select Name, DeviceID

SQL DATABASE :
SQL Server Setup & Troubleshooting Guide
1 — Find SQL Server Instance Name
Check installed instances:
reg query "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server" /v InstalledInstances
Update dbconfig.json based on result:
MSSQLSERVER → "server": "."
SQLEXPRESS → "server": ".\\SQLEXPRESS"
SQLEXPRESS2022 → "server": ".\\SQLEXPRESS2022"
List all instances on network:
sqlcmd -L
2 — Check SQL Server Service Status
sc query MSSQLSERVER
sc query MSSQL$SQLEXPRESS
sc query SQLBrowser
3 — Start / Stop Services
net start MSSQL$SQLEXPRESS
net stop MSSQL$SQLEXPRESS
net start SQLBrowser
4 — Test Connection
sqlcmd -S .\SQLEXPRESS -Q "SELECT name FROM sys.databases"
sqlcmd -S .\SQLEXPRESS -Q "SELECT db_id('RestaurantPOS')"
Returns a number → Database exists
Returns NULL → Database not created yet
sqlcmd -S .\SQLEXPRESS -Q "SELECT @@VERSION"
5 — Check Installation Logs
explorer "%ProgramFiles%\Microsoft SQL Server\160\Setup Bootstrap\Log"
explorer "%TEMP%"
6 — Enable Protocols
mmc SQLServerManager16.msc
7 — dbconfig.json Location
explorer "%LOCALAPPDATA%\RestaurantPOS"
type "%LOCALAPPDATA%\RestaurantPOS\dbconfig.json"

{
  "server": ".\\SQLEXPRESS",
  "database": "RestaurantPOS",
  "integratedSecurity": true,
  "username": null,
  "password": null
}

https://drive.google.com/drive/folders/10nfQh11vFYDgwipUqAMHX7TvhNBdl_N1?usp=sharing


sc config "MSSQL$SQLEXPRESS" start= auto
sc config "SQLBrowser" start= auto
sc start "SQLBrowser"



