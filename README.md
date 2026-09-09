# Genesys Gamification External Metrics Populator

PowerShell script to populate Genesys Cloud gamification external metrics for multiple agents using the `gc.exe` CLI and authenticated session.

## Features

- ✅ Posts external metric data to Genesys Cloud
- ✅ Supports multiple agents in a single batch request
- ✅ Uses authenticated `gc.exe` CLI session
- ✅ Region-aware (configurable environment)
- ✅ Random metric values for testing
- ✅ Color-coded console output with detailed logging

## Prerequisites

1. **Genesys Cloud CLI** - Download and install from https://developer.genesys.cloud/cli
2. **Authenticated Session** - Login with `gc.exe` using your credentials
3. **PowerShell 5.0+** - Windows PowerShell or PowerShell Core
4. **Required Permission** - `employeePerformance:externalMetricData:add`

## Quick Start

### 1. Authenticate with Genesys Cloud CLI

```powershell
gc.exe tokens me get
```

This confirms you have an active authenticated session.

### 2. Download and Run the Script

```powershell
Remove-Item .\populate_gamification_metrics.ps1 -Force -ErrorAction SilentlyContinue
$url = "https://raw.githubusercontent.com/JamesBaker-Advania/genesys-gamification-script/main/populate_gamification_metrics.ps1?t=$(Get-Random)"
Invoke-WebRequest -Uri $url -OutFile "populate_gamification_metrics.ps1" -UseBasicParsing
powershell -ExecutionPolicy Bypass -File .\populate_gamification_metrics.ps1
```

## Configuration

### Add New Agents

Edit `populate_gamification_metrics.ps1` and modify the `$agentIds` array:

```powershell
$agentIds = @(
    "agent-uuid-1",
    "agent-uuid-2",
    "agent-uuid-3"
)
```

To find agent UUIDs in Genesys Cloud:
1. Navigate to **Admin > People > Employees**
2. Click on an employee to view their details
3. Copy the UUID from the URL or employee details page

### Change Metric Definition

Edit `populate_gamification_metrics.ps1` and update the `$metricId` variable:

```powershell
$metricId = "your-metric-uuid-here"
```

To find your metric definition ID in Genesys Cloud:
1. Navigate to **Admin > Gamification > External Metrics**
2. Click on the metric you want to use
3. Copy the metric ID (e.g., "800fb024-26d2-46f4-96e0-95a6ab170695")

### Change Environment / Region

The script uses your authenticated `gc.exe` session environment by default. To override the environment:

**Option 1: Set in gc.exe profile**
```powershell
gc.exe profiles set DEFAULT --environment mypurecloud.de
gc.exe tokens me get
```

**Option 2: Override in script execution**
```powershell
gc.exe employeeperformance externalmetrics data create --file metric_payload.json --environment mypurecloud.de
```

**Supported Environments:**
- `mypurecloud.com` - US (default)
- `mypurecloud.de` - Germany (EMEA)
- `mypurecloud.com.au` - Australia
- `mypurecloud.ca` - Canada
- `mypurecloud.jp` - Japan
- `ap-southeast-2` - Asia Pacific

### Change OAuth / Authentication

The script uses your current `gc.exe` authenticated session. To switch to a different user or organization:

```powershell
# Logout current session
gc.exe tokens me delete

# Login with new credentials
gc.exe tokens me get

# Verify authentication
gc.exe organizations list
```

To use a specific OAuth client override (advanced):
```powershell
gc.exe employeeperformance externalmetrics data create `
  --file metric_payload.json `
  --clientid "your-client-id" `
  --clientsecret "your-client-secret"
```

## Roadmap

### Phase 1: External Agent File Configuration ✅ In Progress
- [ ] Add support for `agents.json` or `agents.csv` file
- [ ] Script reads agent IDs from external file instead of hardcoded array
- [ ] Support for agent name to UUID mapping

**Example `agents.json`:**
```json
{
  "agents": [
    {
      "name": "Agent Name",
      "uuid": "a481eb96-4b65-455a-91ff-6dd0d30524de"
    },
    {
      "name": "Another Agent",
      "uuid": "9e147adf-14d6-4910-8c23-c6dedef0db58"
    }
  ]
}
```

### Phase 2: Automated Weekly Scheduled Updates ✅ In Progress
- [ ] Create Windows Task Scheduler configuration
- [ ] PowerShell scheduled job for weekly execution
- [ ] Support for configurable schedule (daily, weekly, monthly)
- [ ] Email notifications on success/failure

**Example scheduled execution:**
```powershell
# Create weekly scheduled task (every Monday at 8:00 AM)
$trigger = New-ScheduledJobTrigger -Weekly -DaysOfWeek Monday -At 08:00
Register-ScheduledJob -Name "Genesys-Gamification-Weekly" `
  -ScriptBlock { & "C:\Scripts\populate_gamification_metrics.ps1" } `
  -Trigger $trigger `
  -RunAs32 $false
```

### Phase 3: Enhanced Features
- [ ] Configurable metric value generation (not just random)
- [ ] Support for multiple metrics in single run
- [ ] Metric value input from CSV file
- [ ] Logging to file with audit trail
- [ ] Error retry logic with exponential backoff
- [ ] Slack/Teams notifications for job status

## Troubleshooting

### Error: "404 Not Found"
- ✅ Ensure metric ID exists in Genesys Cloud
- ✅ Verify agent UUIDs are valid
- ✅ Check that metric definition is **Active** in Gamification settings

### Error: "Unauthorized"
- ✅ Verify `gc.exe` authenticated session: `gc.exe tokens me get`
- ✅ Ensure you have `employeePerformance:externalMetricData:add` permission
- ✅ Re-authenticate: `gc.exe tokens me delete` then `gc.exe tokens me get`

### Error: "Unknown command"
- ✅ Verify `gc.exe` is installed: `gc.exe version`
- ✅ Update `gc.exe` to latest version
- ✅ Ensure command is: `gc.exe employeeperformance externalmetrics data create`

### Script doesn't execute
- ✅ Check PowerShell execution policy: `Get-ExecutionPolicy`
- ✅ Run with bypass: `powershell -ExecutionPolicy Bypass -File .\populate_gamification_metrics.ps1`

## API Documentation

- **Endpoint:** `POST /api/v2/employeeperformance/externalmetrics/data`
- **Required Permission:** `employeePerformance:externalMetricData:add`
- **Documentation:** https://developer.genesys.cloud/api/rest/v2/employeeperformance/#post-api-v2-employeeperformance-externalmetrics-data

### Request Body Schema

```json
{
  "items": [
    {
      "userId": "agent-uuid",
      "metricId": "metric-uuid",
      "dateOccurred": "2026-09-09T10:05:53.000Z",
      "value": 223
    }
  ]
}
```

## License

MIT License - See LICENSE file for details

## Support

For issues or questions:
1. Check the Troubleshooting section above
2. Review Genesys Cloud API documentation: https://developer.genesys.cloud/
3. Contact Advania support

---

**Last Updated:** 2026-09-09
**Maintained by:** Advania Team
