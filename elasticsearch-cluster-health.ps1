# PowerShell script to validate Elasticsearch cluster health
# Visit: blog.hildenco.com for more information

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$user = '<usr>'
$pass = '<pwd>'
$pair = "$($user):$($pass)"
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"

# PRD
$headers.Add("Authorization", $basicAuthValue)
$url = "http://<your-url>/_cluster/health"

$response = Invoke-RestMethod $url -Method 'GET' -Headers $headers -Body $body

if ($response -eq $null){
    "Error querying the endpoint"
    return
}

$status = $response.status
"Cluster status is: $status" 
