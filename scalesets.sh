#!/usr/bin/env bash

# Notes:
# (optional) If got this error:
# The property 'securityProfile.encryptionAtHost' is not valid because the 'Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription.
# run these commands:
#
# az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"
# az provider register -n Microsoft.Compute

# Prerequisite
# download bicep modules with nominate release tag.
# curl -L https://github.com/Azure/ResourceModules/archive/refs/tags/v0.4.0.zip -o v0.4.0.zip
# unzip v0.4.0.zip
# it will generate a new folder, called ResourceModules-<release_tag>, in this sample, it will be
# ResourceModules-0.4.0

env="${env:-DEV}"
name="ExampleDeployment"
region="Central US"
dryRun="${dryRun:-false}"

az group create --name "${name}-${env}" --location "${region}"
inputObject=(
    '--name'           "${name}-${env}"
    '--resource-group' "${name}-${env}"
    '--template-file'  "deploy.bicep"
    '--parameters'     env="${env}"
)

case ${dryRun} in
  false)
    az deployment group create ${inputObject[@]}
    ;;
  true)
    az deployment group create --what-if ${inputObject[@]}
    ;;
  *)
    echo "something wrong, exist"
    exit 1
    ;;
esac
