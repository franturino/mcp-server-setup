# Workflow: Query Metadata su Salesforce per un Defect

# 1. Verifica se i parametri sono già disponibili
- @(ask_defect)[max=1]: Nessun parametro tra "defectId" e "defectCode" è stato fornito? (Se 'yes', chiedi uno dei due)
- <input>[(defectCode)]: Inserisci l'ID del defect (es. a1B0500000abcdeAAA) oppure il codice (es. D-123)

# 2. Avvia la query dei metadata
- <output>: Avvio la query per il defect {{defectId || defectCode}}...
- <tool>: mcp_server_toolkit
  method: query_metadata_by_defect_salesforce
  defectId: {{defectId}}
  defectCode: {{defectCode}}

# 3. Fine
- <output>: Query completata.