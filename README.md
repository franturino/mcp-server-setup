# 🚀 MCP Server Toolkit - Installation & Usage Guide

This guide explains how to install and set up the **MCP Server Toolkit** for Salesforce development. Choose the automated installation for your operating system for the easiest setup experience.

## 📋 Table of Contents

1. **[Prerequisites](#prerequisites)** - System requirements
2. **[Quick Start](#quick-start)** - Get started in 2 minutes
3. **[Installation Scripts](#installation-scripts)** - Automated setup (Recommended)
   - [Windows (PowerShell)](#windows-installation-powershell)
   - [Unix/Linux (Bash)](#unixlinux-installation-bash)
4. **[Update Scripts](#update-scripts)** - Keep your installation current
5. **[Manual Installation](#manual-installation)** - Step-by-step alternative
6. **[File Permission Management](#file-permission-management)** - Security and updates
7. **[JSON Configuration](#json-configuration-details)** - Server settings explained
8. **[Troubleshooting](#troubleshooting)** - Common issues and solutions
9. **[Available Workflows](#available-workflows)** - Automation tools included

---

## Prerequisites

Before starting, ensure you have:

- ✅ **Node.js** and **npm** installed ([download](https://nodejs.org/))
- ✅ **Git** installed ([download](https://git-scm.com/))
- ✅ **Visual Studio Code** or **Salesforce Code Builder**
- ✅ **Windows (PowerShell)** or **Linux/Unix (Bash)** terminal access
- ✅ Write permissions in your user directory

---

## Quick Start

### ⚡ Windows (PowerShell)

```powershell
# 1. Clone the setup repository
git clone https://github.com/franturino/mcp-server-setup.git
cd mcp-server-setup

# 2. Edit setup.ps1 - Update these variables:
#    - $BaseStoragePath: Your VS Code Server storage path
#    - $DxProjectPath: Your Salesforce dx-project path

# 3. Open PowerShell as Administrator and run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup.ps1

# 4. Wait for completion and check the log file
# Success! The MCP server is now installed and configured.
```

### ⚡ Unix/Linux (Bash)

```bash
# 1. Clone the setup repository
git clone https://github.com/franturino/mcp-server-setup.git
cd mcp-server-setup

# 2. Edit setup.sh - Update these variables:
#    - BASE_STORAGE_PATH: Your Code Server storage path
#    - DX_PROJECT_PATH (if needed): Your Salesforce dx-project path

# 3. Make scripts executable
chmod +x setup.sh update.sh

# 4. Run setup
./setup.sh

# 5. Wait for completion and check the log file
# Success! The MCP server is now installed and configured.
```

---

## Initial Setup

1. Open your terminal (PowerShell on Windows, or Bash on Unix/Linux)
2. Clone the setup repository:
```bash
git clone https://github.com/franturino/mcp-server-setup.git
```
3. Navigate to the setup directory:
```bash
cd mcp-server-setup
```

**⚠️ Important**: Before running the installation scripts, ensure that:
- Git is installed and accessible from your terminal
- Node.js and npm are installed
- You have write permissions for creating directories in the storage path
- (Windows only) PowerShell is running with Administrator privileges (required for scheduled tasks)

## Installation Scripts

### Windows Installation (PowerShell)

The `setup.ps1` script automates the entire installation process for Windows environments.

#### 📋 What the Script Does

| Step | Action |
|------|--------|
| 1️⃣ **Pre-Check** | Verifies that `mcp_server_toolkit` isn't already installed |
| 2️⃣ **Workflows Copy** | Copies workflow files to your dx-project `.a4drules/workflows/` directory |
| 3️⃣ **Repository Clone** | Clones the MCP server toolkit from GitHub |
| 4️⃣ **Dependencies** | Installs npm packages (`npm install`) |
| 5️⃣ **Build** | Compiles TypeScript to JavaScript (`npm run build`) |
| 6️⃣ **Read-Only Protection** | Sets `build/` and `src/` directories to read-only for safety |
| 7️⃣ **Configuration** | Updates `a4d_mcp_settings.json` with server settings |
| 8️⃣ **Logging** | Creates detailed log file for troubleshooting |

#### ⚙️ Configuration Before Installation

Edit `setup.ps1` and modify these variables:

```powershell
$BaseStoragePath = "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt"
$DxProjectPath = "C:\Users\codebuilder\dx-project"
```

Replace with your actual paths:
- **$BaseStoragePath**: Path to VS Code Server storage (check in VS Code settings)
- **$DxProjectPath**: Path to your Salesforce dx-project directory

#### 🚀 Running the PowerShell Script

```powershell
# 1. Open PowerShell as Administrator (required for scheduler permissions)
#    Right-click PowerShell → Run as Administrator

# 2. Enable script execution (if not already enabled)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 3. Navigate to the setup directory
cd C:\path\to\mcp-server-setup

# 4. Run the installation
.\setup.ps1

# 5. Monitor the output - wait for "INSTALLATION SCRIPT COMPLETED"
```

#### 📊 What Gets Created

After successful installation:

```
$BaseStoragePath/
├── MCP/
│   └── mcp_server_toolkit/          ← Cloned repository
│       ├── build/                   ← Compiled JavaScript (read-only)
│       ├── src/                     ← TypeScript source (read-only)
│       ├── package.json
│       └── ...other files
└── settings/
    └── a4d_mcp_settings.json        ← Updated with server config
```

#### ✅ Verify Installation Success

1. Check the **log file** in the script directory (`install_YYYYMMDD_HHMMSS.log`)
2. Verify `a4d_mcp_settings.json` contains the `mcp_server_toolkit` configuration
3. Restart VS Code or Code Builder
4. The MCP server should now be active

---

### Unix/Linux Installation (Bash)

The `setup.sh` script automates the entire installation process for Unix/Linux environments.

#### 📋 What the Script Does

| Step | Action |
|------|--------|
| 1️⃣ **Pre-Check** | Verifies that `mcp_server_toolkit` isn't already installed |
| 2️⃣ **Workflows Copy** | Copies workflow files to your dx-project `.a4drules/workflows/` directory |
| 3️⃣ **Repository Clone** | Clones the MCP server toolkit from GitHub |
| 4️⃣ **Dependencies** | Installs npm packages (`npm install`) |
| 5️⃣ **Build** | Compiles TypeScript to JavaScript (`npm run build`) |
| 6️⃣ **Configuration** | Updates `a4d_mcp_settings.json` with server settings |
| 7️⃣ **Logging** | Creates detailed log file for troubleshooting |

#### ⚙️ Configuration Before Installation

Edit `setup.sh` and verify these variables match your environment:

```bash
BASE_STORAGE_PATH="/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt"
```

If your Code Server storage is in a different location, update the path accordingly.

#### 🚀 Running the Bash Script

```bash
# 1. Navigate to the setup directory
cd /path/to/mcp-server-setup

# 2. Make scripts executable
chmod +x setup.sh update.sh

# 3. Run the installation
./setup.sh

# 4. Monitor the output - wait for "INSTALLATION SCRIPT COMPLETED"
```

#### 📊 What Gets Created

After successful installation:

```
$BASE_STORAGE_PATH/
├── MCP/
│   └── mcp_server_toolkit/          ← Cloned repository
│       ├── build/                   ← Compiled JavaScript
│       ├── src/                     ← TypeScript source
│       ├── package.json
│       └── ...other files
└── settings/
    └── a4d_mcp_settings.json        ← Updated with server config
```

#### ✅ Verify Installation Success

1. Check the **log file** in the script directory (`install_YYYYMMDD_HHmmss.log`)
2. Verify `a4d_mcp_settings.json` contains the `mcp_server_toolkit` configuration
3. Restart VS Code or Code Builder
4. The MCP server should now be active

## Update Scripts

### 🔄 Purpose

After initial installation, use the `update.ps1` (Windows) or `update.sh` (Unix/Linux) scripts to:
- ✅ Pull the latest changes from GitHub
- ✅ Reinstall/update npm dependencies
- ✅ Rebuild the project with new code
- ✅ Maintain file permissions automatically

### 📋 Update Script Workflow

#### Pre-Update Checks
```
1. Verifies installation exists at $REPO_PATH
2. Checks if mcp_server_toolkit is configured in a4d_mcp_settings.json
3. Exits with error if installation not found (must run setup.ps1/sh first)
```

#### Update Process
```
1. Restores write permissions to build/ and src/ directories
2. Pulls latest changes from GitHub (git pull)
3. Installs/updates npm dependencies (npm install)
4. Rebuilds the project (npm run build)
5. Resets directories to read-only for protection
6. Creates timestamped log file with all details
```

### 🚀 Running the Update Scripts

#### Windows (PowerShell)
```powershell
# Open PowerShell and run:
cd C:\path\to\mcp-server-setup
.\update.ps1

# Check the log file for completion:
# update_YYYYMMDD_HHMMSS.log
```

#### Unix/Linux (Bash)
```bash
# Navigate and run:
cd /path/to/mcp-server-setup
./update.sh

# Check the log file for completion:
# update_YYYYMMDD_HHmmss.log
```

### 📅 Automatic Updates

The scripts do **NOT** automatically configure scheduled tasks or cron jobs. Manual updates are required:

**Why this design?**
- More control over when updates occur
- Avoids conflicts with active development
- Predictable behavior without background tasks
- Simpler troubleshooting

**Recommendation**: Schedule updates manually using your system's task scheduler or set reminder to run update scripts periodically.

## Manual Installation

If you prefer to install manually without scripts, or need to troubleshoot, follow these step-by-step instructions:

### Windows (Manual Steps)

#### Step 1: Clone the Repository
```powershell
# Navigate to your MCP directory
$McpPath = "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt\MCP"
New-Item -Path $McpPath -ItemType Directory -Force | Out-Null
Set-Location $McpPath

# Clone the repository
git clone https://github.com/franturino/mcp_server_toolkit.git
cd mcp_server_toolkit
```

#### Step 2: Install Dependencies
```powershell
npm install
```

#### Step 3: Build the Project
```powershell
npm run build
```

#### Step 4: Copy Workflows (Optional)
```powershell
# Copy workflow files to your dx-project
Copy-Item -Path "workflows\*" -Destination "C:\Users\codebuilder\dx-project\.a4drules\workflows\" -Recurse -Force
```

#### Step 5: Configure MCP Settings
Edit or create `a4d_mcp_settings.json` at:
```
C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt\settings\a4d_mcp_settings.json
```

Add or update with:
```json
{
    "mcpServers": {
        "mcp_server_toolkit": {
            "disabled": false,
            "timeout": 600,
            "type": "stdio",
            "command": "node",
            "args": [
                "C:\\Users\\codebuilder\\.vscode-server\\data\\User\\globalStorage\\salesforce.salesforcedx-einstein-gpt\\MCP\\mcp_server_toolkit\\build\\index.js"
            ]
        }
    }
}
```

### Unix/Linux (Manual Steps)

#### Step 1: Clone the Repository
```bash
# Navigate to your MCP directory
export MCP_PATH="/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP"
mkdir -p "$MCP_PATH"
cd "$MCP_PATH"

# Clone the repository
git clone https://github.com/franturino/mcp_server_toolkit.git
cd mcp_server_toolkit
```

#### Step 2: Install Dependencies
```bash
npm install
```

#### Step 3: Build the Project
```bash
npm run build
```

#### Step 4: Copy Workflows (Optional)
```bash
# Copy workflow files to your dx-project
cp workflows/* /home/codebuilder/dx-project/.a4drules/workflows/
```

#### Step 5: Configure MCP Settings
Edit or create `a4d_mcp_settings.json` at:
```
/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/settings/a4d_mcp_settings.json
```

Add or update with:
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

#### Step 6: Set Read-Only Permissions (Recommended)
```bash
chmod -R a-w build src
find build src -type d -exec chmod a+rx {} +
find build src -type f -exec chmod a+r {} +
```

---

## File Permission Management

The scripts implement security through file permissions, automatically managing access to critical files.

### Why File Permissions Matter

After building the project, the `src/` and `build/` directories are important:
- **They contain compiled and source code** that shouldn't be accidentally modified
- **Read-only protection prevents accidental changes** during normal development
- **Updates need temporary write access** to pull and rebuild new code

### Permission Workflow

#### ✅ Initial Installation
1. Build completes successfully
2. Directories **set to read-only** automatically
3. Protects against accidental modifications

#### 🔄 During Updates
1. `update.ps1`/`update.sh` restores **write permissions**
2. Pulls latest changes and rebuilds
3. Automatically resets to **read-only** when done
4. Transparent to the user - happens automatically!

### Manual Permission Changes

If needed, you can change permissions manually:

#### Windows (PowerShell)

```powershell
# Make writeable (to edit files)
Get-ChildItem -Path "C:\path\to\build" -Recurse | Set-ItemProperty -Name IsReadOnly -Value $false

# Make read-only (for protection)
Get-ChildItem -Path "C:\path\to\build" -Recurse | Set-ItemProperty -Name IsReadOnly -Value $true
```

#### Unix/Linux (Bash)

```bash
# Make writeable (to edit files)
chmod -R a+w /path/to/build

# Make read-only (for protection)
chmod -R a-w /path/to/build
find /path/to/build -type d -exec chmod a+rx {} +
find /path/to/build -type f -exec chmod a+r {} +
```

---

## JSON Configuration Details

After installation, the MCP server is configured in your VS Code settings via the `a4d_mcp_settings.json` file.

### Configuration Location

- **Windows**: `C:\Users\<username>\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt\settings\a4d_mcp_settings.json`
- **Unix/Linux**: `/home/<username>/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/settings/a4d_mcp_settings.json`

### Configuration Structure

```json
{
    "mcpServers": {
        "mcp_server_toolkit": {
            "disabled": false,
            "timeout": 600,
            "type": "stdio",
            "command": "node",
            "args": [
                "/path/to/mcp_server_toolkit/build/index.js"
            ]
        }
    }
}
```

### Configuration Parameters Explained

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `disabled` | `false` | Enables the MCP server (set to `true` to disable) |
| `timeout` | `600` | Timeout in seconds (10 minutes) for MCP operations |
| `type` | `"stdio"` | Communication method (standard input/output) |
| `command` | `"node"` | Runtime executable (Node.js) |
| `args` | `[...]` | Path to the server entry point (`build/index.js`) |

### Modifying Configuration

If you need to modify the configuration:

1. **Locate the file** using the paths above
2. **Edit the JSON** with a text editor
3. **Save the file**
4. **Restart VS Code or Code Builder** for changes to take effect

⚠️ **Important**: Keep the JSON syntax valid! Invalid JSON will prevent the server from loading.

---

## Troubleshooting

### 🔍 Pre-Installation Checks

Before running the installation script, verify:

- [ ] Git is installed: `git --version`
- [ ] Node.js is installed: `node --version`
- [ ] npm is installed: `npm --version`
- [ ] You have write permissions in your user directory
- [ ] (Windows) PowerShell is running as Administrator

### ❌ Common Issues and Solutions

#### ✘ "Installation already completed" Error

**What it means**: The script detected an existing installation.

**Solutions**:
- **To update**: Run the update script instead (`update.ps1` or `update.sh`)
- **To reinstall**: Manually delete the old installation and run setup again
  ```powershell
  # Windows
  Remove-Item -Path "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt\MCP\mcp_server_toolkit" -Recurse -Force
  ```
  ```bash
  # Unix/Linux
  rm -rf ~/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP/mcp_server_toolkit
  ```

---

#### ✘ PowerShell Execution Policy Error

**Error message**:
```
cannot be loaded because running scripts is disabled on this system
```

**Solution**: Enable script execution:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then run the setup script again.

---

#### ✘ "Permission denied" Error (Unix/Linux)

**Error message**:
```
Permission denied: ./setup.sh
./setup.sh: command not found
```

**Solution**: Make the script executable:
```bash
chmod +x setup.sh update.sh
```

---

#### ✘ Git Not Found

**Error message**:
```
git is not recognized | git: command not found
```

**Solutions**:
1. Install Git from https://git-scm.com/
2. Restart your terminal
3. Verify installation: `git --version`

On **Windows**, ensure Git is in your system PATH:
- Right-click on "This PC" → Properties
- Click "Advanced system settings"
- Click "Environment Variables"
- Check that Git's `bin` folder is in the PATH

---

#### ✘ npm Install Fails

**Error message**:
```
npm ERR! code E... | npm ERR! 404 | npm ERR! network ...
```

**Solutions**:
1. Check internet connectivity
2. Clear npm cache: `npm cache clean --force`
3. Delete `node_modules` and `package-lock.json`:
   ```bash
   rm -rf node_modules package-lock.json
   npm install
   ```
4. Check npm version: `npm --version` (should be recent)

---

#### ✘ Build Process Fails

**Error message** (during `npm run build`):
```
error TS... | Error: Cannot find module 'typescript'
```

**Solutions**:
1. Ensure dependencies are installed: `npm install`
2. Check for TypeScript installation: `npm list typescript`
3. Try rebuilding: `npm run build`

---

#### ✘ Settings File Not Found or Invalid JSON

**Error message**:
```
File not found: a4d_mcp_settings.json | Invalid JSON | parse error
```

**Solutions**:
1. **Verify the file exists** at the correct path (check the setup output)
2. **If missing**, create it manually with valid JSON:
   ```json
   {
       "mcpServers": {
           "mcp_server_toolkit": {
               "disabled": false,
               "timeout": 600,
               "type": "stdio",
               "command": "node",
               "args": ["...full path to build/index.js..."]
           }
       }
   }
   ```
3. **If invalid JSON**, check for:
   - Missing commas between properties
   - Unmatched braces or brackets
   - Incorrect quote types
4. Use a JSON validator: https://jsonlint.com/

---

#### ✘ MCP Server Not Active in VS Code

**What to check**:

1. **Verify configuration exists**:
   - Open your `a4d_mcp_settings.json`
   - Ensure `"disabled": false`

2. **Check the path is correct**:
   - Verify the path in `args` actually exists
   - Ensure `build/index.js` is present

3. **Check the output channel**:
   - Open VS Code Output panel
   - Select "MCP Server Toolkit" from dropdown
   - Look for error messages

4. **Restart VS Code**:
   ```
   Close VS Code completely and reopen it
   (not just reload window)
   ```

5. **Check log files**:
   - Look for errors in the installation/update log files
   - These are created in the setup script directory

---

### 📋 Verification Checklist

After installation, verify everything works:

- [ ] Log file shows "INSTALLATION SCRIPT COMPLETED"
- [ ] `a4d_mcp_settings.json` contains the `mcp_server_toolkit` configuration
- [ ] `build/build/index.js` file exists and is readable
- [ ] Directories `build/` and `src/` exist
- [ ] (Windows) Check Task Scheduler for any issues (if scheduled tasks were created)
- [ ] VS Code/Code Builder shows no errors in the Output panel
- [ ] Restart the editor and MCP server loads successfully

---

### � Check Installation Manually

#### Windows (PowerShell)
```powershell
# Verify repository exists
Test-Path "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt\MCP\mcp_server_toolkit"

# Verify build files exist
Test-Path "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt\MCP\mcp_server_toolkit\build\index.js"

# Check configuration
Get-Content "C:\Users\codebuilder\.vscode-server\data\User\globalStorage\salesforce.salesforcedx-einstein-gpt\settings\a4d_mcp_settings.json" | ConvertFrom-Json
```

#### Unix/Linux (Bash)
```bash
# Verify repository exists
test -d ~/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP/mcp_server_toolkit && echo "Directory exists" || echo "Directory missing"

# Verify build files exist
test -f ~/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP/mcp_server_toolkit/build/index.js && echo "File exists" || echo "File missing"

# Check configuration
cat ~/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/settings/a4d_mcp_settings.json | jq
```

---

````

## 🛠️ Workflow: Update Defect Status with Validation

This workflow allows you to update the status of a defect, verifying that the provided status is among the allowed values.

### 📥 Input

The workflow accepts two inputs:

- `defect_code`: the defect code to update (e.g., D-123)
- `defect_status`: the status to assign to the defect

Valid statuses include:

New, Re-opened, Sospeso, Need More Information, Non Deployabile, Fix in Process,
Ready to Test, In Deployment, Deploy PREPROD, Ready to test - NEW INTEGRA,
Deploy SUPPORT, Ready to test - PREPROD, Ready to test - SUPPORT,
Closed - End of life, Closed - Duplicate, Closed - Rejected, Closed - Resolved,
Not a Defect, Deploy PROD

### ⚙️ Behavior

- If the inputs are **provided directly in the prompt**, the workflow uses them without asking.
  - Example:
    ```
    /aggiorna-stato-defect.md "D-123" "Ready to Test"
    ```
- If one or both inputs are **missing**, the workflow will prompt the user interactively.
- The workflow **validates the status**:
  - If the status is invalid, it displays an error message with the list of allowed statuses.
  - If the status is valid, it invokes the MCP server `mcp_server_toolkit` using the method `updateDefectStatus`.

### 📤 Output

The workflow creates a task that updates the status of the specified defect, useful for operational management and change tracking.

## 📋 Workflow: Retrieve Multiple Defect Details

This workflow allows you to retrieve details for one or more defects specified by the user.

### 📥 Input

The workflow accepts one input:

- `defect_codes`: a list of defect codes separated by commas (e.g., `D-123,D-456,D-789`)

### ⚙️ Behavior

- If the `defect_codes` input is **provided directly in the prompt**, the workflow uses it without asking.
  - Example:
    ```
    /richiedi-defect-details.md "D-123,D-456"
    ```
- If the input is **missing**, the workflow will prompt the user interactively.
- The workflow loops through each provided code and creates a task to retrieve defect details using the MCP server `mcp_server_toolkit`.

### 📤 Output

For each code provided, the workflow creates a task that invokes the `getDefectDetails` method on the MCP server, useful for analysis, debugging, or tracking.

## 🧾 Workflow: Insert Manual Configuration

This workflow allows you to insert a manual configuration in Salesforce, associated with a specific defect, using the MCP server.

### 📥 Input

The workflow accepts two inputs:

- `defect_code`: the defect code (e.g., D-123)
- `config_note`: the note to associate with the manual configuration

### ⚙️ Behavior

- If the inputs are **provided directly in the prompt**, the workflow uses them without asking.
  - Example:
    ```
    /inserisci-configurazione-manuale.md "D-123" "Configuration required for test environment"
    ```
- If one or both inputs are **missing**, the workflow will prompt the user interactively.
- Once the data is collected, the workflow invokes the MCP server `mcp_server_toolkit` using the method `insertManualConfiguration`.

### 📤 Output

The workflow creates a task that records the manual configuration associated with the specified defect, useful for change tracking and technical management.

## 🧾 Workflow: Create Metadata for Import to Salesforce

This workflow allows you to create a metadata record for importing data into a specific Salesforce table using external codes. It interacts with the MCP server tool `create_metadata_for_import_salesforce`.

### 📥 Input

The workflow accepts the following inputs:

- `defectId` *(optional)*: The ID of the Defect__c record (e.g., `a1B0500000abcdeAAA`)
- `defectName` *(optional)*: The name/code of the defect (e.g., `D-123`)
- `tableName`: The name of the table where records will be imported
- `externalCodesInput`: A comma-separated list of external codes to associate with the metadata

### ⚙️ Behavior

- If the inputs are **provided directly in the prompt**, the workflow uses them without asking.
  - Example:
    ```
    /crea-metadata-import-salesforce.md "D-123" "ImportTable__c" "codeA,codeB,codeC"
    ```
- If one or more inputs are **missing**, the workflow will prompt the user interactively.
- The workflow converts the external codes into an array and invokes the MCP server tool `create_metadata_for_import_salesforce`.

### 📤 Output

The workflow creates a task that inserts a `NDC_XMLObject__c` record in Salesforce, associating it with the specified defect and external codes. The result includes a success or error message returned by the MCP server.

This workflow is useful for automating metadata creation for bulk imports and ensuring traceability through defect linkage.

## 📊 Workflow: Query Metadata by Defect in Salesforce

This workflow allows you to retrieve metadata records associated with a specific defect in Salesforce, using either the defect ID or its code. It interacts with the MCP server tool `query_metadata_by_defect_salesforce`.

### 📥 Input

The workflow accepts the following inputs:

- `defectId` *(optional)*: The ID of the Defect__c record (e.g., `a1B0500000abcdeAAA`)
- `defectCode` *(optional)*: The code of the defect (e.g., `D-123`)

### ⚙️ Behavior

- If the inputs are **provided directly in the prompt**, the workflow uses them without asking.
  - Example:
    ```
    /query-metadata-by-defect.md "D-123"
    ```
- If neither input is provided, the workflow will prompt the user to enter either the defect ID or code.
- The workflow invokes the MCP server tool `query_metadata_by_defect_salesforce`, which:
  - Resolves the defect ID if only the code is provided
  - Queries all metadata records (`NDC_XMLObject__c`) linked to the defect
  - Returns the result in JSON format

### 📤 Output

### 📤 Output

The workflow creates a task that returns the metadata records associated with the specified defect. This is useful for tracking, auditing, or validating import configurations.

---

## Available Workflows

The toolkit includes pre-configured workflows for managing defects and metadata in Salesforce. Each workflow is defined as a Markdown file in the `workflows/` directory.

### 📋 Workflow List

| Workflow File | Purpose | Inputs |
|---------------|---------|--------|
| `retrieve-metadata-of-defect.md` | Query metadata associated with a defect | Defect ID or Code |
| `update-status-defect.md` | Update defect status with validation | Defect Code, New Status |
| `get-detect_details.md` | Retrieve details for one or more defects | Comma-separated defect codes |
| `get-defect_details_by_status_and_developer.md` | Get defects by developer and status filter | Developer Name, Status(es) |
| `insert-confmanuale.md` | Insert manual configuration for a defect | Defect Code, Configuration Note |
| `create_metadata_defect.md` | Create metadata record for Salesforce import | Defect ID/Code, Table Name, External Codes |
| `insert-ExternalCode.md` | Link external codes to defect metadata | Defect Code, External Code List |

### 🔄 Workflow Features

All workflows include:
- ✅ **Interactive prompts** - Request user input if not provided
- ✅ **Input validation** - Check for allowed values
- ✅ **Error handling** - Display clear error messages
- ✅ **MCP integration** - Use the `mcp_server_toolkit` for backend operations

### 📥 Using Workflows

#### In Salesforce Code Builder

```
/workflow-name.md [arg1] [arg2]
```

**Example** (provide all arguments):
```
/update-status-defect.md "D-123" "Ready to Test"
```

**Example** (let workflow prompt for missing arguments):
```
/update-status-defect.md
# Workflow will ask: "Enter Defect Code: ", then "Enter Status: "
```

#### Common Workflow Parameters

**Valid Defect Statuses**:
```
New, Re-opened, Sospeso, Need More Information, Non Deployabile, 
Fix in Process, Ready to Test, In Deployment, Deploy PREPROD, 
Ready to test - NEW INTEGRA, Deploy SUPPORT, Ready to test - PREPROD, 
Ready to test - SUPPORT, Closed - End of life, Closed - Duplicate, 
Closed - Rejected, Closed - Resolved, Not a Defect, Deploy PROD
```

---

## 📞 Support & Documentation

### Getting Help

1. **Check the log files** - Located in the setup script directory
   - `install_YYYYMMDD_HHMMSS.log` - Installation log
   - `update_YYYYMMDD_HHMMSS.log` - Update log

2. **Review the Troubleshooting section above** - Solutions for common issues

3. **Verify your installation** - Use the checklist in Troubleshooting → Verification Checklist

4. **Check file permissions** - Especially important on Unix/Linux systems

### Repository Links

- 📦 **MCP Server Toolkit**: https://github.com/franturino/mcp_server_toolkit
- 🛠️ **Setup Scripts**: https://github.com/franturino/mcp-server-setup
- 🐛 **Report Issues**: Create an issue on GitHub

### Key Features Summary

✅ **Automated Installation** - Single command setup  
✅ **Simple Updates** - Pull latest changes anytime  
✅ **File Protection** - Automatic read-only management  
✅ **Workflow Tools** - Pre-built automation workflows  
✅ **Detailed Logging** - Complete audit trail  
✅ **Salesforce Integration** - Full MCP server support  
✅ **Cross-Platform** - Works on Windows, Linux, and macOS  

---

## 📝 After Installation

### First Steps

1. ✅ Verify MCP server is active in VS Code
2. ✅ Restart VS Code or Code Builder
3. ✅ Check workflows are available (try `/` to see list)
4. ✅ Run a simple workflow to test

### Regular Maintenance

- **Monthly**: Run `update.ps1` or `update.sh` to get latest features
- **As needed**: Check log files for warnings or errors
- **Periodically**: Verify file permissions are correct

### Staying Updated

The update scripts keep you current with:
- Latest bug fixes
- New features and workflows
- Security updates
- Dependency updates

Simply run the update script whenever you want the latest version!

---

**Last Updated**: November 12, 2025  
**Version**: 2.1 (Complete Installation & Usage Guide)
