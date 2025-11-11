# Workflow: Aggiorna Stato Defect con Validazione

# 1. Verifica se defect_code è già stato fornito
- @(ask_defect_code)[max=1]: Il codice del defect non è stato fornito? (Se 'yes', chiedi defect_code)
- <input>[(defect_code)]: Inserisci il codice del defect da aggiornare (es. D-123)

# 2. Verifica se defect_status è già stato fornito
- @(ask_defect_status)[max=1]: Lo stato del defect non è stato fornito? (Se 'yes', chiedi defect_status)
- <input>[(defect_status)]: Inserisci lo stato da assegnare al defect

# 3. Definisci gli stati validi
- <command>[(valid_states)]: echo '["New", "Re-opened", "Sospeso", "Need More Information", "Non Deployabile", "Fix in Process", "Ready to Test", "In Deployment", "Deploy PREPROD", "Ready to test - NEW INTEGRA", "Deploy SUPPORT", "Ready to test - PREPROD", "Ready to test - SUPPORT", "Closed - End of life", "Closed - Duplicate", "Closed - Rejected", "Closed - Resolved", "Not a Defect", "Deploy PROD"]'

# 4. Verifica se defect_status è tra gli stati validi
- @(invalid_status)[max=1]: Lo stato "{{defect_status}}" non è tra quelli validi? (Se 'yes', salta a invalid_status)
- <output>: Stato valido. Procedo con l'aggiornamento.

# 5. Esegui aggiornamento stato
- <output>: Aggiorno lo stato del defect {{defect_code}} a "{{defect_status}}"
- <tool>: mcp_server_toolkit
  method: updateDefectStatus
  defectId: {{defect_code}}
  status: {{defect_status}}

# 6. Fine
- <output>: Stato aggiornato correttamente.

# 7. Blocco alternativo per stato non valido
- (invalid_status)<output>: ⚠️ Stato non valido. Inserisci uno stato tra quelli consentiti: {{valid_states}}