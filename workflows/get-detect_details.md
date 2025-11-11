# Workflow: Richiedi Dettagli Multipli Defect

# 1. Controlla se l'input 'defect_codes' è vuoto
- @(richiesta_codici)[max=5]: La variabile 'defect_codes' è vuota? (Se 'yes', chiedi all'utente di inserirla)

# 2. Se vuota, chiedi all'utente di inserire i codici dei defect
- (richiesta_codici)<input>[(defect_codes)]: Inserisci i codici dei defect separati da virgola (es. D-123,D-456)

# 3. Prepara la lista dei codici separati
- <command>[(defect_list)]: echo "{{defect_codes}}" | tr ',' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//'

# 4. Per ogni codice nella lista, crea un task per recuperare i dettagli
- <foreach>: defect_list
  do:
    - <tool>: mcp_server_toolkit
      method: getDefectDetails
      parameters:
        defectId: {{item}}
    - <output>: Recuperati i dettagli per il defect {{item}}