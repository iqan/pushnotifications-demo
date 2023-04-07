param resourcePrefix string
param stgConnectionString string
param aiKey string
param location string = resourceGroup().location

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${resourcePrefix}-plan'
  location: location
  tags: resourceGroup().tags
  kind: 'linux'
  sku: {
    name: 'B1'
  }
  properties: {
    reserved: true
  }
}

resource func 'Microsoft.Web/sites@2021-03-01' = {
  name: '${resourcePrefix}-fnc'
  location: location
  kind: 'functionapp'
  tags: resourceGroup().tags
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      acrUseManagedIdentityCreds: true
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: aiKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: stgConnectionString
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'CosmosDBConnection__accountEndpoint'
          value: 'https://${resourcePrefix}-cosmos.documents.azure.com:443/'
        }
      ]
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
    
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' existing = {
  name: '${resourcePrefix}-cosmos'
}

resource roleDef 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2023-03-01-preview' existing = {
  parent: cosmos
  name: '00000000-0000-0000-0000-000000000002' // DocumentDB Account Contributor
}


resource funcRole 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2022-08-15' = {
  name: guid('function-cosmos-role')
  parent: cosmos
  properties: {
    principalId: func.identity.principalId
    roleDefinitionId: roleDef.id
    scope: cosmos.id
  }
}
