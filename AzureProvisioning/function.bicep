param resourcePrefix string
param resourcePrefixShort string

param location string = resourceGroup().location

resource plan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${resourcePrefix}-plan'
  location: location
  tags: resourceGroup().tags
  kind: 'linux'
  sku: {
    name: 'F1'
  }
  properties: {
    reserved: true
  }
}

resource stg 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${resourcePrefixShort}sa'
  location: location
  tags: resourceGroup().tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion:'TLS1_2'
    accessTier: 'Hot'
  }
}

var stgConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${stg.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(stg.id, stg.apiVersion).keys[0].value}'

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
      ]
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
    
  }
  identity: {
    type: 'SystemAssigned'
  }
}
