# SQL Server Setup & Troubleshooting Guide

## 1 — Find SQL Server Instance Name

Check installed instances:
```
reg query "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server" /v InstalledInstances
```

Update `dbconfig.json` based on result:

| Instance Name     | server value              |
|--------------------|---------------------------|
| MSSQLSERVER        | `.`                       |
| SQLEXPRESS         | `.\SQLEXPRESS`            |
| SQLEXPRESS2022     | `.\SQLEXPRESS2022`        |

List all instances on network:
```
sqlcmd -L
```

## 2 — Check SQL Server Service Status

```
sc query MSSQLSERVER
sc query MSSQL$SQLEXPRESS
sc query SQLBrowser
```

## 3 — Start / Stop Services

```
net start MSSQL$SQLEXPRESS
net stop MSSQL$SQLEXPRESS
net start SQLBrowser
```

## 4 — Test Connection

```
sqlcmd -S .\SQLEXPRESS -Q "SELECT name FROM sys.databases"
sqlcmd -S .\SQLEXPRESS -Q "SELECT db_id('RestaurantPOS')"
```

- Returns a number → Database exists
- Returns NULL → Database not created yet

```
sqlcmd -S .\SQLEXPRESS -Q "SELECT @@VERSION"
```

## 5 — Check Installation Logs

```
explorer "%ProgramFiles%\Microsoft SQL Server\160\Setup Bootstrap\Log"
explorer "%TEMP%"
```

## 6 — Enable Protocols

```
mmc SQLServerManager16.msc
```

## 7 — dbconfig.json Location

```
explorer "%LOCALAPPDATA%\RestaurantPOS"
type "%LOCALAPPDATA%\RestaurantPOS\dbconfig.json"
```
