# Workflow: Update Defect Status on Salesforce

# 1. Ask for defectId if it was not provided
- <input>[(defectId)]: Enter the defectId (leave empty if you want to use defectName)

# 2. Ask for defectName only if defectId is empty
- @(ask_defectName)[max=1]: Is the value of 'defectId' empty? (If 'yes', ask for defectName)
- (ask_defectName)<input>[(defectName)]: Enter the defectName (leave empty if you have already provided defectId)

# 3. Ask for the status to apply
- <input>[(status)]: Enter the status to apply to the Defect (e.g., "Ready to Test")

# 4. Execute the tool with the collected values
- <tool>: mcp_server_toolkit
          method: update_defect_status_salesforce(
            defectId=$defectId, 
            defectName=$defectName, 
            status=$status)

# 5. Display the result
- <output>: Status updated: $response