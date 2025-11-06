# Crea Metadata per Import su Salesforce

input_variables:
  - defectId
  - defectName
  - tableName
  - externalCodesInput

1. if: "{{!defectId && !defectName}}"
   then:
     ask_followup_question: "Inserisci l'ID del defect (es. a1B0500000abcdeAAA) oppure il nome (es. D-123):"
     save_as: defectName

2. if: "{{!tableName}}"
   then:
     ask_followup_question: "Inserisci il nome della tabella su cui importare i record:"
     save_as: tableName

3. if: "{{!externalCodesInput}}"
   then:
     ask_followup_question: "Inserisci gli external codes separati da virgola:"
     save_as: externalCodesInput

4. set_variable:
   name: externalCodes
   value: "{{externalCodesInput.split(',').map(code => code.trim())}}"

5. new_task:
   name: "Crea metadata per import su {{tableName}}"
   description: "Inserisce un record di metadata per l'import su Salesforce associato al defect {{defectId || defectName}}, tabella {{tableName}}, con external codes {{externalCodes.join(', ')}}"
   tool: mcp_server_toolkit
   parameters:
     method: "create_metadata_for_import_salesforce"
     defectId: "{{defectId}}"
     defectName: "{{defectName}}"
     tableName: "{{tableName}}"
     externalCodes: "{{externalCodes}}"