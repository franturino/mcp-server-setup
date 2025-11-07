description: "Workflow per creare metadata associati a un Defect Salesforce analizzando risorse da deployare"
inputs:
  defectCode:
    type: string
    required: true
    description: "Codice del Defect (es. D-123)"

steps:
  - id: askResources
    action: core:prompt
    inputs:
      prompt: |
        Inserisci la lista delle risorse Salesforce da includere nel package.xml.
        Esempio:
        [[Custom Object:
        BrimLeveTracking__c

        Custom Fields:
        BrimLeveTracking__c.ExternalCode__c,
        BrimLeveTracking__c.OriginOfferCode__c,
        BrimLeveTracking__c.StartDate__c,
        BrimLeveTracking__c.PodPdr__c,
        ConditionOverride__c.BrimLeveTrackingId__c

        Layout:
        BrimLeveTracking__c-Tracciamento Leve Brim Layout

        ApexClass:
        AsyncAddendumIntegrationProcessB2Be,
        AsyncAddendumB2be,
        AsyncFulfillmentB2Be,
        B2BeAddendaContrattualizzaController,
        OfferSiteRepository]]
    outputs:
      - name: rawResources
        type: string

  - id: buildPackageXml
    action: utils:transform:code
    inputs:
      language: javascript
      code: |
        function parseResources(raw) {
          const lines = raw.split('\n').map(l => l.trim()).filter(l => l);
          const typeMap = {};
          let currentType = null;

          for (const line of lines) {
            if (line.endsWith(':')) {
              currentType = line.replace(':', '').trim();
              typeMap[currentType] = [];
            } else if (currentType) {
              const items = line.split(',').map(i => i.trim()).filter(i => i);
              typeMap[currentType].push(...items);
            }
          }

          const xmlParts = ['<?xml version="1.0" encoding="UTF-8"?>', '<Package xmlns="http://soap.sforce.com/2006/04/metadata">'];
          for (const [type, members] of Object.entries(typeMap)) {
            xmlParts.push('  <types>');
            members.forEach(member => {
              xmlParts.push(`    <members>${member}</members>`);
            });
            xmlParts.push(`    <name>${type}</name>`);
            xmlParts.push('  </types>');
          }
          xmlParts.push('  <version>58.0</version>');
          xmlParts.push('</Package>');
          return xmlParts.join('\n');
        }

        return parseResources(inputs.rawResources);
    outputs:
      - name: packageXml
        type: string

  - id: createMetadata
    action: mcp_server_toolkit.create_defect_metadata_salesforce
    inputs:
      defectCode: "${{inputs.defectCode}}"
      packageXml: "${{steps.buildPackageXml.outputs.packageXml}}"
    outputs:
      - name: result
        type: string

outputs:
  - name: metadataCreationResult
    type: string
    value: "${{steps.createMetadata.outputs.result}}"