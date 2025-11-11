# Installation Guide

This guide explains how to install and set up the MCP Server Toolkit for Salesforce.

## 📋 Table of Contents

1. **[Prerequisites](#prerequisites)** - System requirements
2. **[Initial Setup](#initial-setup)** - Getting started
3. **[Installation Scripts](#installation-scripts)** - Automated setup (Recommended)
   - [Windows (PowerShell)](#windows-installation-powershell)
   - [Unix/Linux (Bash)](#unixlinux-installation-bash)
4. **[Update Scripts](#update-scripts)** - Keep your installation current
5. **[Manual Installation](#manual-installation)** - Step-by-step alternative
6. **[File Permission Management](#file-permission-management)** - Security and updates
7. **[JSON Configuration](#json-configuration-details)** - Server settings explained
8. **[Troubleshooting](#troubleshooting)** - Common issues and solutions
9. **[Workflows](#workflows-overview)** - Available automation workflows

---

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

**⚠️ Important**: Before running the installation scripts, ensure that:
- Git is installed and accessible from your terminal
- Node.js and npm are installed
- You have the necessary permissions to create directories in the storage path
- (Windows only) PowerShell is running with Administrator privileges

## Installation Scripts

### Windows Installation (PowerShell)

The `setup.ps1` script automates the installation process in Windows environments:

#### What the Script Does

1. **Creates a log file** with timestamp for tracking installation progress
   - Format: `install_YYYYMMDD_HHMMSS.log`
2. **Pre-Installation Checks**:
   - Checks if `mcp_server_toolkit` is already configured in `a4d_mcp_settings.json`
   - If found, exits with an alert to run `update.ps1` instead
3. **Workflows Directory Setup**:
   - Copies workflows from the `workflows/` directory to your dx-project
4. **Repository Management**:
   - Cleans up any partial installations
   - Clones the `mcp_server_toolkit` repository
   - Installs npm dependencies
   - Builds the project
5. **Permission Management**:
   - Sets directories to read-only for protection
6. **Configuration**:
   - Creates/updates `a4d_mcp_settings.json` with MCP server settings
7. **Scheduled Tasks**:
   - Creates two scheduled tasks:
     - **MCP_Server_Toolkit_Update**: Runs `update.ps1` at 5:00 AM and 11:00 PM daily
     - **MCP_Server_Setup_Pull_And_Copy**: Pulls latest workflows and copies them at 5:00 AM and 11:00 PM daily

#### Running the PowerShell Script

1. **Open PowerShell as Administrator**
   - This is required for setting up scheduled tasks
2. **Enable script execution** (if not already enabled):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
3. **Modify paths in the script** (if needed):
   - Edit `setup.ps1` and update these variables:
     - `$BaseStoragePath`: Path to VS Code Server storage
     - `$DxProjectPath`: Path to your dx-project directory
     - `$GitPullDir`: Path to the mcp-server-setup repository
4. **Run the script**:
```powershell
.\setup.ps1
```
5. **Check the log file** for any errors or warnings

### Unix/Linux Installation (Bash)

The `setup.sh` script automates the installation process. Here's what it does:

#### What the Script Does

1. **Creates a log file** with timestamp for tracking installation progress
   - Format: `install_YYYYMMDD_HHMMSS.log`
2. **Pre-Installation Checks**:
   - Checks if `mcp_server_toolkit` is already configured in `a4d_mcp_settings.json`
   - If found, exits with an alert to run `update.sh` instead
3. **Workflows Directory Setup**:
   - Copies workflows from the `workflows/` directory to your dx-project
4. **Repository Management**:
   - Creates necessary directories if they don't exist
   - Cleans up any partial installations
   - Clones the `mcp_server_toolkit` repository
   - Installs npm dependencies
   - Builds the project
5. **Configuration**:
   - Creates/updates `a4d_mcp_settings.json` with MCP server settings
6. **Scheduled Jobs**:
   - Creates two cron jobs that run at 5:00 AM and 11:00 PM daily:
     - **Update job**: Runs `update.sh` to pull latest changes and rebuild
     - **Workflow sync job**: Pulls latest workflows and copies them to dx-project

#### Running the Script

1. **Make the script executable**:
```bash
chmod +x setup.sh
```
2. **Modify paths in the script** (if needed):
   - Edit `setup.sh` and update these variables if using different paths:
     - `BASE_STORAGE_PATH`: Path to Code Server storage
     - Default: `/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt`
3. **Run the script**:
```bash
./setup.sh
```
   - For cron job configuration, you may need to run with `sudo`:
```bash
sudo ./setup.sh
```
4. **Check the log file** for any errors or warnings

### Logging

Both scripts create detailed log files in the format:
```
setup_YYYYMMDD_HHMMSS.log  # Initial installation
update_YYYYMMDD_HHMMSS.log # Updates
```

These logs contain:
- All installation/update steps
- Command outputs
- Errors and warnings
- Timestamps for each action

**Tip**: Check the log file if the script fails or behaves unexpectedly.

## Update Scripts

### Purpose

After the initial installation, the `update.ps1` (Windows) and `update.sh` (Unix/Linux) scripts handle:
- Pulling the latest changes from the repository
- Reinstalling dependencies if needed
- Rebuilding the project
- Maintaining proper file permissions

### Automatic Updates

The installation scripts configure **automatic updates**:
- **Windows**: Scheduled tasks run at 5:00 AM and 11:00 PM daily
- **Unix/Linux**: Cron jobs run at the same times

### Manual Updates

You can also run the update scripts manually:

#### Windows
```powershell
.\update.ps1
```

#### Unix/Linux
```bash
./update.sh
```

### Update Script Workflow

1. **Pre-Update Checks**:
   - Verifies that the installation exists
   - Checks if configuration is present in `a4d_mcp_settings.json`
   - Exits if installation not found (must run `setup.sh/ps1` first)
2. **Permission Management**:
   - Restores write permissions to `build/` and `src/` directories
3. **Repository Update**:
   - Pulls latest changes from GitHub
   - Installs updated dependencies
   - Rebuilds the project
4. **Permission Reset**:
   - Sets directories back to read-only for protection
5. **Logging**:
   - Creates detailed log file with timestamp

---

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
                "C:\\Users\\codebuilder\\.vscode-server\\data\\User\\globalStorage\\salesforce.salesforcedx-einstein-gpt\\MCP\\mcp_server_toolkit\\build\\index.js"
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

### Workflows Directory

6. (Optional) Copy workflows to your dx-project:
```bash
# Windows (PowerShell)
Copy-Item -Path "workflows\*" -Destination "C:\Users\codebuilder\dx-project\.a4rules\workflows\" -Recurse -Force

# Unix/Linux (Bash)
cp workflows/* /home/codebuilder/dx-project/.a4rules/workflows/
```

---

## File Permission Management

The scripts implement security through file permissions:

### Initial Installation
- After building, `src/` and `build/` directories are set to **read-only**
- This prevents accidental modifications to critical files

### During Updates
- The `update.ps1`/`update.sh` scripts temporarily restore **write permissions**
- After rebuilding, permissions are reset to **read-only**
- This ensures a safe update process

### Manual Permission Changes
If you need to modify files:

**Windows (PowerShell)**:
```powershell
# Make writeable
Get-ChildItem -Path "path\to\dir" -Recurse | Set-ItemProperty -Name IsReadOnly -Value $false

# Make read-only
Get-ChildItem -Path "path\to\dir" -Recurse | Set-ItemProperty -Name IsReadOnly -Value $true
```

**Unix/Linux (Bash)**:
```bash
# Make writeable
chmod -R a+w /path/to/dir

# Make read-only
chmod -R a-w /path/to/dir
find /path/to/dir -type d -exec chmod a+rx {} +
find /path/to/dir -type f -exec chmod a+r {} +
```

---

## JSON Configuration Details

The scripts automatically update the `a4d_mcp_settings.json` file with the correct configuration for the MCP server. Here's what's configured:

### Configuration Structure
```json
{
    "mcpServers": {
        "mcp_server_toolkit": {
            "disabled": false,           // Enable the server
            "timeout": 600,              // 10 minutes timeout
            "type": "stdio",             // Communication type
            "command": "node",           // Runtime
            "args": [                    // Path to the server
                "...path to build/index.js..."
            ]
        }
    }
}
```

### Key Settings
- **disabled**: Set to `false` to enable the server
- **timeout**: 600 seconds (10 minutes) for MCP operations
- **type**: "stdio" for standard input/output communication
- **command**: "node" to run with Node.js
- **args**: Absolute path to the built server entry point

---

## Troubleshooting

### Installation Checks
- The scripts verify that the installation hasn't been done before
- If you see "Installation already completed" message, run `update.ps1` or `update.sh` instead
- Check log files for detailed error messages

### Common Issues

#### PowerShell Execution Policy Error
```
cannot be loaded because running scripts is disabled
```
**Solution**: Run this command in PowerShell as Administrator:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Permission Denied (Unix/Linux)
```
Permission denied: ./setup.sh
```
**Solution**: Make the script executable:
```bash
chmod +x setup.sh update.sh
```

#### Git Not Found
- Ensure Git is installed and accessible from terminal
- Restart terminal after installing Git
- On Windows, ensure Git is in your PATH

#### npm Install Fails
- Check internet connectivity
- Delete `node_modules` folder and `package-lock.json`, then try again
- Check log file for specific npm errors

#### Scheduled Tasks Not Working (Windows)
- Verify script ran with Administrator privileges
- Check Windows Task Scheduler for the tasks:
  - `MCP_Server_Toolkit_Update`
  - `MCP_Server_Setup_Pull_And_Copy`
- View task history for errors

#### Cron Jobs Not Working (Unix/Linux)
- Check cron log: `grep CRON /var/log/syslog`
- Verify script has execute permissions: `ls -l setup.sh update.sh`
- Ensure cron daemon is running
- Check that paths in scripts match your environment

### File Permissions

**Read-Only Protection**:
- After installation, `src/` and `build/` directories are set to read-only
- The `update.ps1`/`update.sh` scripts automatically restore write permissions before updating
- This protects important files from accidental modifications

### Verify Installation

1. Check log file for successful completion
2. Verify `a4d_mcp_settings.json` contains:
```json
{
    "mcpServers": {
        "mcp_server_toolkit": {
            "disabled": false,
            "timeout": 600,
            "type": "stdio",
            "command": "node",
            "args": ["...path to build/index.js..."]
        }
    }
}
```
3. (Windows) Check Task Scheduler for scheduled tasks
4. (Unix/Linux) Verify cron jobs: `crontab -l`
5. Restart VS Code/Code Builder to load the MCP server

---

## Workflows Overview

The toolkit includes several pre-configured workflows for managing defects and metadata in Salesforce. Each workflow is defined as a Markdown file in the `workflows/` directory and includes built-in validation and error handling.

---

## 🧠 Workflow: Retrieve Defects by Developer

This workflow allows you to retrieve defects assigned to a developer, filtered by one or more specific statuses.

### 📥 Input

The workflow accepts two inputs:

- `developer_name`: the name of the developer
- `defect_states_input`: one or more defect statuses, separated by commas

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
    /recupera-defect-sviluppatore.md "Mario Rossi" "New,Ready to Test"
    ```
- If one or both inputs are **missing**, the workflow will prompt the user interactively.
- The workflow **validates the provided statuses**:
  - If one or more statuses are invalid, it displays an error message.
  - If all statuses are valid, it invokes the MCP server `mcp_server_toolkit` using the method `getDefectsByDeveloperAndStatus`.

### 📤 Output

### 📤 Output

The workflow creates a task that returns the metadata records associated with the specified defect. This is useful for tracking, auditing, or validating import configurations.

---

## 🚀 Quick Start Guide

### For Windows Users

```powershell
# 1. Clone the setup repository
git clone https://github.com/franturino/mcp-server-setup.git
cd mcp-server-setup

# 2. Run PowerShell as Administrator

# 3. Execute setup
.\setup.ps1

# 4. Check the log file for success
# Logs are in: install_YYYYMMDD_HHMMSS.log
```

### For Unix/Linux Users

```bash
# 1. Clone the setup repository
git clone https://github.com/franturino/mcp-server-setup.git
cd mcp-server-setup

# 2. Make scripts executable
chmod +x setup.sh update.sh

# 3. Execute setup (may require sudo for cron configuration)
./setup.sh

# 4. Check the log file for success
# Logs are in: install_YYYYMMDD_HHMMSS.log
```

### After Installation

1. Restart VS Code or Salesforce Code Builder
2. The MCP server `mcp_server_toolkit` should now be active
3. Workflows are available in your workspace
4. Check your log file for any warnings

### Keep Up to Date

Updates are automatic via:
- **Windows**: Scheduled tasks (5:00 AM & 11:00 PM)
- **Unix/Linux**: Cron jobs (5:00 AM & 11:00 PM)

Or run manually:
```powershell
# Windows
.\update.ps1
```

```bash
# Unix/Linux
./update.sh
```

---

## 📞 Support & Documentation

### Need Help?

1. **Check the log files** - They contain detailed information about any errors
2. **Review the Troubleshooting section** - Solutions for common issues
3. **Verify Installation** - Follow the checklist in the Troubleshooting section
4. **Check file permissions** - Especially on Unix/Linux systems

### Repository Information

- **MCP Server Toolkit**: https://github.com/franturino/mcp_server_toolkit
- **Setup Scripts**: https://github.com/franturino/mcp-server-setup
- **Issues/Feedback**: Create an issue on GitHub if you encounter problems

### Key Features

✅ **Automated Installation** - One command setup  
✅ **Automatic Updates** - Scheduled updates keep you current  
✅ **Permission Management** - Automatic read-only protection  
✅ **Workflow Sync** - Latest workflows copied automatically  
✅ **Detailed Logging** - Every step logged for troubleshooting  
✅ **Multiple Workflows** - Retrieve, update, and manage defects  
✅ **Salesforce Integration** - Full MCP server integration  

---

**Last Updated**: November 11, 2025  
**Version**: 2.0 (Enhanced Documentation)

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

The workflow creates a task that returns the metadata records associated with the specified defect. This is useful for tracking, auditing, or validating import configurations.
