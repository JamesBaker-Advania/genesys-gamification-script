#!/usr/bin/env bash

################################################################################
# Genesys Gamification External Metric Populator
# 
# This script populates the "Total Sales Value" gamification metric for 5 agents
# with random values between 100-600 for mockup and demo purposes.
################################################################################

# Configuration
EXTERNAL_METRIC_ID="800fb024-26d2-46f4-96e0-95a6ab170695"

# Array of 5 agent User IDs
AGENT_IDS=(
    "a481eb96-4b65-455a-91ff-6dd0d30524de"
    "9e147adf-14d6-4910-8c23-c6dedef0db58"
    "3e84e239-c484-4a55-a7bf-151960217bfb"
    "ce601c30-be41-4047-b5c3-f288838e7c15"
    "0d34f0b7-fad1-47d0-b593-964d44b265a2"
)

# Get current timestamp
DATE=$(date +"%Y-%m-%dT%H:%M:%S.000Z")

echo "========================================="
echo "Genesys Gamification Metric Populator"
echo "========================================="
echo "Metric: Total Sales Value"
echo "Timestamp: $DATE"
echo "Agents: ${#AGENT_IDS[@]}"
echo ""

# Initialize counters
SUCCESS_COUNT=0
FAIL_COUNT=0

# Loop through each agent and post a metric
for AGENT_ID in "${AGENT_IDS[@]}"; do
    # Generate random value between 100-600
    VALUE=$((RANDOM % 501 + 100))
    
    # Create JSON payload for this agent
    PAYLOAD=$(cat <<EOF
[
  {
    "userId": "$AGENT_ID",
    "externalMetricDefinitionId": "$EXTERNAL_METRIC_ID",
    "dateOccurred": "$DATE",
    "value": $VALUE
  }
]
EOF
)
    
    # Post the metric
    echo "Posting metric for Agent: $AGENT_ID"
    gcloud analytics post externalmetrics "body=$PAYLOAD"
    
    if [ $? -eq 0 ]; then
        echo "✓ Success - Total Sales Value: $VALUE"
        ((SUCCESS_COUNT++))
    else
        echo "✗ Failed to post metric for Agent: $AGENT_ID"
        ((FAIL_COUNT++))
    fi
    
    echo ""
done

echo "========================================="
echo "Results:"
echo "✓ Successful: $SUCCESS_COUNT"
echo "✗ Failed: $FAIL_COUNT"
echo "========================================="