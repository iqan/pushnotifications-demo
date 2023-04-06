param resourcePrefix string
param location string = resourceGroup().location

resource account 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = {
  name: '${resourcePrefix}-cosmos'
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-05-15' = {
  parent: account
  name: '${resourcePrefix}-cosmos'
  properties: {
    resource: {
      id: '${resourcePrefix}-cosmos'
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: database
  name: 'promo'
  properties: {
    resource: {
      id: 'promo'
      partitionKey: {
        paths: [
          '/text'
        ]
        kind: 'Hash'
      }
    }
  }
}

output connectionString string = database.listConnectionStrings().connectionStrings[0].connectionString
