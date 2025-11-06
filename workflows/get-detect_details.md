# Richiedi Dettagli Multipli Defect

input_variables:
  - defect_codes

1. if: "{{!defect_codes}}"
   then:
     ask_followup_question: "Inserisci i codici dei defect separati da virgola (es. D-123,D-456):"
     save_as: defect_codes

2. set_variable:
   name: defect_list
   value: "{{defect_codes.split(',').map(s => s.trim())}}"

3. foreach: "{{defect_list}}"
   do:
     new_task:
       name: "Recupera dettagli per {{item}}"
       description: "Usa il server MCP 'mcp_server_toolkit' per ottenere i dettagli del defect {{item}}"
       tool: mcp_server_toolkit
       parameters:
         method: "getDefectDetails"
         defectId: "{{item}}"