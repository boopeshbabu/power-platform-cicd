param(
    [Parameter(Mandatory=$true)]
    [string]$DevDataverseUrl,

    [Parameter(Mandatory=$true)]
    [string]$TestDataverseUrl,

    [Parameter(Mandatory=$true)]
    [string]$DataverseClientId,

    [Parameter(Mandatory=$true)]
    [string]$DataverseClientSecret,

    [Parameter(Mandatory=$true)]
    [string]$AzureTenantId,

    [string]$ProdDataverseUrl = ''
)

function Set-EnvSecret {
    param(
        [string]$Environment,
        [string]$Name,
        [string]$Value
    )

    if (-not $Value) {
        Write-Host "Skipping empty secret $Name for environment $Environment"
        return
    }

    Write-Host "Setting $Name for environment $Environment"
    gh secret set $Name --env $Environment --body $Value
}

Set-EnvSecret -Environment dev -Name DATAVERSE_URL -Value $DevDataverseUrl
Set-EnvSecret -Environment test -Name DATAVERSE_URL -Value $TestDataverseUrl
Set-EnvSecret -Environment prod -Name DATAVERSE_URL -Value $ProdDataverseUrl

$commonSecrets = @{
    DATAVERSE_CLIENT_ID = $DataverseClientId
    DATAVERSE_CLIENT_SECRET = $DataverseClientSecret
    AZURE_TENANT_ID = $AzureTenantId
}

foreach ($env in @('dev', 'test', 'prod')) {
    foreach ($name in $commonSecrets.Keys) {
        Set-EnvSecret -Environment $env -Name $name -Value $commonSecrets[$name]
    }
}

Write-Host 'Done setting environment secrets.'

