# Check if the token is stored in the environment variable
$token = [System.Environment]::GetEnvironmentVariable('AZURE_AD_TOKEN', 'User')

if (-not $token) {
    Write-Error "Token is not set in the environment variable. Please set the AZURE_AD_TOKEN environment variable and try again."
    return
}

# Prompt the user for the UserPrincipalName
$userPrincipalName = Read-Host "Enter the UserPrincipalName of the user you wish to retrieve information about"

# Azure AD User retrieval endpoint
$uri = "https://graph.microsoft.com/v1.0/users/$userPrincipalName"

# Prepare the headers with the token
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"  = "application/json"
}

try {
    # Make the API call to retrieve the user
    $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
    $response | Format-List
} catch {
    Write-Error "Failed to retrieve user"
    Write-Error $_.Exception.Message
}
