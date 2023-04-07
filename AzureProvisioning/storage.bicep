param resourcePrefixShort string
param location string = resourceGroup().location

resource stg 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: '${resourcePrefixShort}stg'
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

output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${stg.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(stg.id, stg.apiVersion).keys[0].value}'
