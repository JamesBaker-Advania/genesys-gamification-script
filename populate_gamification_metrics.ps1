$externalMetricId = "800fb024-26d2-46f4-96e0-95a6ab170695"
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
Write-Host ""

foreach ($agentId in $agentIds) {
    $value = Get-Random -Minimum 100 -Maximum 601
    
    $payload = @{
        userId = $agentId
        metricId = $externalMetricId
        date = Get-Date -Format "yyyy-MM-dd"
        value = $value
    } | ConvertTo-Json
    
    Write-Host "Posting metric for Agent: $agentId" -ForegroundColor White
    Write-Host "Value: $value" -ForegroundColor White
    Write-Host "Payload: $payload" -ForegroundColor Gray
    
    try {
        $response = & gc.exe post external-metrics gamification --body $payload 2>&1
        Write-Host "Response: $response" -ForegroundColor Gray
        Write-Host "Success - Total Sales Value: $value" -ForegroundColor Green
        $successCount = $successCount + 1
    }
    catch {
        Write-Host "Failed to post metric for Agent: $agentId" -ForegroundColor Red
        Write-Host "Error: $_" -ForegroundColor Red
        $failCount = $failCount + 1
    }
    
    Write-Host ""
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Results:" -ForegroundColor Yellow
Write-Host "Successful: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Cyan
