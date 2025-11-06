# Query Metadata su Salesforce per un Defect

input_variables:
  - defectId
  - defectCode

1. if: "{{!defectId && !defectCode}}"
   then:
     ask_followup_question: "Inserisci l'ID del defect (es. a1B0500000abcdeAAA) oppure il codice (es. D-123):"
     save_as: defectCode

2. new_task:
   name: "Query metadata per defect {{defectId || defectCode}}"
   description: "Recupera i record di metadata associati al defect {{defectId || defectCode}} tramite il server MCP"
   tool: mcp_server_toolkit
   parameters:
     method: "query_metadata_by_defect_salesforce"
     defectId: "{{defectId}}"
     defectCode: "{{defectCode}}"