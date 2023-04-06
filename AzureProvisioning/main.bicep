targetScope = 'subscription'

param gcmEndpoint string
@secure()
param googleApiKey string
param resourcePrefix string = 'iqans-demos'
param resourcePrefixShort string = 'iqansdemos'
param location string = 'northeurope'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: '${resourcePrefix}-rg'
  location: location
}

module nh 'notification-hub.bicep' = {
  scope: rg
  name: 'notification-hub'
  params: {
    resourcePrefix: resourcePrefix
    location: rg.location
    gcmEndpoint: gcmEndpoint
    googleApiKey: googleApiKey
  }
}

module stg 'storage.bicep' = {
  scope: rg
  name: 'storage'
  params: {
    resourcePrefixShort: resourcePrefixShort
    location: rg.location
  }
}

module cdb 'cosmos.bicep' = {
  scope: rg
  name: 'cosmos-db'
  params: {
    resourcePrefix: resourcePrefix
    location: rg.location
  }
}

module func 'function.bicep' = {
  scope: rg
  name: 'function-app'
  dependsOn: [
    cdb
  ]
  params: {
    resourcePrefix: resourcePrefix
    location: rg.location
    stgConnectionString: stg.outputs.connectionString
  }
}
