# Inserisci Configurazione Manuale

input_variables:
  - defect_code
  - config_note

1. if: "{{!defect_code}}"
   then:
     ask_followup_question: "Inserisci il codice del defect (es. D-123):"
     save_as: defect_code

2. if: "{{!config_note}}"
   then:
     ask_followup_question: "Inserisci la nota da associare alla configurazione manuale:"
     save_as: config_note

3. new_task:
   name: "Inserisci configurazione manuale per {{defect_code}}"
   description: "Inserisci Configurazione Manuale su Salesforce usando il server MCP 'mcp_server_toolkit' associato al defect {{defect_code}} con la nota '{{config_note}}'"
   tool: mcp_server_toolkit
   parameters:
     method: "insertManualConfiguration"
     defectId: "{{defect_code}}"
     note: "{{config_note}}"