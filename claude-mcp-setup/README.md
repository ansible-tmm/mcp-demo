# Ansible Automation Platform MCP Setup for Claude

Connect Claude (Claude Code CLI, Cursor IDE, or other MCP clients) to Ansible Automation Platform via MCP (Model Context Protocol) servers for natural language interaction with your AAP infrastructure.

> **Note**: This directory is part of the [mcp-demo](https://github.com/ansible-tmm/mcp-demo) repository, which also includes Cursor IDE configurations for connecting to AAP MCP servers.

---

## Quick Start

**One-time setup** - MCP servers automatically load every time you start Claude Code.

### 1. Prerequisites

- **Claude Code** installed: `npm install -g @anthropics/claude-code`
- **AAP API Token** (see [Getting an AAP Token](#getting-an-aap-token))
- **AAP Instance** accessible via URL

### 2. Set Environment Variables

**Option A: Secure Method (Recommended)** - Store credentials in a protected file:

```bash
# Copy the template to your home directory
cp .aap-credentials.template ~/.aap-credentials

# Restrict permissions (important!)
chmod 600 ~/.aap-credentials

# Edit the file with your actual credentials
nano ~/.aap-credentials  # or use your preferred editor
```

Add this to your `~/.zshrc` or `~/.bashrc`:

```bash
# Load AAP credentials from secure file
if [ -f ~/.aap-credentials ]; then
    source ~/.aap-credentials
fi
```

**Option B: Direct Method** - Add directly to your shell profile:

```bash
# Add to ~/.zshrc or ~/.bashrc
export AAP_SERVER="https://your-aap-instance.com"
export AAP_SERVICE_TOKEN="your-token-here"

# Optional: For demo environments with self-signed certificates (NOT for production!)
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

**Reload your shell:**
```bash
source ~/.zshrc  # or source ~/.bashrc
```

### 3. Run Setup Script (One-time)

```bash
cd /path/to/mcp-demo/claude-mcp-setup
./setup-mcp.sh
```

**✅ Done!** AAP MCP servers are now configured and will automatically load every time you start Claude Code.

**Verify installation:**
```bash
claude mcp list
# Should show all 6 MCP servers
```

---

## What Gets Installed

The setup script adds **6 AAP MCP servers** to Claude Code:

| Server Name | Description | Tools |
|-------------|-------------|-------|
| `aap-job-mgmt` | Job templates and workflow management | ~15 |
| `aap-inventory` | Host and inventory management | ~12 |
| `aap-monitoring` | System health and metrics | ~18 |
| `aap-user-mgmt` | User, team, and RBAC management | ~10 |
| `aap-security` | Credentials, audit logs, and compliance | ~14 |
| `aap-config` | Projects, execution environments, and settings | ~16 |

**Total**: ~85 tools across all AAP operations

---

## Auto-Loading Behavior

Once configured, MCP servers **automatically load every time you start Claude Code**:

- ✅ No need to re-run `setup-mcp.sh`
- ✅ No need to pass any flags to the `claude` command
- ✅ Just run `claude` from any directory and your AAP tools are ready

**Configuration is stored in:**
- Mac/Linux: `~/.config/claude/mcp_settings.json`
- Windows: `%APPDATA%\claude\mcp_settings.json`

**When to re-run setup:**
- AAP server URL changes
- Service token needs to be updated
- You want to add/remove specific toolsets
- Setting up on a new machine

---

## Manual Setup (Alternative)

If you prefer to configure MCP servers manually or want only specific toolsets:

### Option 1: Minimal Configuration (Job Management Only)

```bash
claude mcp add --transport http aap-job-mgmt "${AAP_SERVER}/job_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user
```

### Option 2: Add Individual Toolsets

```bash
# Job Management
claude mcp add --transport http aap-job-mgmt "${AAP_SERVER}/job_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# Inventory Management
claude mcp add --transport http aap-inventory "${AAP_SERVER}/inventory_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# System Monitoring
claude mcp add --transport http aap-monitoring "${AAP_SERVER}/system_monitoring/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# User Management
claude mcp add --transport http aap-user-mgmt "${AAP_SERVER}/user_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# Security & Compliance
claude mcp add --transport http aap-security "${AAP_SERVER}/security_compliance/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# Platform Configuration
claude mcp add --transport http aap-config "${AAP_SERVER}/platform_configuration/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user
```

---

## Verify Connection

Once Claude Code starts, verify MCP servers are loaded:

```
/mcp
```

You should see all AAP MCP servers listed.

Or ask Claude:
```
You: What AAP MCP tools are available?
```

---

## Example Queries

Try these natural language queries once connected:

### Job Management
```
Show me the last 5 failed jobs and explain why they failed
List all job templates in the Default organization
Run the "Deploy Web Servers" job template
What jobs are currently running?
```

### Inventory Management
```
List all hosts in the production inventory
What inventory groups exist in my environment?
Show me hosts in the webservers group
Which hosts haven't checked in within the last 24 hours?
```

### System Monitoring
```
What's the current health status of my AAP instance?
Show me job execution metrics for the past week
Which hosts have failed health checks recently?
What's the capacity utilization of my execution nodes?
```

### User Management
```
List all users in the system
What teams exist and who are their members?
Show me RBAC role assignments for the production organization
```

### Security & Compliance
```
Show me audit logs for the past 24 hours
List all credentials and their types
What security-related activity has happened recently?
```

### Platform Configuration
```
List all projects and their SCM status
What execution environments are available?
Show me platform settings and configuration
```

---

## Uninstalling

To remove all AAP MCP servers:

```bash
# Use the provided removal script
./remove-mcp.sh

# Or manually remove each server
claude mcp remove aap-job-mgmt
claude mcp remove aap-inventory
claude mcp remove aap-monitoring
claude mcp remove aap-user-mgmt
claude mcp remove aap-security
claude mcp remove aap-config
```

---

## Getting an AAP Token

1. Log into your Ansible Automation Platform web UI
2. Navigate to **Access Management** → **API Tokens**
3. Click **Create Token**
4. Set:
   - **Name**: `claude-code-mcp` (or any descriptive name)
   - **Scope**: Read + Write
5. Click **Create** and copy the token immediately (you won't see it again!)

**Security Note**: The token inherits your user permissions. If you're an admin, the token has admin access. Consider creating a dedicated service account with appropriate RBAC for production use.

---

## Environment Variables Reference

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `AAP_SERVER` | ✅ Yes | AAP instance URL (no trailing slash) | `https://aap.example.com` |
| `AAP_SERVICE_TOKEN` | ✅ Yes | API token from AAP | `abc123...` |
| `NODE_TLS_REJECT_UNAUTHORIZED` | ❌ No | Disable SSL verification (demo only!) | `0` |

**⚠️ Never set `NODE_TLS_REJECT_UNAUTHORIZED=0` in production!** This disables SSL certificate validation and should only be used in development/demo environments.

See [.env.example](.env.example) for a complete template you can copy to your shell profile.

---

## Troubleshooting

### Environment variables not set

Verify environment variables are loaded:
```bash
echo $AAP_SERVER
echo $AAP_SERVICE_TOKEN
```

If empty, make sure you:
1. Added them to `~/.zshrc` or `~/.bashrc`
2. Reloaded your shell: `source ~/.zshrc`

### MCP servers not showing up

Check that they're configured:
```bash
claude mcp list
```

If missing, re-run the setup script:
```bash
./setup-mcp.sh
```

### AAP connection errors

Test AAP connectivity:
```bash
curl -H "Authorization: Bearer ${AAP_SERVICE_TOKEN}" "${AAP_SERVER}/api/v2/ping/"
```

If this fails, check:
- AAP_SERVER URL is correct (no trailing slash)
- AAP_SERVICE_TOKEN is valid
- Network connectivity to AAP instance
- Firewall rules allow access

### SSL certificate errors

For demo environments with self-signed certificates:
```bash
export NODE_TLS_REJECT_UNAUTHORIZED=0
source ~/.zshrc  # Reload
```

For production, install proper SSL certificates on your AAP instance.

### Permission denied errors

Your API token may not have sufficient permissions. Check:
- Token scope is set to **Read + Write** (not just Read)
- Your AAP user account has the necessary RBAC permissions
- The resource you're trying to access is in an organization your user can access

### Debug mode

Run Claude Code with debug output:
```bash
claude --debug
```

This shows detailed MCP connection logs.

---

## Updating

To update the MCP server configuration:

```bash
cd /path/to/mcp-demo/claude-mcp-setup
git pull
./setup-mcp.sh  # Re-run to update endpoints if changed
```

---

## Use with Cursor IDE

This MCP configuration also works with Cursor! See the main [README.md](../README.md) for Cursor-specific setup instructions.

Both Claude Code CLI and Cursor can connect to the same AAP MCP servers.

---

## Directory Structure

```
claude-mcp-setup/
├── setup-mcp.sh          # Setup script for all 6 MCP servers
├── remove-mcp.sh         # Removal script for all 6 MCP servers
├── .env.example          # Environment variables template
├── .gitignore            # Git ignore rules
└── README.md             # This file
```

---

## Future Enhancements

We plan to add plugin-based enhancements in the future:

- **Skills**: Custom slash commands for common AAP workflows
- **Hooks**: Auto-approval rules and safety constraints for AAP operations
- **Agents**: Specialized troubleshooting and automation workflows

For now, this simple MCP CLI setup provides full access to all AAP functionality.

---

## Contributing

Found an issue or want to add features? Contributions welcome!

1. Fork the [mcp-demo](https://github.com/ansible-tmm/mcp-demo) repository
2. Make your changes in the `claude-mcp-setup/` directory
3. Test with the setup script
4. Submit a pull request

---

## Related Resources

- [Parent Repository](https://github.com/ansible-tmm/mcp-demo) - AI-Driven Automation Showroom
- [Claude Code Documentation](https://code.claude.com/docs)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)

---

## License

Apache-2.0

---

## Support

For issues related to:
- **This setup**: [Open an issue](https://github.com/ansible-tmm/mcp-demo/issues)
- **Claude Code**: [Claude Code documentation](https://code.claude.com/docs)
- **AAP**: [Red Hat Support](https://access.redhat.com/support)
