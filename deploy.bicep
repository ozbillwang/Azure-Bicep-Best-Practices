param namePrefix string = 'ExampleDeployment'

param env string = 'DEV'

param lock string = 'CanNotDelete'

param addressPrefixes array = [
  '10.0.0.0/16'
]

param subnets array = [
  {
    'name': 'AppSubnet'
    'addressPrefix': '10.0.0.0/24'
  }
]

param adminUsername string = 'adminUsername'

param imageReference object = {
  'publisher': 'Canonical'
  'offer': 'UbuntuServer'
  'sku': '18.04-LTS'
  'version': 'latest'
}

param osDisk object = {
  createOption: 'FromImage'
  caching: 'ReadWrite'
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
  diskSizeGB: 30
}

param osType string = 'Linux'

param skuName string = 'Standard_DS1_v2'

// https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions-string#newguid
param guidValue string = newGuid()

var adminPassword = '${toUpper(uniqueString(resourceGroup().id))}-${guidValue}'

var name = '${namePrefix}-${env}'

// virtual network
module virtualNetwork 'ResourceModules/arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: '${name}-VNET'
  params: {
    name: '${name}-VNET'
    addressPrefixes: addressPrefixes
    lock: lock
    subnets: subnets
  }
}

// virtual machine scalesets
var nicConfigurations =[
  {
    'nicSuffix': '-nic01'
    'ipConfigurations': [
      {
        'name': 'ipconfig1'
        'properties': {
          'subnet': {
            'id': virtualNetwork.outputs.subnetResourceIds[0]
          }
        }
      }
    ]
  }
]

module scalesets 'ResourceModules/arm/Microsoft.Compute/virtualMachineScaleSets/deploy.bicep' = {
  name: '${name}-VMSS'
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    imageReference: imageReference
    name: '${name}-VMSS'
    nicConfigurations: nicConfigurations
    osDisk: osDisk
    osType: osType
    skuName: skuName
  }
}
