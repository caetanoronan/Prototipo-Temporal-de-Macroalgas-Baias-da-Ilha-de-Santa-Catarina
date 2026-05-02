# Azure automation (Bicep + GitHub Actions)

This folder provisions the Azure baseline for the prototype:

- Resource Group (created by workflow command)
- Static Web App
- Function App + Storage + Application Insights
- Cosmos DB SQL account + database + containers

## Files

- main.bicep: core infrastructure template
- main.parameters.json: default names and environment settings
- ../.github/workflows/azure-deploy.yml: deployment pipeline

## Required GitHub secret

Create this repository secret before running the workflow:

- AZURE_CREDENTIALS

Use a service principal JSON with Contributor access on the subscription or resource group.

## First run

1. Open GitHub Actions.
2. Run workflow: Azure Deploy (Infra + Static Site).
3. Check logs for resource creation and site upload.

## Notes

- Names for Function App, Storage and Cosmos must be globally unique.
- If a name is already taken, edit infra/main.parameters.json and rerun.
- This workflow deploys infra and static content.
- Function API code deployment can be added in a separate workflow once API code is committed.
