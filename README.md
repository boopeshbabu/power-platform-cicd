# Power Platform CI/CD Sample Repository

This repository contains an example GitHub Actions setup for Power Platform solution deployment.

## Workflows

- `.github/workflows/build-solution.yml`
  - Builds and packages a solution folder or reuses an existing solution ZIP.
  - Produces an artifact called `solution-package`.

- `.github/workflows/deploy-solution.yml`
  - Deploys the packaged solution into a target environment.
  - Uses GitHub Environments for stage selection and approvals.

## Required GitHub Secrets

- `DATAVERSE_URL`
- `DATAVERSE_CLIENT_ID`
- `DATAVERSE_CLIENT_SECRET`
- `AZURE_TENANT_ID`

## Usage

1. Add your solution source to the repo, or upload a solution ZIP.
2. Run `build-solution` and provide a comma-separated list of solution names in the workflow input, for example `base,powerautomate,processes`.
3. For a safe deployment to Test, leave the `export latest from environment` checkbox unchecked to package the version already present in the repository.
4. If you want to promote the latest Dataverse state instead, check that box before running the build workflow so the workflow exports the latest solution from the environment, unpacks it, and packages it.
5. Use the commit toggle if you want the unpacked export to be recorded as a git commit, and use the push toggle only if you want that commit sent to GitHub.
6. Run `deploy-solution` and, if you are deploying a previously run build rather than the current workflow run, provide the build workflow run ID in the `build_run_id` input so the deploy workflow can download the `solution-package` artifact from that run.
7. Run `deploy-solution` and choose the deployment stage and the deployment action checkbox (import, upgrade, or update).
8. Configure GitHub Environments (`dev`, `test`, `prod`) with required approvals.

## GitHub environment secrets

This repository uses GitHub Environments for `dev`, `test`, and `prod`.

The deployment workflow requires the following secrets per environment:

- `DATAVERSE_URL` (environment specific)
- `DATAVERSE_CLIENT_ID`
- `DATAVERSE_CLIENT_SECRET`
- `AZURE_TENANT_ID`

Use the GitHub CLI to set those secrets securely, or run the helper script:

```powershell
./scripts/setup-github-secrets.ps1 \
  -DevDataverseUrl "https://your-dev-org.crm.dynamics.com" \
  -TestDataverseUrl "https://your-test-org.crm.dynamics.com" \
  -DataverseClientId "<client-id>" \
  -DataverseClientSecret "<client-secret>" \
  -AzureTenantId "<tenant-id>"
```

The script will configure `DATAVERSE_URL` for `dev` and `test`, and will set the shared secrets across `dev`, `test`, and `prod`.

> Do not share your secret values in the chat. If you want me to apply them here, provide them through a secure terminal command rather than in message text.

## Notes

- `deploy-settings.json` can be generated with `pac solution create-settings`.
- Use `import_mode` to select one of: `overwrite`, `upgrade`, `skip_lower_version`.
