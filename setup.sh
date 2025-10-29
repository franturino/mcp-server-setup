#!/bin/bash

# Set up logging
LOG_FILE="setup_$(date '+%Y%m%d_%H%M%S').log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

echo "Starting setup script at $(date)"

# Navigate to MCP directory
cd /home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP
echo "Changed to MCP directory: $PWD"

# Check if directory exists and contains .gitignore
if [ -d "mcp_server_toolkit" ] && [ -f "mcp_server_toolkit/.gitignore" ]; then
    echo "Repository already exists, updating..."
    cd mcp_server_toolkit
    echo "Current directory: $PWD"
    git pull
    echo "Repository updated successfully!"
else
    # Clone the repository if not exists
    echo "Cloning repository..."
    git clone https://github.com/franturino/mcp_server_toolkit.git
    echo "Repository cloned successfully!"
    
    # Navigate into the cloned repository and run npm commands
    cd mcp_server_toolkit
    echo "Current directory: $PWD"
    
    echo "Installing dependencies..."
    npm install 2>&1
    echo "Dependencies installed successfully!"
    
    echo "Building project..."
    npm run build 2>&1
    echo "Build completed successfully!"
    
    # Navigate to settings directory
    cd /home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/settings
    echo "Changed to settings directory: $PWD"

    # Add mcp_server_toolkit configuration to a4d_mcp_settings.json
    echo "Updating a4d_mcp_settings.json..."
    jq '.mcpServers += {
        "mcp_server_toolkit": {
            "disabled": false,
            "timeout": 600,
            "type": "stdio",
            "command": "node",
            "args": [
                "/home/codebuilder/.local/share/code-server/User/globalStorage/salesforce.salesforcedx-einstein-gpt/MCP/mcp_server_toolkit/build/index.js"
            ]
        }
    }' a4d_mcp_settings.json > temp.json && mv temp.json a4d_mcp_settings.json

    echo "Updated a4d_mcp_settings.json successfully!"
fi

echo "Setup script completed at $(date)"