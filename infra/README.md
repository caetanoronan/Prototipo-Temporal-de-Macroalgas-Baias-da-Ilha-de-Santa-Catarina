# Azure automation (Bicep + GitHub Actions)

This folder provisions the Azure baseline for the prototype.

The first deployment is intentionally conservative: it deploys only the Static Web App by default.
The backend resources are optional and should be enabled only when the app starts syncing data to Azure.

- Resource Group (created by workflow command)
- Static Web App
- Optional backend: Function App + Storage + Application Insights
- Optional database: Cosmos DB SQL account + database + containers

## Files

- main.bicep: core infrastructure template
- main.parameters.json: default names and environment settings
- ../.github/workflows/azure-deploy.yml: deployment pipeline

## Required GitHub secret

Create this repository secret before running the workflow:

- AZURE_CREDENTIALS
- FIELD_API_KEY

Use a service principal JSON with Contributor access on the subscription or resource group.
For the first run, subscription-level permission is recommended because the workflow registers Azure resource providers
such as `Microsoft.Web`. If the service principal only has resource-group access, ask the Azure subscription owner to
register the providers once before running the workflow.

`FIELD_API_KEY` is a shared pilot key used by the field app to sync with the Function API. It is not a substitute for
user login, but it prevents casual anonymous writes during prototype testing.

## First run

1. Open GitHub Actions.
2. Run workflow: Azure Deploy (Infra + Static Site).
3. Check logs for resource creation and site upload.

Before the first deploy, register this Azure provider once at subscription level:

- Microsoft.Web

The workflow checks that `Microsoft.Web` is registered, but does not register it automatically because the GitHub
service principal may only have deployment permissions.

Current behavior:

- deployBackend=true
- Static Web App is deployed.
- Function App, Storage, Application Insights and Cosmos DB serverless are deployed.
- Function API code from `api/` is deployed after infrastructure.

Cosmos DB uses serverless mode for the pilot to reduce idle cost.

## Enabling the backend later

If you need to disable the backend temporarily:

1. Set `deployBackend` to `false` in `infra/main.parameters.json`.
2. Rerun the workflow.
3. The Static Web App remains available, but cloud sync stops.

## Notes

- Names for Function App, Storage and Cosmos must be globally unique.
- If a name is already taken, edit infra/main.parameters.json and rerun.
- This workflow deploys infra and static content.
- Function API code deployment can be added in a separate workflow once API code is committed.
- Never commit infra/azure-credentials.json.
