# Claude Code Plugin for Ansible Automation Platform MCP

A Claude Code plugin that provides MCP (Model Context Protocol) server connections to Ansible Automation Platform, enabling natural language interaction with your AAP infrastructure.

> **Note**: This directory is part of the [mcp-demo](https://github.com/ansible-tmm/mcp-demo) repository, which also includes Cursor IDE configurations and documentation for connecting to AAP MCP servers.

## Quick Start

### 1. Prerequisites

- **Claude Code** installed (`npm install -g @anthropics/claude-code`)
- **AAP API Token** (see [Getting an AAP Token](#getting-an-aap-token))
- **AAP Instance** accessible at `AAP_SERVER` URL

### 2. Set Environment Variables

Add these to your `~/.zshrc` or `~/.bashrc`:

```bash
# Required: Your AAP instance URL
export AAP_SERVER="https://your-aap-instance.com"

# Required: AAP API token
export AAP_SERVICE_TOKEN="your-token-here"

# Optional: For demo environments with self-signed certificates (NOT for production!)
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

Then reload your shell:
```bash
source ~/.zshrc  # or source ~/.bashrc
```

### 3. Choose Installation Method

Pick the method that best fits your use case:

| Method | Use Case | Persistence | Team Sharing |
|--------|----------|-------------|--------------|
| [A: Global Installation](#method-a-global-installation-recommended) | Regular daily use | ✅ Permanent | ❌ No |
| [B: Project Installation](#method-b-project-level-installation) | Team collaboration | ✅ Per-project | ✅ Via git |
| [C: Plugin Directory](#method-c-using---plugin-dir-quick-testing) | Quick testing/demos | ❌ Temporary | ❌ No |
| [D: Bash Script](#method-d-bash-script-setup) | CLI-only workflow | ✅ Permanent | ❌ No |

---

## Installation Methods

### Method A: Global Installation (Recommended)

This makes the plugin available from any directory.

```bash
# 1. Clone the repository (if not already cloned)
git clone https://github.com/ansible-tmm/mcp-demo
cd mcp-demo/claude-code-aap-plugin

# 2. Start Claude Code in the plugin directory
claude
```

Inside Claude Code, run:
```
/plugin marketplace add .
```

Exit Claude Code and install from terminal:
```bash
# 3. Install the plugin globally
claude plugin install aap-mcp

# 4. Run Claude Code from anywhere
cd ~
claude
```

**Verify installation:**
```bash
claude plugin list
# Should show: aap-mcp
```

**Uninstall:**
```bash
claude plugin uninstall aap-mcp --scope user
```

---

### Method B: Project-Level Installation

This installs the plugin for a specific project, shared via git.

```bash
# In your project directory
cd ~/your-project

# Start Claude Code
claude
```

Inside Claude Code, run:
```
/plugin marketplace add /path/to/mcp-demo/claude-code-aap-plugin
```

Exit Claude Code and install from terminal:
```bash
# Install the plugin to project scope
claude plugin install aap-mcp --scope project

# Run Claude Code
claude
```

**Uninstall:**
```bash
claude plugin uninstall aap-mcp --scope project
```

---

### Method C: Using --plugin-dir (Quick Testing)

No installation needed, load directly:

```bash
# From the plugin directory
cd ~/path/to/mcp-demo/claude-code-aap-plugin
claude --plugin-dir .

# Or from anywhere, using the full path
claude --plugin-dir ~/path/to/mcp-demo/claude-code-aap-plugin
```

**Create an alias for convenience:**

Add to your `~/.zshrc` or `~/.bashrc`:
```bash
alias claude-aap='claude --plugin-dir ~/path/to/mcp-demo/claude-code-aap-plugin'
```

Then reload and use:
```bash
source ~/.zshrc
claude-aap
```

---

### Method D: Bash Script Setup

For CLI-only workflows, configure MCP servers directly without the plugin system.

**Option 1: Minimal Configuration (Job Management Only)**

```bash
claude mcp add --transport http aap-job-mgmt "${AAP_SERVER}/job_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user
```

**Option 2: Full Configuration (All 6 Toolsets)**

Use the provided setup script:

```bash
# From the plugin directory
cd ~/path/to/mcp-demo/claude-code-aap-plugin
./setup-mcp.sh
```

Or manually add all 6 servers:

```bash
# 1. Job Management
claude mcp add --transport http aap-job-mgmt "${AAP_SERVER}/job_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# 2. Inventory Management
claude mcp add --transport http aap-inventory "${AAP_SERVER}/inventory_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# 3. System Monitoring
claude mcp add --transport http aap-monitoring "${AAP_SERVER}/system_monitoring/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# 4. User Management
claude mcp add --transport http aap-user-mgmt "${AAP_SERVER}/user_management/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# 5. Security & Compliance
claude mcp add --transport http aap-security "${AAP_SERVER}/security_compliance/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user

# 6. Platform Configuration
claude mcp add --transport http aap-config "${AAP_SERVER}/platform_configuration/mcp" \
  --header "Authorization: Bearer ${AAP_SERVICE_TOKEN}" \
  --scope user
```

**Verify installation:**
```bash
claude mcp list
# Should show all 6 MCP servers
```

**Uninstall:**
```bash
claude mcp remove aap-job-mgmt
claude mcp remove aap-inventory
claude mcp remove aap-monitoring
claude mcp remove aap-user-mgmt
claude mcp remove aap-security
claude mcp remove aap-config
```

---

## Verify MCP Servers are Connected

Once Claude Code starts, run:

```
/mcp
```

You should see the AAP MCP servers in the list.

Or ask:
```
You: What AAP MCP tools are available?
```

---

## Available MCP Toolsets

This plugin provides 6 AAP MCP servers:

| Server Name | Description | Approx. Tools |
|-------------|-------------|---------------|
| `aap-job-mgmt` | Job template and workflow management | ~15 |
| `aap-inventory` | Host and inventory management | ~12 |
| `aap-monitoring` | System health and metrics | ~18 |
| `aap-user-mgmt` | User, team, and RBAC management | ~10 |
| `aap-security` | Audit logs and compliance | ~14 |
| `aap-config` | Projects and credentials | ~16 |

**Total**: ~85 tools across all toolsets

---

## Example Queries

Try these natural language queries once connected:

### Job Management
```
Show me the last 5 failed jobs and explain why they failed
Create a job template to deploy nginx to production hosts
What job templates are available in the Default organization?
Run the "Deploy Web Servers" job template
```

### Inventory Management
```
List all hosts in the production inventory
Show me hosts that haven't checked in within the last 24 hours
What inventory groups exist in my environment?
```

### System Monitoring
```
What's the current health status of my AAP instance?
Show me job execution metrics for the past week
Which hosts have failed health checks recently?
```

---

## Configuration

The plugin includes two MCP configuration files:

### `.mcp.json` - Minimal Configuration (Default) ✅ Recommended

Contains only the **Job Management** toolset. This is the recommended starting point:
- ✅ Minimal tool count (~15 tools)
- ✅ Best performance
- ✅ No tool name length errors
- ✅ Works out of the box

### `.mcp-all-toolsets.json` - Full Configuration (All 6 Toolsets)

Contains all 6 AAP toolsets (Job Management, Inventory, Monitoring, User Management, Security, Configuration).

**To enable all toolsets:**

```bash
# Backup current config
cp .mcp.json .mcp-minimal-backup.json

# Switch to all toolsets
cp .mcp-all-toolsets.json .mcp.json

# Reinstall to apply changes (if using Method A or B)
claude plugin update aap-mcp
```

**To switch back to minimal:**

```bash
cp .mcp-minimal-backup.json .mcp.json
claude plugin update aap-mcp
```

### Performance Considerations

**⚠️ Tool Limit Warning**: Enabling all toolsets may cause:
- Performance degradation (80+ tools total)
- Tool name length errors (some AAP MCP server versions)
- Slower Claude response times
- Higher token usage

**Recommendations**:
- ✅ **Start with minimal** (1 toolset, ~15 tools) - Best experience
- ⚠️ **Add selectively** (2-3 toolsets, ~30-45 tools) - Good performance
- ❌ **All toolsets** (6 toolsets, ~85 tools) - May degrade performance

Only enable additional toolsets if you actively need them.

---

## Setup Guides

### Getting an AAP Token

1. Log into your Ansible Automation Platform web UI
2. Navigate to **Access Management** → **API Tokens**
3. Click **Create Token**
4. Set:
   - **Name**: `claude-code-mcp` (or any descriptive name)
   - **Scope**: Read + Write
5. Click **Create** and copy the token immediately (you won't see it again!)

**Security Note**: The token inherits your user permissions. If you're an admin, the token has admin access. Consider creating a dedicated service account with appropriate RBAC for production use.

### Environment Variables Reference

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `AAP_SERVER` | ✅ Yes | AAP instance URL | `https://aap.example.com` |
| `AAP_SERVICE_TOKEN` | ✅ Yes | API token from AAP | `abc123...` |
| `NODE_TLS_REJECT_UNAUTHORIZED` | ❌ No | Disable SSL verification (demo only!) | `0` |

**⚠️ Never set `NODE_TLS_REJECT_UNAUTHORIZED=0` in production!** This disables SSL certificate validation and should only be used in development/demo environments.

---

## Troubleshooting

### Plugin not showing in `claude plugin list`

Make sure you:
1. Added the marketplace inside Claude Code with `/plugin marketplace add`
2. Installed with `claude plugin install` from terminal (not just copied to `~/.claude/plugins/`)

### MCP server not connecting

1. Verify environment variables are set:
   ```bash
   echo $AAP_SERVER
   echo $AAP_SERVICE_TOKEN
   ```

2. Check AAP is accessible:
   ```bash
   curl -H "Authorization: Bearer ${AAP_SERVICE_TOKEN}" "${AAP_SERVER}/api/v2/ping/"
   ```

3. Run with debug mode:
   ```bash
   claude --debug
   ```

### "Tool name length exceeds limit" error

The minimal configuration ([.mcp.json](mcp.json)) should work. If you enabled all toolsets ([.mcp-all-toolsets.json](mcp-all-toolsets.json)), switch back:

```bash
cp .mcp.json .mcp.json.backup
cp .mcp-minimal-backup.json .mcp.json
claude plugin update aap-mcp
```

### "Permission denied" errors from AAP

Your API token may not have sufficient permissions. Check:
- Token scope is set to **Read + Write** (not just Read)
- Your AAP user account has the necessary RBAC permissions
- The resource you're trying to access is in an organization your user can access

### "SSL certificate" errors

For demo environments with self-signed certificates:
```bash
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

For production, install proper SSL certificates on your AAP instance.

---

## Updating the Plugin

### If installed via Method A or B:

```bash
cd /path/to/mcp-demo/claude-code-aap-plugin
git pull
claude plugin update aap-mcp
```

### If using Method C:

Just pull the latest changes:
```bash
cd /path/to/mcp-demo/claude-code-aap-plugin
git pull
```

### If using Method D:

Re-run the setup commands or script with the latest endpoint URLs.

---

## Use with Cursor IDE

This plugin configuration also works with Cursor! Since Cursor supports MCP, you can:

1. See the main [README.md](../README.md) for Cursor MCP configuration
2. Or configure the same MCP servers manually in Cursor Settings → Tools → MCP

Both Claude Code CLI and Cursor will connect to the same AAP MCP servers.

---

## Claude Code Settings

This plugin provides configuration files specifically for Claude Code:

### MCP Configuration Files

**`.mcp.json`** - This is the primary configuration file that Claude Code reads when the plugin loads. It contains:
- MCP server definitions (one or more AAP toolset endpoints)
- Environment variable references (`${AAP_SERVER}`, `${AAP_SERVICE_TOKEN}`)
- Transport type (`http`) optimized for Claude Code CLI

**`.mcp-all-toolsets.json`** - Full configuration with all 6 AAP MCP toolsets. Copy this to `.mcp.json` if you need access to all toolsets.

### Environment Variables

The plugin relies on environment variables for configuration:

```bash
# Required
export AAP_SERVER="https://your-aap-instance.com"      # Your AAP instance URL
export AAP_SERVICE_TOKEN="your-token-here"              # API token from AAP

# Optional (demo environments only)
export NODE_TLS_REJECT_UNAUTHORIZED=0                   # Disable SSL verification
```

See [.env.example](.env.example) for a complete template you can copy to your shell profile.

### Transport Type: http vs streamable-http

**Important difference** between Claude Code and Cursor configurations:

| Client | Transport Type | Configuration File |
|--------|---------------|-------------------|
| **Claude Code** | `http` | `.mcp.json` (this directory) |
| **Cursor IDE** | `streamable-http` | `mcp-config-template.json` (parent directory) |

**Why the difference?**

- **Claude Code** uses standard `http` transport for direct HTTP connections to AAP MCP servers
- **Cursor IDE** requires `streamable-http` for session-based SSE (Server-Sent Events) protocol
- Both connect to the same AAP MCP server endpoints
- The transport type is a client-specific implementation detail

### Configuration Workflow

1. **Set environment variables** in your shell profile (`~/.zshrc` or `~/.bashrc`)
2. **Choose your toolsets**:
   - Use `.mcp.json` as-is for minimal config (job management only)
   - Or copy `.mcp-all-toolsets.json` → `.mcp.json` for all 6 toolsets
3. **Install the plugin** using one of the installation methods above
4. **Launch Claude Code** - the `.mcp.json` file is automatically loaded

### Customizing Your Configuration

To add or remove specific toolsets, edit `.mcp.json`:

```json
{
  "mcpServers": {
    "aap-job-mgmt": {
      "type": "http",
      "url": "${AAP_SERVER}/job_management/mcp",
      "description": "Ansible Automation Platform Job Management",
      "headers": {
        "Authorization": "Bearer ${AAP_SERVICE_TOKEN}"
      }
    }
    // Add more toolsets here if needed
  }
}
```

Available endpoint paths (see [.mcp-all-toolsets.json](.mcp-all-toolsets.json) for complete config):
- `/job_management/mcp`
- `/inventory_management/mcp`
- `/system_monitoring/mcp`
- `/user_management/mcp`
- `/security_compliance/mcp`
- `/platform_configuration/mcp`

---

## Plugin Structure

```
claude-code-aap-plugin/
├── .claude-plugin/
│   ├── plugin.json          # Plugin metadata
│   └── marketplace.json     # Marketplace definition
├── .mcp.json                # Minimal MCP config (job management only)
├── .mcp-all-toolsets.json   # Full MCP config (all 6 toolsets)
├── setup-mcp.sh             # Setup script for all 6 MCP servers
├── remove-mcp.sh            # Removal script for all 6 MCP servers
├── .env.example             # Environment variables template
└── README.md                # This file
```

---

## Contributing

Found an issue or want to add features? Contributions welcome!

1. Fork the [mcp-demo](https://github.com/ansible-tmm/mcp-demo) repository
2. Make your changes in the `claude-code-aap-plugin/` directory
3. Test with `claude --plugin-dir ./claude-code-aap-plugin`
4. Submit a pull request

---

## Related Resources

- [Parent Repository](https://github.com/ansible-tmm/mcp-demo) - AI-Driven Automation Showroom
- [Claude Code Plugins Documentation](https://code.claude.com/docs/en/plugins)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [Ansible Automation Platform](https://www.redhat.com/en/technologies/management/ansible)

---

## License

Apache-2.0

---

## Support

For issues related to:
- **This plugin**: [Open an issue](https://github.com/ansible-tmm/mcp-demo/issues)
- **Claude Code**: [Claude Code documentation](https://code.claude.com/docs)
- **AAP**: [Red Hat Support](https://access.redhat.com/support)
