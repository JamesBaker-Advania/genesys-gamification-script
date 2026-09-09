# Genesys Gamification External Metric Populator
# Populates "Total Sales Value" metric for 5 agents with random values (100-600)

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
    
    $payload = @(
        @{
            userId = $agentId
            externalMetricDefinitionId = $externalMetricId
            dateOccurred = $date
            value = $value
        }
    ) | ConvertTo-Json -Depth 10
    
    Write-Host "Posting metric for Agent: $agentId" -ForegroundColor White
    
    try {
        & gc.exe analytics post externalmetrics "body=$payload"
        Write-Host "✓ Success - Total Sales Value: $value" -ForegroundColor Green
        $successCount++
    }
    catch {
        Write-Host "✗ Failed to post metric for Agent: $agentId" -ForegroundColor Red
        Write-Host "Error: $_" -ForegroundColor Red
        $failCount++
    }
    
    Write-Host ""
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Results:" -ForegroundColor Yellow
Write-Host "✓ Successful: $successCount" -ForegroundColor Green
Write-Host "✗ Failed: $failCount" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Cyan
