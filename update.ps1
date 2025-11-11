# Interrompe lo script se un comando fallisce
$ErrorActionPreference = "Stop"

# --- Definizioni dei Percorsi ---
$ScriptDir = $PSScriptRoot

# --- Logging ---
$LogFile = Join-Path $ScriptDir "update_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $LogFile

Write-Host "Starting Update Script at $(Get-Date)"

# --- ‼️ MODIFICA QUESTI PERCORSI ‼️ ---
$BaseStoragePath = "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt" # Esempio di percorso Windows
# --- Fine percorsi da modificare ---

$McpDir = Join-Path $BaseStoragePath "MCP"
$SettingsDir = Join-Path $BaseStoragePath "settings"
$SettingsFile = Join-Path $SettingsDir "a4d_mcp_settings.json"
$RepoName = "mcp_server_toolkit"
$RepoPath = Join-Path $McpDir $RepoName

# --- Funzioni Helper per Permessi ---
function Set-DirectoryReadOnly {
    param($Path)
    if (Test-Path $Path) {
        Write-Host "Setting $Path and contents to read-only..."
        Get-ChildItem -Path $Path -Recurse | Set-ItemProperty -Name IsReadOnly -Value $true
        Write-Host "Permissions for $Path set to read-only."
    }
}

function Set-DirectoryWriteable {
    param($Path)
    if (Test-Path $Path) {
        Write-Host "Restoring write permission for $Path and contents..."
        Get-ChildItem -Path $Path -Recurse | Set-ItemProperty -Name IsReadOnly -Value $false
        Write-Host "Write restored for $Path."
    }
}

# --- Controllo Pre-Aggiornamento ---
Write-Host "Checking for existing installation..."
$IsInstalled = $false
if ((Test-Path $RepoPath) -and (Test-Path $SettingsFile)) {
    try {
        $SettingsJson = Get-Content $SettingsFile -Raw | ConvertFrom-Json
        if ($SettingsJson.PSObject.Properties['mcpServers'] -and $SettingsJson.mcpServers.PSObject.Properties['mcp_server_toolkit']) {
            $IsInstalled = $true
        }
    } catch {
        # Non fa nulla, $IsInstalled rimane false
    }
}

if (-not $IsInstalled) {
    Write-Warning "---"
    Write-Warning "ATTENZIONE: Installazione non trovata."
    Write-Warning "La directory '$RepoPath' o la configurazione JSON non esistono."
    Write-Warning "Esegui prima lo script 'install.ps1'."
    Write-Warning "---"
    Stop-Transcript
    exit 1
}

# --- 1. Navigazione e Ripristino Permessi ---
Set-Location $RepoPath
Write-Host "Changed to repository directory: $PWD"

Set-DirectoryWriteable -Path "build"
Set-DirectoryWriteable -Path "src"

# --- 2. Aggiornamento e Build ---
Write-Host "Pulling latest changes..."
git pull
Write-Host "Repository updated successfully!"

Write-Host "Installing dependencies (if any changed)..."
npm install
Write-Host "Dependencies installed."

Write-Host "Building project..."
npm run build
Write-Host "Build completed successfully!"

# --- 3. Imposta Permessi Read-Only ---
Set-DirectoryReadOnly -Path "build"
Set-DirectoryReadOnly -Path "src"

Write-Host "---"
Write-Host "UPDATE SCRIPT COMPLETED at $(Get-Date)"
Stop-Transcript