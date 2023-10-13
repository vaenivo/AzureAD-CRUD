# Clear previous token from the environment variable, if exists
if ($env:AZURE_AD_TOKEN) {
    Remove-Item Env:AZURE_AD_TOKEN
}

# Prompt for Azure App Registration details
$tenantId = Read-Host "Enter Tenant ID"
$clientId = Read-Host "Enter Client ID"
$secret = Read-Host "Enter Secret"

# Endpoint to get the token
$tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

# Scopes for Microsoft Graph
$scope = "https://graph.microsoft.com/.default"

# Body for the token request
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $secret
    scope         = $scope
}

try {
    # Request the token
    $response = Invoke-RestMethod -Method Post -Uri $tokenUrl -ContentType "application/x-www-form-urlencoded" -Body $body

    # Extract the token
    $token = $response.access_token

    # Store the token in the environment variable for use in other scripts
    [Environment]::SetEnvironmentVariable("AZURE_AD_TOKEN", $token, "Process")

    # Display token obtained
    Write-Output "Access Token successfully obtained and stored in the environment variable."

} catch {
    Write-Error "Failed to obtain token. Error: $_"
}

    # Print out more detailed response if available
    if ($_.Exception.Response) {
        Write-Error "Response Status: $($_.Exception.Response.StatusCode.Value__)"
        Write-Error "Response Details: $($_.Exception.Response.Content.ReadAsStringAsync().Result)"
    }

