# Workflow: Recupera Defect per Sviluppatore (senza validazione stati)

# 1. Verifica se il nome dello sviluppatore è già disponibile
- @(ask_developer_name)[max=1]: Il parametro "developer_name" è assente? (Se 'yes', chiedi il nome)
- <input>[(developer_name)]: Inserisci il nome dello sviluppatore

# 2. Verifica se gli stati dei defect sono già disponibili
- @(ask_defect_states)[max=1]: Il parametro "defect_states_input" è assente? (Se 'yes', chiedi gli stati)
- <input>[(defect_states_input)]: Inserisci uno o più stati dei defect separati da virgola

# 3. Normalizza gli stati inseriti
- <command>[(defect_states)]: echo "{{defect_states_input.split(',').map(s => s.trim())}}"

# 4. Esecuzione della query
- <output>: Recupero i defect per {{developer_name}} con stati: {{defect_states.join(', ')}}
- <tool>: mcp_server_toolkit
  method: getDefectsByDeveloperAndStatus
  developer: {{developer_name}}
  statuses: {{defect_states}}

# 5. Fine
- <output>: Query completata.