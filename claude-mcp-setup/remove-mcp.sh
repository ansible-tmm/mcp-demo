#!/bin/bash
#
# Removal script for AAP MCP servers in Claude Code
# This script removes all 6 AAP MCP toolsets from Claude Code
#
# Prerequisites:
# - Claude Code installed (npm install -g @anthropics/claude-code)
#

set -e

# Check prerequisites
if ! command -v claude &> /dev/null; then
    echo "Error: Claude Code is not installed."
    echo "Install with: npm install -g @anthropics/claude-code"
    exit 1
fi

# Define toolsets (same as setup script)
TOOLSETS=(
    "aap-job-mgmt"
    "aap-inventory"
    "aap-monitoring"
    "aap-user-mgmt"
    "aap-security"
    "aap-config"
)

echo "Removing AAP MCP servers from Claude Code..."
echo ""

# Remove each toolset
for i in "${!TOOLSETS[@]}"; do
    name="${TOOLSETS[$i]}"
    echo "[$((i+1))/${#TOOLSETS[@]}] Removing ${name}..."
    claude mcp remove "$name" || echo "  (server not found or already removed)"
done

echo ""
echo "✓ All AAP MCP servers removed!"
echo ""
echo "Verify with: claude mcp list"
echo ""
