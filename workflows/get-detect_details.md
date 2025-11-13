# Workflow: Request Multiple Defect Details

# 1. Check if the input 'defect_codes' is empty
- @(request_codes)[max=5]: Is the variable 'defect_codes' empty? (If 'yes', ask the user to provide it)

# 2. If empty, ask the user to enter the defect codes
- (request_codes)<input>[(defect_codes)]: Enter the defect codes separated by commas (e.g., D-123,D-456)

# 3. Prepare the list of separated codes
- <command>[(defect_list)]: echo "{{defect_codes}}" | tr ',' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//'

# 4. For each code in the list, create a task to retrieve the details
- <foreach>: defect_list
  do:
    - <tool>: mcp_server_toolkit
      method: getDefectDetails
      parameters:
        defectId: {{item}}
    - <output>: Retrieved details for defect {{item}}