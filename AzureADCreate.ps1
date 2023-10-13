# Ensure the token is set
if (-not $env:AZURE_AD_TOKEN) {
    Write-Error "Token is not set in the environment variable. Please set the AZURE_AD_TOKEN environment variable and try again."
    return
}

# Prompt for Tenant ID
$tenantId = Read-Host "Enter your Azure Tenant ID"

# Azure AD User creation endpoint (based on provided Tenant ID)
$uri = "https://graph.microsoft.com/v1.0/users"

# Prepare the headers with the token
$headers = @{
    "Authorization" = "Bearer $($env:AZURE_AD_TOKEN)"
    "Content-Type" = "application/json"
}

# Gather user information
$displayName = Read-Host "Enter the display name (e.g., 'John Doe')"
$mailNickname = Read-Host "Enter the mail nickname (e.g., 'JohnD')"
$userPrincipalName = Read-Host "Enter the user principal name (e.g., 'john.doe@yourdomain.onmicrosoft.com')"
$password = Read-Host "Enter a password (e.g., 'YourSecurePassword123!')"

$userInfo = @{
    accountEnabled = $true
    displayName = $displayName
    mailNickname = $mailNickname
    userPrincipalName = $userPrincipalName
    passwordProfile = @{
        forceChangePasswordNextSignIn = $false
        password = $password
    }
}

# Convert user information to JSON
$body = $userInfo | ConvertTo-Json

try {
    # Make the API call to create the user
    $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $body
    Write-Output "User created successfully. User ID: $($response.id)"
} catch {
    Write-Error "Failed to create user"
    Write-Error $_.Exception.Message
    Write-Error "Detailed Response: $($_.Exception.Response)"
}
