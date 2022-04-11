# Azure Bicep Best Practices

### Azure official bicep modules

Azure team works on the Bicep modules in this repo https://github.com/Azure/ResourceModules, but their documents are suck, 

* have no any examples for reference
* Only for Windows users with PowerShell
* Azure CLI runs with PowerShell as well
* Not friendly to Mac/Linux users 

I'd like to use the chance to show the best practices to Mac/Linux users, on how we use Bicep to manage Azure resources with proper way.

### What's Azure Bicep

>[Azure Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep) is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. In a Bicep file, you define the infrastructure you want to deploy to Azure, then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. Your resources are deployed in a consistent manner.

### What is in this repo

* Sample to manage multiple Bicep modules (`Virtual Network` and `Virtual Machine Scale Sets`)
* Sample to show how we can reference one module's output and feed to other modules
* Sample on how to use Azure Bicep modules to prepare the IaC deploy codes
* Sample to manage deployment for different environments
* Sample to manage bicep dry-run and deploy via Makefile

### Usage

Prerequesite

* [install Azure cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* (optional) If got this error:

>The property 'securityProfile.encryptionAtHost' is not valid because the 'Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription.

* Dry run with command: `make dryRun env=dev`
* deploy with command: `make deploy env=dev`

### tips in preparing Bicep files

* always use single quotes
* reference output from another modules 

https://github.com/ozbillwang/Azure-Bicep-Best-Practices/blob/master/deploy.bicep#L67

>            'id': virtualNetwork.outputs.subnetResourceIds[0]

* parameter names, variable names, function names, modules can't be duplicated, the design doesn't like what Terraform did, such as `var.name`, `module.name` but in Bicep, these variables can't identify. All of them are referenced by its name directly. 

>     adminUsername: adminUsername (in this sample, `adminUsername` is parameter)
>     adminPassword: adminPassword (in this sample, `adminPassword` is variable)
>     'id': virtualNetwork.outputs.subnetResourceIds[0] (in this sample, virtualNetwork is the module name)
