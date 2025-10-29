# Set up logging
$logFile = "setup_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
Start-Transcript -Path $logFile -Append

Write-Host "Starting setup script at $(Get-Date)"

# Navigate to MCP directory
$mcpPath = "$env:APPDATA\Code\User\globalStorage\salesforce.salesforcedx-einstein-gpt\MCP"
Set-Location -Path $mcpPath
Write-Host "Changed to MCP directory: $PWD"

# Check if directory exists and contains .gitignore
if ((Test-Path "mcp_server_toolkit") -and (Test-Path "mcp_server_toolkit\.gitignore")) {
    Write-Host "Repository already exists, updating..."
    Set-Location -Path "mcp_server_toolkit"
    Write-Host "Current directory: $PWD"
    git pull
    Write-Host "Repository updated successfully!"
}
else {
    # Clone the repository if not exists
    Write-Host "Cloning repository..."
    git clone https://github.com/franturino/mcp_server_toolkit.git
    Write-Host "Repository cloned successfully!"
    
    # Navigate into the cloned repository and run npm commands
    Set-Location -Path "mcp_server_toolkit"
    Write-Host "Current directory: $PWD"
    
    Write-Host "Installing dependencies..."
    npm install 2>&1
    Write-Host "Dependencies installed successfully!"
    
    Write-Host "Building project..."
    npm run build 2>&1
    Write-Host "Build completed successfully!"
    
    # Navigate to settings directory
    Set-Location -Path "$env:APPDATA\Code\User\globalStorage\salesforce.salesforcedx-einstein-gpt\settings"
    Write-Host "Changed to settings directory: $PWD"

    # Add mcp_server_toolkit configuration to a4d_mcp_settings.json
    Write-Host "Updating a4d_mcp_settings.json..."
    $settingsJson = Get-Content "a4d_mcp_settings.json" | ConvertFrom-Json
    
    if (-not $settingsJson.mcpServers) {
        $settingsJson | Add-Member -Name "mcpServers" -Value @{} -MemberType NoteProperty
    }
    
    $settingsJson.mcpServers | Add-Member -Name "mcp_server_toolkit" -Value @{
        disabled = $false
        timeout = 600
        type = "stdio"
        command = "node"
        args = @(
            "$mcpPath\mcp_server_toolkit\build\index.js"
        )
    } -MemberType NoteProperty

    $settingsJson | ConvertTo-Json -Depth 10 | Set-Content "a4d_mcp_settings.json"
    Write-Host "Updated a4d_mcp_settings.json successfully!"
}

Write-Host "Setup script completed at $(Get-Date)"
Stop-Transcript