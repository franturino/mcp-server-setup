#!/bin/bash
set -e # Interrompe lo script se un comando fallisce

# --- Determina i percorsi assoluti degli script ---
# Questa è la directory del "setup repo"
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# --- Definizioni dei Percorsi ---
# La sorgente è la cartella 'workflows' che si trova accanto a questo script
SOURCE_WORKFLOWS_DIR="$SCRIPT_DIR/workflows"
# La destinazione è la cartella del progetto DX
TARGET_WORKFLOWS_DIR="/home/codebuilder/dx-project/.a4drules/workflows/"

# --- Logging ---
LOG_FILE="$SCRIPT_DIR/update_$(date '+%Y%m%d_%H%M%S').log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

echo "Starting Update Script at $(date)"
echo "Script (e setup repository) directory identified as: $SCRIPT_DIR"

# --- 1. Controllo Esistenza Repository ---
echo "Checking if setup repository is valid..."
if [ ! -d "$SCRIPT_DIR/.git" ]; then
    echo "---"
    echo "ERRORE: Questa directory non sembra essere un repository Git."
    echo "Impossibile eseguire 'git pull'."
    echo "Percorso controllato: $SCRIPT_DIR"
    echo "---"
    exit 1
fi

# --- 2. Git Pull (Sul Setup Repo) ---
echo "Changing directory to $SCRIPT_DIR"
cd "$SCRIPT_DIR"

echo "Pulling latest changes for setup repo (to update workflows)..."
git pull
echo "Git pull completed."

# --- 3. Copia Workflows ---
echo "Checking for source workflows at $SOURCE_WORKFLOWS_DIR..."
if [ -d "$SOURCE_WORKFLOWS_DIR" ]; then
    echo "Source 'workflows' directory found."
    
    # Assicura che la destinazione esista
    mkdir -p "$TARGET_WORKFLOWS_DIR"
    
    echo "Copying updated workflows to $TARGET_WORKFLOWS_DIR..."
    # 'cp -f' forza la sovrascrittura se i file esistono già
    cp -f "$SOURCE_WORKFLOWS_DIR"/* "$TARGET_WORKFLOWS_DIR"
    
    echo "Workflows copied successfully."
else
    echo "Warning: Source directory '$SOURCE_WORKFLOWS_DIR' not found."
    echo "Skipping workflow copy."
fi

echo "---"
echo "WORKFLOW UPDATE SCRIPT COMPLETED at $(date)"