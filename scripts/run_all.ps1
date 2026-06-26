$ErrorActionPreference = "Stop"

$steps = @(
    @{ File = "scripts/init_database.sql"; Database = "" },
    @{ File = "scripts/bronze/ddl_bronze.sql"; Database = "dw_bronze" },
    @{ File = "scripts/bronze/proc_load_bronze.sql"; Database = "dw_bronze" },
    @{ File = "scripts/silver/ddl_silver.sql"; Database = "dw_silver" },
    @{ File = "scripts/silver/proc_load_silver.sql"; Database = "dw_silver" },
    @{ File = "scripts/gold/ddl_gold.sql"; Database = "dw_gold" },
    @{ File = "tests/quality_checks_silver.sql"; Database = "dw_silver" },
    @{ File = "tests/quality_checks_gold.sql"; Database = "dw_gold" }
)

foreach ($step in $steps) {
    & "$PSScriptRoot\run_mysql_file.ps1" -File $step.File -Database $step.Database
}

Write-Host "Data warehouse scripts completed successfully."
