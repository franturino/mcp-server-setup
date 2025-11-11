# Workflow: Recupera Defect per Sviluppatore (con richiesta condizionale)

# 1. Verifica se il nome dello sviluppatore è già disponibile
- @(ask_developer_name)[max=1]: Il parametro "developer_name" è assente? (Se 'yes', chiedi il nome)
- <input>[(developer_name)]: Inserisci il nome dello sviluppatore

# 2. Verifica se gli stati dei defect sono già disponibili
- @(ask_defect_states)[max=1]: Il parametro "defect_states_input" è assente? (Se 'yes', chiedi gli stati)
- <input>[(defect_states_input)]: Inserisci uno o più stati dei defect separati da virgola

# 3. Definisci gli stati validi
- <command>[(valid_states)]: echo '["New", "Re-opened", "Sospeso", "Need More Information", "Non Deployabile", "Fix in Process", "Ready to Test", "In Deployment", "Deploy PREPROD", "Ready to test - NEW INTEGRA", "Deploy SUPPORT", "Ready to test - PREPROD", "Ready to test - SUPPORT", "Closed - End of life", "Closed - Duplicate", "Closed - Rejected", "Closed - Resolved", "Not a Defect", "Deploy PROD"]'

# 4. Normalizza gli stati inseriti
- <command>[(defect_states)]: echo "{{defect_states_input.split(',').map(s => s.trim())}}"

# 5. Verifica se ci sono stati non validi
- <command>[(invalid_states)]: echo "{{defect_states.filter(s => !valid_states.includes(s))}}"

# 6. Controllo finale sugli stati
- @(invalid_states_check)[max=1]: Ci sono stati non validi? (Se 'yes', salta a invalid_states_block)

# 7. Esecuzione della query se tutto è valido
- <output>: Recupero i defect per {{developer_name}} con stati: {{defect_states.join(', ')}}
- <tool>: mcp_server_toolkit
  method: getDefectsByDeveloperAndStatus
  developer: {{developer_name}}
  statuses: {{defect_states}}

# 8. Fine
- <output>: Query completata.

# 9. Blocco alternativo per stati non validi
- (invalid_states_block)<output>: ⚠️ Gli stati seguenti non sono validi: {{invalid_states.join(', ')}}. Inserisci solo stati tra quelli consentiti: {{valid_states.join(', ')}}