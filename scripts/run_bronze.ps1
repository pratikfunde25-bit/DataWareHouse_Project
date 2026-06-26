$ErrorActionPreference = "Stop"

& "$PSScriptRoot\run_mysql_file.ps1" -File "scripts/init_database.sql"
& "$PSScriptRoot\run_mysql_file.ps1" -File "scripts/bronze/ddl_bronze.sql" -Database "dw_bronze"
& "$PSScriptRoot\run_mysql_file.ps1" -File "scripts/bronze/proc_load_bronze.sql" -Database "dw_bronze"

Write-Host "Bronze layer completed successfully."
