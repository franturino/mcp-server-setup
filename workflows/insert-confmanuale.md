# Workflow: Inserisci Configurazione Manuale su Salesforce

# 1. Verifica se defect_code è già presente
- @(ask_defect_code)[max=1]: Il codice del defect non è stato fornito? (Se 'yes', chiedi defect_code)
- <input>[(defect_code)]: Inserisci il codice del defect (es. D-123)

# 2. Verifica se config_note è già presente
- @(ask_config_note)[max=1]: La nota di configurazione non è stata fornita? (Se 'yes', chiedi config_note)
- <input>[(config_note)]: Inserisci la nota da associare alla configurazione manuale

# 3. Esegui il task di configurazione manuale
- <output>: Inserisco configurazione manuale per il defect {{defect_code}} con nota "{{config_note}}"
- <tool>: mcp_server_toolkit
  method: insertManualConfiguration
  defectId: {{defect_code}}
  note: {{config_note}}

# 4. Fine
- <output>: Configurazione manuale completata.