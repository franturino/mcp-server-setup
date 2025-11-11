# Workflow: Aggiorna Stato Defect su Salesforce

# 1. Chiedi defectId se non è stato fornito
- <input>[(defectId)]: Inserisci il defectId (lascia vuoto se vuoi usare il defectName)

# 2. Chiedi defectName solo se defectId è vuoto
- @(ask_defectName)[max=1]: Il valore di 'defectId' è vuoto? (Se 'yes', chiedi defectName)
- (ask_defectName)<input>[(defectName)]: Inserisci il defectName (lascia vuoto se hai già fornito defectId)

# 3. Chiedi lo stato da applicare
- <input>[(stato)]: Inserisci lo stato da applicare al Defect (es. "Ready to Test")

# 4. Esegui il tool con i valori raccolti
- <tool>: mcp_server_toolkit
          method: update_defect_status_salesforce(
            defectId=$defectId, 
            defectName=$defectName, 
            stato=$stato)

# 5. Mostra il risultato
- <output>: Stato aggiornato: $response