# Push Notifications Demo

Contains demo for different methods for implementing push notification feature

## Azure Provisioning

Provisions azure infrastructure using Bicep.

To deploy

```shell
az deployment create --location NorthEurope --template-file main.bicep --parameters googleApiKey=__ADD YOUR OWN API KEY HERE__
```

## Azure Function

Triggers on change in cosmos database document and sends a notification to the mobile devices.

## Mobile

Mobile app developed in Flutter to receive notification when a document in cosmos id updated.
