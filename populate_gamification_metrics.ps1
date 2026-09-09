# Genesys Gamification External Metric Populator (PowerShell)
# 
# This script populates the "Total Sales Value" gamification metric for 5 agents
# with random values between 100-600 for mockup and demo purposes.

# Configuration
$externalMetricId = "800fb024-26d2-46f4-96e0-95a6ab170695"

# Array of 5 agent User IDs
$agentIds = @(
    "a481eb96-4b65-455a-91ff-6dd0d30524de",
    "9e147adf-14d6-4910-8c23-c6dedef0db58",
    "3e84e239-c484-4a55-a7bf-151960217bfb",
    "ce601c30-be41-4047-b5c3-f288838e7c15",
    "0d34f0b7-fad1-47d0-b593-964d44b265a2"
)

# Get current timestamp
$date = Get-Date -Format "yyyy-MM-ddTHH:mm:ss.000Z"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Genesys Gamification Metric Populator" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Metric: Total Sales Value" -ForegroundColor Yellow
Write-Host "Timestamp: $date" -ForegroundColor Yellow
Write-Host "Agents: $($agentIds.Count)" -ForegroundColor Yellow
Write-Host ""

# Loop through each agent and post a metric
$successCount = 0
$failCount = 0

foreach ($agentId in $agentIds) {
    # Generate random value between 100-600
    $value = Get-Random -Minimum 100 -Maximum 601
    
    # Create JSON payload for this agent
    $payload = @(
        @{
            userId = $agentId
            externalMetricDefinitionId = $externalMetricId
            dateOccurred = $date
            value = $value
        }
    ) | ConvertTo-Json -Depth 10
    
    # Post the metric using gc.exe (Genesys CLI)
    Write-Host "Posting metric for Agent: $agentId" -ForegroundColor White
    
    try {
        $result = & gc.exe analytics post externalmetrics "body=$payload" 2>&1
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
