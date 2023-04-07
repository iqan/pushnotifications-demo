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

// resource sqlRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2021-04-15' = {
//   parent: account
//   name: guid('cosmos-contributor-role')
//   properties: {
//     roleName: 'Cosmos DB Built-in Data Contributor'
//     type: 'BuiltInRole'
//     assignableScopes: [
//       account.id
//     ]
//     permissions: [
//       {
//         dataActions: [
//           'Microsoft.DocumentDB/databaseAccounts/readMetadata'
//           'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
//           'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
//         ]
//       }
//     ]
//   }
// }
