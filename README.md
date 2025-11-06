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

The workflow creates a task that retrieves defects filtered by developer and status, useful for analysis, reporting, or debugging.

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
