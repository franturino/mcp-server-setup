# Workflow: Metadata Creation for Salesforce Defect

# 1. Acquire the Defect Code
- <input>[(defectCode)]: Enter the Defect code (e.g., D-123)

# 2. Choose resource selection mode (with buttons)
- @(selection_mode)[options=["Automatic", "Manual"]]: How would you like to select the resources to include in the deploy?  
  - **Automatic**: Scan the local project directory for files modified today  
  - **Manual**: Manually enter the list of resources

# 3A. Automatic mode: scan for files modified today
- (Automatic)<command>[(modified_resources_today)]: Scan the local Salesforce project directory and return the list of files modified today. Include only deployable files (e.g., Apex, LWC, metadata XML).

# 3B. Manual mode: user provides resource list
- (Manual)<input>[(modified_resources_today)]: Manually enter the list of resources to include in the deploy (comma-separated)

# 4. Check if any resources were found or provided
- @(no_resources): Is the list "@modified_resources_today" empty? (Reply 'yes' to stop the workflow)

# 5. If no resources, stop the workflow
- (no_resources)<output>: No resources were provided or modified today. Workflow has been stopped.

# 6. If resources exist, ask which ones to include in the deploy
- @(selected_resources): Here are the available resources: "@modified_resources_today". Which ones do you want to include in the deploy?

# 7. Infer the Salesforce type of each selected resource
- <command>[(typed_resources)]: For each name in "@selected_resources", determine the correct Salesforce type and return a structured list ready for package.xml

# 8. Generate the package.xml file
- <command>[(packageXml)]: Generate a valid Salesforce package.xml file using the typed resources in "@typed_resources". Resources of the same type must be grouped under the same parent.

# 9. Create metadata for the Defect on MCP
- <tool>: mcp_server_toolkit.create_defect_metadata_salesforce --defectCode "@defectCode" --packageXml "@packageXml"

# 10. Final output
- <output>: Metadata successfully created for Defect "@defectCode".