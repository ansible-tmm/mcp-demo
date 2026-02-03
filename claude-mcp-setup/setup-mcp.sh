#!/bin/bash
#
# Setup script for AAP MCP servers in Claude Code
#
# This is a ONE-TIME setup. Once configured, AAP MCP servers will
# automatically load every time you start Claude Code.
#
# This script adds all 6 AAP MCP toolsets:
#   - aap-job-mgmt      (Job Management)
#   - aap-inventory     (Inventory Management)
#   - aap-monitoring    (System Monitoring)
#   - aap-user-mgmt     (User Management)
#   - aap-security      (Security & Compliance)
#   - aap-config        (Platform Configuration)
#
# Prerequisites:
# - Claude Code installed (npm install -g @anthropics/claude-code)
# - Environment variables set: AAP_SERVER, AAP_SERVICE_TOKEN
#

set -e

# Check prerequisites
if ! command -v claude &> /dev/null; then
    echo "Error: Claude Code is not installed."
    echo "Install with: npm install -g @anthropics/claude-code"
    exit 1
fi

if [ -z "$AAP_SERVER" ]; then
    echo "Error: AAP_SERVER environment variable is not set."
    echo "Set it with: export AAP_SERVER=\"https://your-aap-instance.com\""
    exit 1
fi

if [ -z "$AAP_SERVICE_TOKEN" ]; then
    echo "Error: AAP_SERVICE_TOKEN environment variable is not set."
    echo "Set it with: export AAP_SERVICE_TOKEN=\"your-token-here\""
    exit 1
fi

# Define toolsets: "name:endpoint"
TOOLSETS=(
    "aap-job-mgmt:job_management"
    "aap-inventory:inventory_management"
    "aap-monitoring:system_monitoring"
    "aap-user-mgmt:user_management"
    "aap-security:security_compliance"
    "aap-config:platform_configuration"
)

echo "Setting up AAP MCP servers for Claude Code..."
echo "AAP Server: $AAP_SERVER"
echo ""

# Add each toolset
for i in "${!TOOLSETS[@]}"; do
    IFS=':' read -r name endpoint <<< "${TOOLSETS[$i]}"
    echo "[$((i+1))/${#TOOLSETS[@]}] Adding ${name}..."
    claude mcp add --transport http "$name" "${AAP_SERVER}/${endpoint}/mcp" \
      --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
      --scope user
done

echo ""
echo "✅ Setup complete! All ${#TOOLSETS[@]} AAP MCP servers configured."
echo ""
echo "These servers will now automatically load every time you start Claude Code."
echo "No need to run this script again unless you're setting up a new machine"
echo "or your AAP server URL/token changes."
echo ""
echo "Verify installation: claude mcp list"
echo "To remove all:       ./remove-mcp.sh"
echo ""
