# Genesys Gamification External Metric Populator
# Uses gc.exe employeeperformance externalmetrics data create command
# Region: DE (mypurecloud.de)

$metricId = "800fb024-26d2-46f4-96e0-95a6ab170695"
$agentIds = @(
    "a481eb96-4b65-455a-91ff-6dd0d30524de",
    "9e147adf-14d6-4910-8c23-c6dedef0db58",
    "3e84e239-c484-4a55-a7bf-151960217bfb",
    "ce601c30-be41-4047-b5c3-f288838e7c15",
    "0d34f0b7-fad1-47d0-b593-964d44b265a2"
)

$date = Get-Date -Format "yyyy-MM-ddTHH:mm:ss.000Z"
$successCount = 0
$failCount = 0

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Genesys Gamification Metric Populator" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Metric: Total Sales Value" -ForegroundColor Yellow
Write-Host "Timestamp: $date" -ForegroundColor Yellow
Write-Host "Agents: $($agentIds.Count)" -ForegroundColor Yellow
Write-Host "Region: DE (mypurecloud.de)" -ForegroundColor Yellow
Write-Host "Endpoint: /api/v2/employeeperformance/externalmetrics/data" -ForegroundColor Yellow
Write-Host ""

# Build items array
$items = @()
foreach ($agentId in $agentIds) {
    $value = Get-Random -Minimum 100 -Maximum 601
    
    $item = @{
        userId = $agentId
        metricId = $metricId
        dateOccurred = $date
        value = $value
    }
    $items += $item
    
    Write-Host "Preparing metric for Agent: $agentId" -ForegroundColor White
    Write-Host "Value: $value" -ForegroundColor White
}

# Create request body
$requestBody = @{
    items = $items
}

$jsonBody = $requestBody | ConvertTo-Json -Depth 10
Write-Host "" 
Write-Host "Full Payload:" -ForegroundColor Cyan
Write-Host $jsonBody -ForegroundColor Gray
Write-Host ""

# Save to temporary file
$tempFile = "$env:TEMP\metric_payload_$(Get-Random).json"
$jsonBody | Out-File -FilePath $tempFile -Encoding UTF8

Write-Host "Posting all metrics to Genesys Cloud..." -ForegroundColor Cyan
Write-Host ""

try {
    # Use gc.exe to make the API call with authenticated session
    $response = & gc.exe employeeperformance externalmetrics data create --file $tempFile --outputformat json 2>&1
    Write-Host "Response: $response" -ForegroundColor Green
    Write-Host "Success - Metrics posted!" -ForegroundColor Green
    $successCount = $agentIds.Count
}
catch {
    Write-Host "Failed to post metrics" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    $failCount = $agentIds.Count
}
finally {
    # Clean up temp file
    Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Results:" -ForegroundColor Yellow
Write-Host "Metrics Submitted: $($agentIds.Count)" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
