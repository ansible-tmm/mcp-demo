# Ansible Automation Platform MCP Demo

This repository demonstrates how to connect Cursor AI to Ansible Automation Platform (AAP) using the Model Context Protocol (MCP).

## Overview

This setup enables Cursor to interact with your Ansible Automation Platform through MCP servers, providing AI-assisted automation management capabilities including:
- Job management
- Inventory management
- System monitoring
- User management
- Security compliance
- Platform configuration

**📝 Note on Documentation**: The [Red Hat documentation](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/latest/html/containerized_installation/deploying-ansible-mcp-server) shows examples with six separate MCP server endpoints. In practice, AAP MCP server provides a **single unified endpoint** at `/api/mcp/` that exposes all tools. This repository uses the correct unified endpoint format.

## Prerequisites

- Ansible Automation Platform 2.6+ with MCP server deployed
- Cursor IDE
- API token from your Ansible Automation Platform

## Setup Instructions

### 1. Get Your AAP API Token

Follow the [Red Hat documentation](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/latest/html/containerized_installation/deploying-ansible-mcp-server#proc-create-api-token-ansible-mcp-server_deploying-ansible-mcp-server) to create an API token for the Ansible MCP server.

Save your token in `mcp_key.txt` (this file is gitignored for security).

### 2. Configure Environment Variable

Set up your API token as an environment variable:

```bash
export MY_SERVICE_TOKEN="your-api-token-here"
```

Or source it from the `mcp_key.txt` file:

```bash
export MY_SERVICE_TOKEN=$(cat /path/to/mcp-demo/mcp_key.txt)
```

**For self-signed certificates** (required for most demo/lab environments):

```bash
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

Add these to your shell profile (`~/.zshrc`, `~/.bashrc`, etc.) to make them permanent:

```bash
export MY_SERVICE_TOKEN=$(cat /Users/sean/Documents/GitHub/IPvSean/mcp-demo/mcp_key.txt)
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

Then restart your terminal or run `source ~/.zshrc`.

### 3. Configure MCP in Cursor

Copy the `mcp-config-template.json` content to your Cursor MCP settings:

1. Open Cursor IDE
2. Click on **Cursor** menu (top menu bar) → **Settings** → **Cursor Settings**
3. In the left sidebar, click on **Tools & MCP**
4. In the MCP section, you'll see a text area for MCP server configuration
5. Copy the entire content from `mcp-config-template.json` and paste it into this text area
6. Replace `https://your-aap-server.com` with your actual Ansible Automation Platform URL
7. Replace `/api/mcp/` if your AAP deployment uses a different path (though `/api/mcp/` is standard)

#### For Self-Signed Certificates (Required for Demo Environments)

If your AAP server uses a self-signed certificate (common in demo/lab environments), Cursor will reject the connection with certificate errors.

**✅ Easiest Solution: Set Environment Variable**

Set this environment variable before launching Cursor:

```bash
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

Then launch Cursor from the same terminal:

```bash
open -a Cursor
```

**To make this permanent** (optional), add to your `~/.zshrc`:

```bash
# Allow Cursor to connect to servers with self-signed certificates
export NODE_TLS_REJECT_UNAUTHORIZED=0
```

Then restart your terminal or run `source ~/.zshrc`.

**Alternative: MCP Config Setting** (may not work in all cases)

You can also try adding `"rejectUnauthorized": false` to your MCP server configuration:

```json
"aap-mcp": {
  "type": "http",
  "url": "https://your-aap-server.com:8448/api/mcp/",
  "headers": {
    "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
  },
  "rejectUnauthorized": false
}
```

However, Cursor's MCP client may not always respect this setting, so the environment variable method is more reliable.

**⚠️ Security Warning**: Only use `NODE_TLS_REJECT_UNAUTHORIZED=0` in development/demo environments. In production, use proper SSL certificates.

#### Quick Setup with Pre-configured Template

If you have access to `sean-config-template.json` (not in git), you can use it directly:
1. Follow steps 1-4 above to open **Cursor** → **Settings** → **Cursor Settings** → **Tools & MCP**
2. Copy the entire content from `sean-config-template.json` (which already has the correct server URL and SSL settings)
3. Paste it into the MCP configuration text area
4. Click **Save** or **Apply**

**Important**: Keep the MCP server names concise (under 20 characters) as AI agents combine the server name with tool names, and most enforce a 64-character limit on the combined identifier.

### 4. Save and Restart Cursor

1. After pasting your MCP configuration, click **Save** or **Apply** in the settings
2. Completely quit Cursor (not just close the window)
3. If you set `NODE_TLS_REJECT_UNAUTHORIZED=0` environment variable, **launch Cursor from terminal**:
   ```bash
   open -a Cursor
   ```
   Or restart your terminal if you added it to your shell profile, then launch Cursor normally
4. Reopen Cursor IDE to load the MCP server connections

### 5. Verify Connection

1. Open Cursor's AI chat (click the chat icon or use keyboard shortcut)
2. In the chat window, enter this prompt:
   ```
   What MCP tools are available for my Ansible Automation Platform?
   ```
3. You should see a response listing the available tools from the AAP MCP servers

If the connection is successful, you'll see tools like:
- Job management tools
- Inventory management tools
- System monitoring tools
- User management tools
- Security compliance tools
- Platform configuration tools

## Usage Examples

Once connected, you can interact with your Ansible Automation Platform through natural language:

- `Give me a list of my Ansible Automation Platform jobs`
- `Show me the current inventory`
- `What is the status of my automation jobs?`
- `Monitor system health`

## Troubleshooting

### MCP Stuck on "Loading Tools"

If Cursor shows "loading tools" for more than 30 seconds, there's likely an issue. Here's what we've discovered:

#### Known Issue: HTTP Transport Compatibility

The AAP MCP server uses a **session-based MCP protocol** that may not be fully compatible with Cursor's HTTP MCP transport. When testing:

```bash
curl -k -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","params":{},"id":1}' \
  https://aap-nostromo.demoredhat.com:8448/api/mcp/
```

Response:
```json
{"jsonrpc":"2.0","error":{"code":-32000,"message":"Bad Request: No valid session ID provided"},"id":null}
```

This indicates the server requires session handling that Cursor's current HTTP MCP implementation may not support.

#### Troubleshooting Steps:

1. **Verify endpoint responds**:
   ```bash
   curl -k -H "Authorization: Bearer YOUR_TOKEN" https://your-aap-server.com:8448/api/mcp/
   ```

2. **Check your API token has correct permissions** in AAP

3. **Try the SSE transport** (if available in future Cursor versions):
   ```json
   {
     "mcpServers": {
       "aap-mcp": {
         "type": "sse",
         "url": "https://your-server.com:8448/api/mcp/events",
         "headers": {
           "Authorization": "Bearer YOUR_TOKEN"
         }
       }
     }
   }
   ```

4. **Check Cursor logs** for specific errors:
   - macOS: `~/Library/Application Support/Cursor/logs/`
   - Look in the most recent directory for `main.log`

5. **Wait for Cursor/AAP updates**: This integration may require updates to either:
   - Cursor's HTTP MCP client to support session-based servers
   - AAP's MCP server to support sessionless HTTP transport
   - Or use of stdio/SSE transport instead

### Correct URL Format

The Ansible Automation Platform MCP server typically has a **single unified endpoint** at `/api/mcp/`, not separate endpoints for each service. Update your configuration to:

```json
{
  "mcpServers": {
    "aap-mcp": {
      "type": "http",
      "url": "https://your-aap-server.com:8448/api/mcp/",
      "headers": {
        "Authorization": "Bearer YOUR_TOKEN"
      },
      "rejectUnauthorized": false
    }
  }
}
```

The MCP server will provide all tools (job management, inventory, monitoring, etc.) through this single endpoint.

### Self-Signed Certificates

If your AAP uses self-signed certificates, you may encounter `400 Bad Request` errors. To resolve:

- For container-based installation: Set `mcp_ignore_certificate_errors` to `true`
- For operator-based installation: Add `IGNORE_CERTIFICATE_ERRORS: true` to the AnsibleAutomationPlatform custom resource

### API Format Errors (406 Status)

If you encounter HTTP 406 errors, ensure your AI tool requests output in JSON format first, then transform as needed.

### Permission Changes

If you change MCP server permissions after deployment, you must delete and recreate the AnsibleMCPServer custom resource.

## File Structure

```
mcp-demo/
├── .gitignore                      # Ignores sensitive files
├── mcp_key.txt                     # Your API token (gitignored)
├── mcp-config-template.json        # Generic template for Cursor MCP configuration
├── sean-config-template.json       # Example config with actual values (gitignored)
├── KNOWN_ISSUES.md                 # Known compatibility issues
├── TOOL_NAME_LIMITS.md             # Analysis of MCP tool name length limits
└── README.md                       # This file
```

## Security Notes

- **Never commit `mcp_key.txt`** to version control
- Store API tokens securely using environment variables
- Rotate tokens regularly following your organization's security policies
- Use appropriate RBAC permissions for the MCP server service account

## Additional Resources

- [Red Hat AAP MCP Server Documentation](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.6/html/containerized_installation/deploying-ansible-mcp-server)
- [Configure MCP in Cursor](https://docs.cursor.com/context/model-context-protocol)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/)

## License

MIT
