# Workflow: Crea Metadata per Import su Salesforce

# 1. Chiedi defectId o defectName se non presenti
- @(ask_defect)[max=1]: Non hai fornito né defectId né defectName? (Se 'yes', chiedi uno dei due)
- <input>[(defectName)]: Inserisci l'ID del defect (es. a1B0500000abcdeAAA) oppure il nome (es. D-123)

# 2. Chiedi tableName se mancante
- @(ask_table)[max=1]: Il nome della tabella è mancante? (Se 'yes', chiedi tableName)
- <input>[(tableName)]: Inserisci il nome della tabella su cui importare i record

# 3. Chiedi externalCodesInput se mancante
- @(ask_codes)[max=1]: Non hai fornito gli external codes? (Se 'yes', chiedi externalCodesInput)
- <input>[(externalCodesInput)]: Inserisci gli external codes separati da virgola

# 4. Prepara la lista externalCodes
- <command>[(externalCodes)]: echo "{{externalCodesInput}}" | tr ',' '\n' | sed 's/^ *//;s/ *$//'

# 5. Crea il task di metadata import
- <output>: Creo metadata per import su {{tableName}} associato al defect {{defectId || defectName}} con external codes: {{externalCodes}}
- <tool>: mcp_server_toolkit
  method: create_metadata_for_import_salesforce
  defectId: {{defectId}}
  defectName: {{defectName}}
  tableName: {{tableName}}
  externalCodes: {{externalCodes}}

# 6. Fine
- <output>: Workflow completato.