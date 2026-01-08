# Ansible Automation Platform MCP Demo

This repository demonstrates how to connect Cursor AI to Ansible Automation Platform (AAP) using the Model Context Protocol (MCP).

## Overview

AAP provides **6 separate MCP servers** that enable Cursor to interact with different aspects of your automation platform:

1. **Job Management** - Execute and monitor automation jobs
2. **Inventory Management** - Manage hosts, groups, and inventories
3. **System Monitoring** - Monitor platform health and metrics
4. **User Management** - Manage users, teams, and organizations
5. **Security & Compliance** - Access security policies and audit logs
6. **Platform Configuration** - Configure platform settings

Each server provides specific tools through its own MCP endpoint.

## Prerequisites

- Ansible Automation Platform 2.6+ with MCP server deployed
- Cursor IDE
- API token from your Ansible Automation Platform

## Quick Start

### 1. Get Your AAP API Token

Follow the [Red Hat documentation](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/latest/html/containerized_installation/deploying-ansible-mcp-server#proc-create-api-token-ansible-mcp-server_deploying-ansible-mcp-server) to create an API token.

Save your token in `mcp_key.txt` (gitignored for security).

### 2. Set Environment Variables

Add these to your `~/.zshrc` or `~/.bashrc`:

```bash
# AAP API Token
export MY_SERVICE_TOKEN=$(cat /path/to/mcp-demo/mcp_key.txt)

# Allow self-signed certificates (required for most demo/lab environments)
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

Then run: `source ~/.zshrc`

**⚠️ Security Warning**: Only use `NODE_TLS_REJECT_UNAUTHORIZED=0` in development/demo environments.

### 3. Configure MCP in Cursor

1. Open **Cursor** → **Settings** → **Cursor Settings** → **Tools & MCP**
2. Copy content from `mcp-config-template.json`
3. Replace `YOUR-AAP-SERVER` with your AAP server address (hostname or IP)
4. Replace `${env:MY_SERVICE_TOKEN}` with your actual token OR keep as-is to use the environment variable
5. Click **Save**

**Example Configuration:**

```json
{
  "mcpServers": {
    "aap-mcp-job-management": {
      "type": "streamable-http",
      "url": "https://your-aap-server.com:8448/job_management/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    },
    "aap-mcp-inventory-management": {
      "type": "streamable-http",
      "url": "https://your-aap-server.com:8448/inventory_management/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    }
    // ... (4 more servers - see mcp-config-template.json)
  }
}
```

**⚠️ Important - Server Name Length**: Some tool names are very long. To avoid the 60-character combined name limit, consider using shorter server names like `aap-job`, `aap-inv`, etc. See [TOOL_NAME_LIMITS.md](TOOL_NAME_LIMITS.md) for details.

### 4. Launch Cursor

**From terminal** (to ensure environment variables are loaded):

```bash
open -a Cursor
```

### 5. Verify Connection

In Cursor's AI chat, try:

```
What MCP tools are available for my Ansible Automation Platform?
```

You should see tools from all 6 AAP MCP servers.

## Usage Examples

Once connected, interact with AAP using natural language:

- `List my recent Ansible jobs`
- `Show me all hosts in my inventory`
- `What's the status of my AAP platform?`
- `List all users in my organization`
- `Show me recent activity in the audit log`

## MCP Server Endpoints

AAP provides these MCP server endpoints:

| Service | Endpoint Path | Purpose |
|---------|--------------|---------|
| Job Management | `/job_management/mcp` | Jobs, templates, workflows |
| Inventory Management | `/inventory_management/mcp` | Hosts, groups, inventories |
| System Monitoring | `/system_monitoring/mcp` | Health, metrics, instances |
| User Management | `/user_management/mcp` | Users, teams, organizations, RBAC |
| Security & Compliance | `/security_compliance/mcp` | Credentials, audit logs |
| Platform Configuration | `/platform_configuration/mcp` | Settings, configuration |

All endpoints use the same base URL (your AAP server) and port (typically `:8448`).

## Troubleshooting

### Tool Name Length Errors

If you see errors like "Combined server and tool name length (XX) exceeds 60 characters":

- **Problem**: Server names like `aap-mcp-job-management` (23 chars) are too long
- **Solution**: Use shorter names in your `mcp.json` config
- **Recommended**: `aap-job`, `aap-inv`, `aap-mon`, `aap-user`, `aap-sec`, `aap-cfg`
- **Details**: See [TOOL_NAME_LIMITS.md](TOOL_NAME_LIMITS.md) for complete analysis

### SSL Certificate Errors

If you get `net::ERR_CERT_AUTHORITY_INVALID` errors:

1. Make sure `NODE_TLS_REJECT_UNAUTHORIZED=0` is set
2. Launch Cursor from terminal: `open -a Cursor`
3. Verify with: `echo $NODE_TLS_REJECT_UNAUTHORIZED` (should show `0`)

### Connection Issues

1. **Verify AAP MCP server is running** on your AAP instance
2. **Check API token** is valid and has correct permissions
3. **Test endpoint manually**:
   ```bash
   curl -k -H "Authorization: Bearer YOUR_TOKEN" \
     https://your-aap-server.com:8448/job_management/mcp
   ```
4. **Check Cursor logs**: `~/Library/Application Support/Cursor/logs/`

### MCP Servers Not Loading

- Completely quit Cursor (Cmd+Q) and relaunch from terminal
- Check that all 6 server URLs point to your correct AAP server
- Verify the port (`:8448` is standard for AAP MCP)
- Check for typos in the endpoint paths

## File Structure

```
mcp-demo/
├── .gitignore                      # Ignores sensitive files
├── mcp_key.txt                     # Your API token (gitignored)
├── mcp-config-template.json        # Template for all 6 MCP servers
├── sean-config-template.json       # Example with real values (gitignored)
├── KNOWN_ISSUES.md                 # Known compatibility issues
├── TOOL_NAME_LIMITS.md             # Tool name length analysis (important!)
└── README.md                       # This file
```

## Security Notes

- **Never commit `mcp_key.txt`** to version control
- Store API tokens securely using environment variables
- Rotate tokens regularly
- Only use `NODE_TLS_REJECT_UNAUTHORIZED=0` in dev/demo environments
- Use proper SSL certificates in production

## Additional Resources

- [Red Hat AAP MCP Server Documentation](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.6/html/containerized_installation/deploying-ansible-mcp-server)
- [Configure MCP in Cursor](https://docs.cursor.com/context/model-context-protocol)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/)
- [Tool Name Limits Analysis](TOOL_NAME_LIMITS.md) - Important for avoiding naming errors

## License

MIT
