#!/bin/bash
set -e # Interrompe lo script se un comando fallisce

# --- Determina i percorsi assoluti degli script ---
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# --- Definizioni dei Percorsi ---
BASE_STORAGE_PATH="/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt"
MCP_DIR="$BASE_STORAGE_PATH/MCP"
SETTINGS_DIR="$BASE_STORAGE_PATH/settings"
SETTINGS_FILE="$SETTINGS_DIR/a4d_mcp_settings.json"
REPO_NAME="mcp_server_toolkit"
REPO_PATH="$MCP_DIR/$REPO_NAME"

# --- Logging ---
LOG_FILE="$SCRIPT_DIR/install_$(date '+%Y%m%d_%H%M%S').log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

echo "Starting Installation Script at $(date)"
echo "Script directory identified as: $SCRIPT_DIR"

# --- Funzione Helper per Permessi ---
set_permissions_readonly() {
    echo "Setting $1 and contents to read-only..."
    chmod -R a-w "$1"
    # Assicura che le directory siano attraversabili e i file leggibili
    find "$1" -type d -exec chmod a+rx {} +
    find "$1" -type f -exec chmod a+r {} +
    echo "Permissions for $1 set to read-only."
}

# --- Controllo Pre-Installazione ---
echo "Checking for existing configuration in $SETTINGS_FILE..."
if [ -f "$SETTINGS_FILE" ] && jq -e '.mcpServers.mcp_server_toolkit' "$SETTINGS_FILE" > /dev/null 2>&1; then
    echo "---"
    echo "ATTENZIONE: Installazione già completata."
    echo "La configurazione 'mcp_server_toolkit' esiste già in $SETTINGS_FILE."
    echo "Se vuoi aggiornare, esegui lo script 'update.sh'."
    echo "---"
    exit 1
fi

# --- 1. Copia Workflows ---
echo "Copying workflows..."
if [ -d "workflows" ]; then
    # (Assicuriamoci che la destinazione esista anche al primo avvio)
    mkdir -p /home/codebuilder/dx-project/.a4drules/workflows/
    cp workflows/* /home/codebuilder/dx-project/.a4drules/workflows/
    echo "Copied workflows to /home/codebuilder/dx-project/.a4drules/workflows/"
else
    echo "Directory 'workflows' non trovata. Salto la copia."
fi

# --- 2. Navigazione e Pulizia ---
# (Crea le directory se non esistono)
mkdir -p "$MCP_DIR"
cd "$MCP_DIR"
echo "Changed to MCP directory: $PWD"

# Pulizia di un'eventuale installazione parziale
if [ -d "$REPO_NAME" ]; then
    echo "Found partial installation '$REPO_NAME'. Cleaning up..."
    chmod -R a+w "$REPO_NAME" # Assicura i permessi per eliminare
    rm -rf "$REPO_NAME"
    echo "Cleanup complete."
fi

# --- 3. Clone e Build ---
echo "Cloning repository..."
git clone https://github.com/franturino/mcp_server_toolkit.git
echo "Repository cloned successfully!"

cd "$REPO_NAME"
echo "Current directory: $PWD"

echo "Installing dependencies..."
npm install 2>&1
echo "Dependencies installed successfully!"

echo "Building project..."
npm run build 2>&1
echo "Build completed successfully!"

# --- 4. Imposta Permessi Read-Only (Opzionale) ---
echo "Skipping read-only permissions setting."


# --- 5. Aggiornamento Configurazione JSON ---
mkdir -p "$SETTINGS_DIR"
cd "$SETTINGS_DIR"
echo "Changed to settings directory: $PWD"

# (Assicurati che il file esista)
touch "$SETTINGS_FILE"

echo "Updating $SETTINGS_FILE..."
jq '.mcpServers += {
    "mcp_server_toolkit": {
        "disabled": false,
        "timeout": 600,
        "type": "stdio",
        "command": "node",
        "args": [
            "'"$REPO_PATH"'/build/index.js"
        ]
    }
}' "$SETTINGS_FILE" > temp.json && mv temp.json "$SETTINGS_FILE"

echo "Updated $SETTINGS_FILE successfully!"

echo "---"
echo "INSTALLATION SCRIPT COMPLETED at $(date)"
echo "Per aggiornare in futuro, esegui ./update.sh"