# Interrompe lo script se un comando fallisce (equivalente di 'set -e')
$ErrorActionPreference = "Stop"

# --- Determina i percorsi assoluti degli script ---
$ScriptDir = $PSScriptRoot # Directory di questo script

# --- Logging ---
$LogFile = Join-Path $ScriptDir "install_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $LogFile

Write-Host "Starting Installation Script at $(Get-Date)"
Write-Host "Script directory identified as: $ScriptDir"

# --- ‼️ MODIFICA QUESTI PERCORSI ‼️ ---
$BaseStoragePath = "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt" # Esempio di percorso Windows
$DxProjectPath = "C:\Users\codebuilder\dx-project" # Esempio di percorso progetto
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

# --- Controllo Pre-Installazione ---
Write-Host "Checking for existing configuration in $SettingsFile..."
$IsAlreadyInstalled = $false
if (Test-Path $SettingsFile) {
    try {
        $SettingsJson = Get-Content $SettingsFile -Raw | ConvertFrom-Json
        if ($SettingsJson.PSObject.Properties['mcpServers'] -and $SettingsJson.mcpServers.PSObject.Properties['mcp_server_toolkit']) {
            $IsAlreadyInstalled = $true
        }
    } catch {
        Write-Warning "File $SettingsFile trovato ma illeggibile come JSON. Continuo con l'installazione."
    }
}

if ($IsAlreadyInstalled) {
    Write-Warning "---"
    Write-Warning "ATTENZIONE: Installazione già completata."
    Write-Warning "La configurazione 'mcp_server_toolkit' esiste già in $SettingsFile."
    Write-Warning "Se vuoi aggiornare, esegui lo script 'update.ps1'."
    Write-Warning "---"
    Stop-Transcript
    exit 1
}

# --- 1. Copia Workflows ---
Write-Host "Copying workflows..."
$WorkflowSource = Join-Path $ScriptDir "workflows\*"
$WorkflowDest = Join-Path $DxProjectPath ".a4drules\workflows\"
if (Test-Path $WorkflowSource) {
    # Assicura che la cartella di destinazione esista
    New-Item -Path $WorkflowDest -ItemType Directory -Force | Out-Null
    Copy-Item -Path $WorkflowSource -Destination $WorkflowDest -Recurse -Force
    Write-Host "Copied workflows to $WorkflowDest"
} else {
    Write-Host "Directory 'workflows' non trovata. Salto la copia."
}

# --- 2. Navigazione e Pulizia ---
New-Item -Path $McpDir -ItemType Directory -Force | Out-Null
Set-Location $McpDir
Write-Host "Changed to MCP directory: $PWD"

if (Test-Path $RepoName) {
    Write-Host "Found partial installation '$RepoName'. Cleaning up..."
    Set-DirectoryWriteable -Path $RepoName # Rimuovi sola lettura prima di eliminare
    Remove-Item -Path $RepoName -Recurse -Force
    Write-Host "Cleanup complete."
}

# --- 3. Clone e Build ---
Write-Host "Cloning repository..."
git clone https://github.com/franturino/mcp_server_toolkit.git
Write-Host "Repository cloned successfully!"

Set-Location $RepoPath
Write-Host "Current directory: $PWD"

Write-Host "Installing dependencies..."
npm install
Write-Host "Dependencies installed successfully!"

Write-Host "Building project..."
npm run build
Write-Host "Build completed successfully!"

# --- 4. Imposta Permessi Read-Only ---
Set-DirectoryReadOnly -Path "build"
Set-DirectoryReadOnly -Path "src"

# --- 5. Aggiornamento Configurazione JSON ---
New-Item -Path $SettingsDir -ItemType Directory -Force | Out-Null
Set-Location $SettingsDir
Write-Host "Changed to settings directory: $PWD"

# Assicura che il file esista e abbia una struttura base
if (!(Test-Path $SettingsFile)) {
    @{ mcpServers = @{} } | ConvertTo-Json | Set-Content $SettingsFile -Encoding UTF8
}

Write-Host "Updating $SettingsFile..."
$SettingsJson = Get-Content $SettingsFile -Raw | ConvertFrom-Json

# Crea il nuovo oggetto da aggiungere
$NewServerEntry = @{
    disabled = $false
    timeout  = 600
    type     = "stdio"
    command  = "node"
    args     = @(
        (Join-Path $RepoPath "build\index.js") # PowerShell usa '\'
    )
}

# Aggiungi il nuovo server (sovrascrive se esiste)
$SettingsJson.mcpServers.mcp_server_toolkit = $NewServerEntry

# Salva il file JSON
$SettingsJson | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
Write-Host "Updated $SettingsFile successfully!"


Write-Host "---"
Write-Host "INSTALLATION SCRIPT COMPLETED at $(Get-Date)"
Write-Host "Per aggiornare in futuro, esegui .\update.ps1"
Stop-Transcript