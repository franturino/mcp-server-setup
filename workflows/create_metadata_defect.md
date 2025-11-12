# Workflow: Creazione Metadata per Defect Salesforce

# 1. Acquisizione del codice del Defect (passato come parametro iniziale)
- <input>[(defectCode)]: Inserisci il codice del Defect (es. D-123)

# 2. Recupera le risorse modificate oggi in Code Builder
- <command>[(risorse_modificate_oggi)]: Analizza lo stato del progetto in Code Builder e restituisci l'elenco delle risorse Salesforce modificate oggi (formato: nomi file o identificatori logici)

# 3. Mostra all'utente le risorse modificate e chiedi quali includere nel deploy
- @(nomi_risorse)[max=10]: Ecco le risorse modificate oggi: "@risorse_modificate_oggi". Quali vuoi includere nel deploy?

# 4. Prompt LLM per inferire la tipologia di ciascuna risorsa
- <command>[(risorse_tipizzate)]: Per ciascun nome in "@nomi_risorse", determina la tipologia Salesforce corretta e restituisci una lista strutturata pronta per package.xml

# 5. Costruzione del package.xml nel formato Salesforce
- <command>[(packageXml)]: Genera un file package.xml valido per Salesforce utilizzando le risorse tipizzate in "@risorse_tipizzate". Le risorse di stessa tipologia devono appartenere allo stesso parent.

# 6. Esecuzione del tool create_defect_metadata_salesforce sul server MCP
- <tool>: mcp_server_toolkit.create_defect_metadata_salesforce --defectCode "@defectCode" --packageXml "@packageXml"

# 7. Output finale
- <output>: Metadata creati con successo per il Defect "@defectCode".