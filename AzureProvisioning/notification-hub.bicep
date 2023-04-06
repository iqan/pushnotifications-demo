param resourcePrefix string
param gcmEndpoint string
@secure()
param googleApiKey string

param location string = resourceGroup().location

resource namespace 'Microsoft.NotificationHubs/namespaces@2017-04-01' = {
  name: '${resourcePrefix}-notificationhub-ns'
  location: location
  sku: {
    name: 'Free'
  }
  tags: resourceGroup().tags
}

resource notificationHub 'Microsoft.NotificationHubs/namespaces/notificationHubs@2017-04-01' = {
  name: '${resourcePrefix}-notificationhub'
  location: location
  parent: namespace
  tags: resourceGroup().tags
  properties: {
    gcmCredential: {
      properties: {
        gcmEndpoint: gcmEndpoint
        googleApiKey: googleApiKey
      }
    }
  }
}
