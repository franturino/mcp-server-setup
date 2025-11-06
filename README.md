# Installation Guide

This guide explains how to install and set up the MCP Server Toolkit for Salesforce.

## Prerequisites

- Node.js and npm installed
- Git installed
- Visual Studio Code or Salesforce Code Builder
- Windows (for PowerShell script) or Linux/Unix (for Bash script)

## Initial Setup

1. Open your terminal (PowerShell on Windows, or Code Builder terminal on Unix)
2. Clone the setup repository:
```bash
git clone https://github.com/franturino/mcp-server-setup.git
```
3. Navigate to the setup directory:
```bash
cd mcp-server-setup
```

## Installation Scripts

### Windows Installation (PowerShell)

The `setup.ps1` script automates the installation process in Windows environments:

1. Creates a log file with timestamp for tracking installation progress
2. Navigates to the MCP tools directory in VS Code
3. Checks if the repository already exists:
   - If yes: Updates the existing installation via `git pull`
   - If no: Performs a fresh installation:
     - Clones the repository
     - Installs npm dependencies
     - Builds the project
     - Configures the MCP server settings

#### Running the PowerShell Script

1. Open PowerShell as Administrator
2. Enable script execution (if not already enabled):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
3. Run the script:
```powershell
.\setup.ps1
```

### Unix/Linux Installation (Bash)

The `setup.sh` script automates the installation process. Here's what it does:

1. Creates a log file with timestamp for tracking installation progress
2. Navigates to the MCP tools directory in Code Builder
3. Checks if the repository already exists:
   - If yes: Updates the existing installation via `git pull`
   - If no: Performs a fresh installation:
     - Clones the repository
     - Installs npm dependencies
     - Builds the project
     - Configures the MCP server settings

#### Running the Script

1. Open your Code Builder terminal
2. Make the script executable:
```bash
chmod +x setup.sh
```

3. Run the script:
```bash
./setup.sh
```

### Logging

Both scripts create detailed log files in the format:
```
setup_YYYYMMDD_HHMMSS.log
```

This log contains all installation steps, commands output, and any potential errors.

## Manual Installation

If you prefer to install manually, follow these steps:

### Windows
1. Navigate to the MCP directory:
```powershell
cd $env:APPDATA\Code\User\globalStorage\salesforce.salesforcedx-einstein-gpt\MCP
```

2. Clone the repository:
```powershell
git clone https://github.com/franturino/mcp_server_toolkit.git
```

3. Install dependencies:
```powershell
cd mcp_server_toolkit
npm install
```

4. Build the project:
```powershell
npm run build
```

5. Configure MCP settings manually by adding the following to `a4d_mcp_settings.json`:
```json
{
    "mcpServers": {
        "mcp_server_toolkit": {
            "disabled": false,
            "timeout": 600,
            "type": "stdio",
            "command": "node",
            "args": [
                "$env:APPDATA\\Code\\User\\globalStorage\\salesforce.salesforcedx-einstein-gpt\\MCP\\mcp_server_toolkit\\build\\index.js"
            ]
        }
    }
}
```

### Unix/Linux
1. Navigate to the MCP directory:
```bash
cd /home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP
```

2. Clone the repository:
```bash
git clone https://github.com/franturino/mcp_server_toolkit.git
```

3. Install dependencies:
```bash
cd mcp_server_toolkit
npm install
```

4. Build the project:
```bash
npm run build
```

5. Configure MCP settings manually by adding the following to `a4d_mcp_settings.json`:
```json
{
    "mcpServers": {
        "mcp_server_toolkit": {
            "disabled": false,
            "timeout": 600,
            "type": "stdio",
            "command": "node",
            "args": [
                "/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP/mcp_server_toolkit/build/index.js"
            ]
        }
    }
}
```

## Troubleshooting

- Check the generated log file for detailed error messages
- Ensure all prerequisites are installed
- For Windows:
  - Verify PowerShell execution policy allows script execution
  - Check VS Code installation path
  - Ensure proper permissions in AppData directory
- For Unix/Linux:
  - Verify Code Builder environment accessibility
  - Check file permissions
- Check network connectivity for git and npm operations

## 🧠 Workflow: Recupera Defect per Sviluppatore

Questo workflow consente di recuperare i defect assegnati a uno sviluppatore, filtrati per uno o più stati specifici.

### 📥 Input

Il workflow accetta due input:

- `developer_name`: il nome dello sviluppatore
- `defect_states_input`: uno o più stati dei defect, separati da virgola

Gli stati devono essere tra quelli validi: New, Re-opened, Sospeso, Need More Information, Non Deployabile, Fix in Process,
Ready to Test, In Deployment, Deploy PREPROD, Ready to test - NEW INTEGRA,
Deploy SUPPORT, Ready to test - PREPROD, Ready to test - SUPPORT,
Closed - End of life, Closed - Duplicate, Closed - Rejected, Closed - Resolved,
Not a Defect, Deploy PROD

### ⚙️ Comportamento

- Se gli input vengono **passati direttamente nel prompt**, il workflow li utilizza senza richiederli.
  - Esempio:
    ```
    /recupera-defect-sviluppatore.md "Mario Rossi" "New,Ready to Test"
    ```
- Se uno o entrambi gli input **non sono presenti**, il workflow li richiede tramite prompt interattivo.
- Il workflow **valida gli stati** inseriti:
  - Se uno o più stati non sono validi, mostra un messaggio di errore.
  - Se tutti gli stati sono validi, invoca il server MCP `mcp_server_toolkit` con il metodo `getDefectsByDeveloperAndStatus`.

### 📤 Output

Il workflow crea un task che recupera i defect filtrati per sviluppatore e stato, utile per analisi, report o debugging.
