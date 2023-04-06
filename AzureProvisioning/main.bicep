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

module func 'function.bicep' = {
  scope: rg
  name: 'function-app'
  params: {
    resourcePrefix: resourcePrefix
    resourcePrefixShort: resourcePrefixShort
    location: rg.location
  }
}
