# Recupera Defect per Sviluppatore

input_variables:
  - developer_name
  - defect_states_input

1. if: "{{!developer_name}}"
   then:
     ask_followup_question: "Inserisci il nome dello sviluppatore:"
     save_as: developer_name

2. if: "{{!defect_states_input}}"
   then:
     ask_followup_question: "Inserisci uno o più stati dei defect separati da virgola:"
     save_as: defect_states_input

3. set_variable:
   name: valid_states
   value: ["New", "Re-opened", "Sospeso", "Need More Information", "Non Deployabile", "Fix in Process", "Ready to Test", "In Deployment", "Deploy PREPROD", "Ready to test - NEW INTEGRA", "Deploy SUPPORT", "Ready to test - PREPROD", "Ready to test - SUPPORT", "Closed - End of life", "Closed - Duplicate", "Closed - Rejected", "Closed - Resolved", "Not a Defect", "Deploy PROD"]

4. set_variable:
   name: defect_states
   value: "{{defect_states_input.split(',').map(s => s.trim())}}"

5. set_variable:
   name: invalid_states
   value: "{{defect_states.filter(s => !valid_states.includes(s))}}"

6. if: "{{invalid_states.length > 0}}"
   then:
     say: "⚠️ Gli stati seguenti non sono validi: {{invalid_states.join(', ')}}. Inserisci solo stati tra quelli consentiti."
   else:
     new_task:
       name: "Recupera defect per {{developer_name}}"
       description: "Recupera i Defect assegnati allo sviluppatore {{developer_name}} filtrati per stato {{defect_states.join(', ')}} invocando il server MCP 'mcp_server_toolkit'"
       tool: mcp_server_toolkit
       parameters:
         method: "getDefectsByDeveloperAndStatus"
         developer: "{{developer_name}}"
         statuses: "{{defect_states}}"