#!/bin/bash
set -e # Interrompe lo script se un comando fallisce

# --- Definizioni dei Percorsi ---
BASE_STORAGE_PATH="/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt"
MCP_DIR="$BASE_STORAGE_PATH/MCP"
SETTINGS_DIR="$BASE_STORAGE_PATH/settings"
SETTINGS_FILE="$SETTINGS_DIR/a4d_mcp_settings.json"
REPO_NAME="mcp_server_toolkit"
REPO_PATH="$MCP_DIR/$REPO_NAME"

# --- Logging ---
LOG_FILE="update_$(date '+%Y%m%d_%H%M%S').log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

echo "Starting Update Script at $(date)"

# --- Funzioni Helper per Permessi ---
set_permissions_readonly() {
    echo "Setting $1 and contents to read-only..."
    chmod -R a-w "$1"
    find "$1" -type d -exec chmod a+rx {} +
    find "$1" -type f -exec chmod a+r {} +
    echo "Permissions for $1 set to read-only."
}

set_permissions_writeable() {
    echo "Restoring write permission for $1 and contents..."
    chmod -R a+w "$1"
    find "$1" -type d -exec chmod a+rx {} +
    echo "Write restored for $1."
}

# --- Controllo Pre-Aggiornamento ---
echo "Checking for existing installation..."
if [ ! -d "$REPO_PATH" ] || ! ( [ -f "$SETTINGS_FILE" ] && jq -e '.mcpServers.mcp_server_toolkit' "$SETTINGS_FILE" > /dev/null 2>&1 ); then
    echo "---"
    echo "ATTENZIONE: Installazione non trovata."
    echo "La directory '$REPO_PATH' o la configurazione JSON non esistono."
    echo "Esegui prima lo script 'install.sh'."
    echo "---"
    exit 1
fi

# --- 1. Navigazione e Ripristino Permessi ---
cd "$REPO_PATH"
echo "Changed to repository directory: $PWD"

for d in "build" "src"; do
    if [ -d "$d" ]; then
        set_permissions_writeable "$d"
    else
        echo "Directory $d non trovata, salto ripristino permessi."
    fi
done

# --- 2. Aggiornamento e Build ---
echo "Pulling latest changes..."
git pull
echo "Repository updated successfully!"

echo "Installing dependencies (if any changed)..."
npm install 2>&1
echo "Dependencies installed."

echo "Building project..."
npm run build 2>&1
echo "Build completed successfully!"

# --- 3. Imposta Permessi Read-Only ---
for d in "build" "src"; do
    if [ -d "$d" ]; then
        set_permissions_readonly "$d"
    else
        echo "Directory $d non trovata, salto permessi."
    fi
done

echo "---"
echo "UPDATE SCRIPT COMPLETED at $(date)"