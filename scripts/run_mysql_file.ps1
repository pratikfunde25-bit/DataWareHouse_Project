param(
    [Parameter(Mandatory = $true)]
    [string]$File,

    [string]$Database = "",

    [string]$EnvFile = ".env"
)

$ErrorActionPreference = "Stop"
$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$sqlFile = Resolve-Path (Join-Path $projectRoot $File)
$envPath = Join-Path $projectRoot $EnvFile

if (-not (Test-Path $envPath)) {
    throw "Missing $EnvFile. Copy .env.example to .env and update your MySQL password."
}

Get-Content $envPath | ForEach-Object {
    if ($_ -notmatch "^\s*$" -and $_ -notmatch "^\s*#") {
        $name, $value = $_ -split "=", 2
        if ($name -and $value) {
            Set-Item -Path "Env:$($name.Trim())" -Value $value.Trim()
        }
    }
}

if (-not $env:MYSQL_HOST) { $env:MYSQL_HOST = "localhost" }
if (-not $env:MYSQL_PORT) { $env:MYSQL_PORT = "3306" }
if (-not $env:MYSQL_USER) { $env:MYSQL_USER = "root" }

$mysql = Get-Command mysql -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source -First 1

if (-not $mysql) {
    $possiblePaths = @(
        "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.3\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.2\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.1\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Workbench 8.0\mysql.exe"
    )

    $mysql = $possiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $mysql) {
    throw "mysql.exe was not found. Install MySQL Server or add MySQL bin folder to PATH."
}

$arguments = @(
    "--local-infile=1",
    "--host=$env:MYSQL_HOST",
    "--port=$env:MYSQL_PORT",
    "--user=$env:MYSQL_USER",
    "--password=$env:MYSQL_PASSWORD"
)

if ($Database) {
    $arguments += $Database
}

Write-Host "Running $File"
$projectRootForSql = $projectRoot.Path.Replace("\", "/")
$sqlContent = [System.IO.File]::ReadAllText($sqlFile)
$sqlContent = $sqlContent.Replace("__PROJECT_ROOT__", $projectRootForSql)
$sqlContent | & $mysql @arguments

if ($LASTEXITCODE -ne 0) {
    throw "MySQL failed while running $File."
}
