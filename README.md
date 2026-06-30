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
2. Run `build-solution` to package the solution.
3. Run `deploy-solution` and choose the deployment stage.
4. Configure GitHub Environments (`dev`, `test`, `prod`) with required approvals.

## Notes

- `deploy-settings.json` can be generated with `pac solution create-settings`.
- Use `import_mode` to select one of: `overwrite`, `upgrade`, `skip_lower_version`.
