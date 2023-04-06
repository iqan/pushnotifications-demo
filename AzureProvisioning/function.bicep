param resourcePrefix string
param stgConnectionString string
param cosmosConnectionString string
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
  name: '${resourcePrefix}-func'
  location: location
  kind: 'functionapp'
  tags: resourceGroup().tags
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      acrUseManagedIdentityCreds: true
      appSettings: [
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
          name: 'CosmosDBConnectionString'
          value: cosmosConnectionString
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
