targetScope = 'resourceGroup'

@description('Azure region for most resources.')
param location string = resourceGroup().location

@description('Region for Static Web Apps. Use a supported region, e.g. East US2.')
param staticWebAppLocation string = 'East US2'

@description('Project short name.')
param project string = 'ptm'

@description('Organization short name.')
param organization string = 'ufsc'

@description('Environment name.')
param environment string = 'dev'

@description('Static Web App resource name.')
param staticWebAppName string = 'swa-ufsc-ptm-dev'

@description('Function App name (must be globally unique).')
param functionAppName string = 'func-ufsc-ptm-dev-001'

@description('Storage account name for Function App (must be globally unique, lowercase, no hyphen).')
param functionStorageName string = 'stufscptmdev001'

@description('Cosmos DB account name (must be globally unique).')
param cosmosAccountName string = 'cosmos-ufsc-ptm-dev-001'

@description('Cosmos DB database name.')
param cosmosDatabaseName string = 'db_macroalgas'

@description('Cosmos DB container for station records.')
param stationsContainerName string = 'stations'

@description('Cosmos DB container for quadrat records.')
param quadratsContainerName string = 'quadrats'

@description('Cosmos DB container for sync events.')
param syncEventsContainerName string = 'sync_events'

@description('Function App hosting plan name.')
param functionPlanName string = 'asp-ufsc-ptm-dev'

@description('Runtime for Function App.')
@allowed([
  'node'
  'python'
])
param functionRuntime string = 'node'

@description('Runtime version. Example: ~4 for Azure Functions host, and language workers configured in app settings.')
param functionsExtensionVersion string = '~4'

@description('Node runtime version when functionRuntime is node.')
param nodeVersion string = '20'

@description('Python runtime version when functionRuntime is python.')
param pythonVersion string = '3.11'

@description('Deploy Function App, Storage, Application Insights and Cosmos DB backend resources. Keep false for the first static-site deployment.')
param deployBackend bool = false

@secure()
@description('API key used by the Function App when deployBackend is true. Provide through a secure parameter or secret.')
param apiKey string = ''

@description('Additional CORS origin for the existing GitHub Pages site.')
param githubPagesOrigin string = 'https://caetanoronan.github.io'

var tags = {
  project: project
  organization: organization
  environment: environment
  managedBy: 'bicep'
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = if (deployBackend) {
  name: functionStorageName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
  }
}

resource functionPlan 'Microsoft.Web/serverfarms@2023-12-01' = if (deployBackend) {
  name: functionPlanName
  location: location
  tags: tags
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  kind: 'functionapp'
  properties: {
    reserved: true
  }
}

var linuxFxVersion = functionRuntime == 'node'
  ? 'NODE|${nodeVersion}'
  : 'PYTHON|${pythonVersion}'

resource functionApp 'Microsoft.Web/sites@2023-12-01' = if (deployBackend) {
  name: functionAppName
  location: location
  tags: tags
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: functionPlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage!.name};AccountKey=${storage!.listKeys().keys[0].value};EndpointSuffix=${az.environment().suffixes.storage}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: functionsExtensionVersion
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'AzureWebJobsFeatureFlags'
          value: 'EnableWorkerIndexing'
        }
        {
          name: 'COSMOS_DATABASE'
          value: cosmosDatabaseName
        }
        {
          name: 'COSMOS_ENDPOINT'
          value: cosmos!.properties.documentEndpoint
        }
        {
          name: 'COSMOS_KEY'
          value: cosmos!.listKeys().primaryMasterKey
        }
        {
          name: 'COSMOS_CONTAINER_STATIONS'
          value: stationsContainerName
        }
        {
          name: 'COSMOS_CONTAINER_QUADRATS'
          value: quadratsContainerName
        }
        {
          name: 'COSMOS_CONTAINER_SYNC'
          value: syncEventsContainerName
        }
        {
          name: 'CORS_ALLOWED_ORIGINS'
          value: 'https://${staticWebApp.properties.defaultHostname},${githubPagesOrigin}'
        }
        {
          name: 'API_KEY'
          value: apiKey
        }
      ]
    }
  }
}

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2024-02-15-preview' = if (deployBackend) {
  name: cosmosAccountName
  location: location
  tags: tags
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    enableFreeTier: false
  }
}

resource cosmosSqlDb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-02-15-preview' = if (deployBackend) {
  parent: cosmos
  name: cosmosDatabaseName
  properties: {
    resource: {
      id: cosmosDatabaseName
    }
    options: {}
  }
}

resource cosmosStations 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-02-15-preview' = if (deployBackend) {
  parent: cosmosSqlDb
  name: stationsContainerName
  properties: {
    resource: {
      id: stationsContainerName
      partitionKey: {
        kind: 'Hash'
        paths: [
          '/campaignId'
        ]
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
    }
    options: {}
  }
}

resource cosmosQuadrats 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-02-15-preview' = if (deployBackend) {
  parent: cosmosSqlDb
  name: quadratsContainerName
  properties: {
    resource: {
      id: quadratsContainerName
      partitionKey: {
        kind: 'Hash'
        paths: [
          '/stationId'
        ]
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
    }
    options: {}
  }
}

resource cosmosSyncEvents 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-02-15-preview' = if (deployBackend) {
  parent: cosmosSqlDb
  name: syncEventsContainerName
  properties: {
    resource: {
      id: syncEventsContainerName
      partitionKey: {
        kind: 'Hash'
        paths: [
          '/campaignId'
        ]
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      uniqueKeyPolicy: {
        uniqueKeys: []
      }
    }
    options: {}
  }
}

resource staticWebApp 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: staticWebAppLocation
  tags: tags
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    allowConfigFileUpdates: true
    provider: 'Custom'
    enterpriseGradeCdnStatus: 'Disabled'
    publicNetworkAccess: 'Enabled'
    stagingEnvironmentPolicy: 'Enabled'
  }
}

output resourceGroupName string = resourceGroup().name
output staticWebAppDefaultHostname string = staticWebApp.properties.defaultHostname
output backendEnabled bool = deployBackend
output functionAppUrl string = deployBackend ? 'https://${functionApp!.properties.defaultHostName}' : ''
output cosmosEndpoint string = deployBackend ? cosmos!.properties.documentEndpoint : ''
