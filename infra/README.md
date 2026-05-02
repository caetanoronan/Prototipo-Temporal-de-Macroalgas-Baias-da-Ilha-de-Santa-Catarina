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

Use a service principal JSON with Contributor access on the subscription or resource group.
For the first run, subscription-level permission is recommended because the workflow registers Azure resource providers
such as `Microsoft.Web`. If the service principal only has resource-group access, ask the Azure subscription owner to
register the providers once before running the workflow.

## First run

1. Open GitHub Actions.
2. Run workflow: Azure Deploy (Infra + Static Site).
3. Check logs for resource creation and site upload.

Before the first deploy, register this Azure provider once at subscription level:

- Microsoft.Web

The workflow checks that `Microsoft.Web` is registered, but does not register it automatically because the GitHub
service principal may only have deployment permissions.

Default behavior:

- deployBackend=false
- Static Web App is deployed.
- Function App, Storage, Application Insights and Cosmos DB are not created.

This keeps the first Azure test low-risk and low-cost.

## Enabling the backend later

Only enable the backend when there is API code ready to receive app data.

1. Set `deployBackend` to `true` in `infra/main.parameters.json`.
2. Provide a secure `apiKey` parameter through a secret-based deployment process.
3. Review Cosmos DB cost before running the workflow.
4. Add a separate Function App code deployment workflow.

## Notes

- Names for Function App, Storage and Cosmos must be globally unique.
- If a name is already taken, edit infra/main.parameters.json and rerun.
- This workflow deploys infra and static content.
- Function API code deployment can be added in a separate workflow once API code is committed.
- Never commit infra/azure-credentials.json.
