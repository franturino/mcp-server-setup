# Aggiorna Stato Defect con Validazione

input_variables:
  - defect_code
  - defect_status

1. if: "{{!defect_code}}"
   then:
     ask_followup_question: "Inserisci il codice del defect da aggiornare (es. D-123):"
     save_as: defect_code

2. if: "{{!defect_status}}"
   then:
     ask_followup_question: "Inserisci lo stato da assegnare al defect:"
     save_as: defect_status

3. set_variable:
   name: valid_states
   value: ["New", "Re-opened", "Sospeso", "Need More Information", "Non Deployabile", "Fix in Process", "Ready to Test", "In Deployment", "Deploy PREPROD", "Ready to test - NEW INTEGRA", "Deploy SUPPORT", "Ready to test - PREPROD", "Ready to test - SUPPORT", "Closed - End of life", "Closed - Duplicate", "Closed - Rejected", "Closed - Resolved", "Not a Defect", "Deploy PROD"]

4. if: "{{!valid_states.includes(defect_status)}}"
   then:
     say: "⚠️ Stato non valido. Inserisci uno stato tra quelli consentiti: {{valid_states.join(', ')}}"
   else:
     new_task:
       name: "Aggiorna stato del defect {{defect_code}}"
       description: "Imposta lo stato '{{defect_status}}' per il defect {{defect_code}} usando il server MCP"
       tool: mcp_server_toolkit
       parameters:
         method: "updateDefectStatus"
         defectId: "{{defect_code}}"
         status: "{{defect_status}}"