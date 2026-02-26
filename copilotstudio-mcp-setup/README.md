# Ansible Automation Platform MCP for Microsoft Copilot Studio

This guide shows you how to connect Microsoft Copilot Studio to your Ansible Automation Platform (AAP) using the Model Context Protocol (MCP) via Power Apps Custom Connectors.

## Overview

Microsoft Copilot Studio requires a different configuration approach than Cursor IDE. While Cursor uses a simple JSON configuration with environment variables, Microsoft Copilot Studio uses **Power Apps Custom Connectors** with OpenAPI specifications.

## Why Use Custom Connectors (Option 2)?

We use **Option 2** (Custom Connector via Power Apps) instead of the MCP onboarding wizard because:

- **Better SSL/TLS handling**: The custom connector approach handles Let's Encrypt certificates more reliably
- **More control**: You can customize the connector configuration
- **Reusable**: Once created, the connector can be used across multiple agents

## Prerequisites

- Microsoft Copilot Studio account
- Access to Power Apps (included with Copilot Studio)
- Ansible Automation Platform with MCP server deployed
- Valid SSL certificate (Let's Encrypt recommended) on your AAP MCP server
- AAP API token

## Files in This Directory

- `aap-mcp-openapi.yaml` - OpenAPI specification for AAP MCP server endpoints
- `README.md` - This setup guide

## Step-by-Step Setup Guide

### 1. Prepare Your OpenAPI File

The `aap-mcp-openapi.yaml` file in this directory defines three MCP endpoints:
- `/job_management/mcp` - Job templates, job execution, and monitoring
- `/inventory_management/mcp` - Hosts, groups, and inventories
- `/system_monitoring/mcp` - Platform health and metrics

**Important**: Update the `host` field in the YAML file with your AAP server hostname and port:

```yaml
host: aap-nostromo.demoredhat.com:8449
```

### 2. Create Custom Connector in Power Apps

1. Go to [Power Apps](https://make.powerapps.com)

2. In the left navigation, click **Custom connectors**

3. Click **+ New custom connector** → **Import an OpenAPI file**

4. Fill in the import dialog:
   - **Connector name**: `aap-mcp-job-management` (or your preferred name)
   - **Upload OpenAPI file**: Select `aap-mcp-openapi.yaml` from this directory
   - Click **Continue**

### 3. Configure General Settings

On the **General** tab, verify/configure:

- **Host**: Should auto-populate from YAML (e.g., `aap-nostromo.demoredhat.com:8449`)
- **Base URL**: Should be `/`
- **Scheme**: Select **HTTPS**
- **Description**: Already filled from YAML
- **Icon** (optional): Upload Ansible logo or leave default
- **Connect via on-premises data gateway**: Leave **unchecked** (assuming public server)

Click **Security →** to continue.

### 4. Configure Authentication

On the **Security** tab:

1. **Authentication type**: Select **API Key** (should auto-populate)

2. **API Key section** should show:
   - **Parameter label**: `API Key` (what users see - can customize)
   - **Parameter name**: `Authorization` ✅ **Critical - must be "Authorization"**
   - **Parameter location**: `Header` ✅ **Critical - must be "Header"**

Click **Definition →** to continue.

### 5. Verify API Definitions

On the **Definition** tab, you should see three actions:

1. **InvokeMCPJobManagement**
   - Summary: Ansible Automation Platform Job Management Server
   - Operation ID: `InvokeMCPJobManagement`
   - Verb: `POST`
   - URL: `https://your-server:8449/job_management/mcp`

2. **InvokeMCPInventoryManagement**
   - Summary: Ansible Automation Platform Inventory Management Server
   - Operation ID: `InvokeMCPInventoryManagement`
   - Verb: `POST`
   - URL: `https://your-server:8449/inventory_management/mcp`

3. **InvokeMCPSystemMonitoring**
   - Summary: Ansible Automation Platform System Monitoring Server
   - Operation ID: `InvokeMCPSystemMonitoring`
   - Verb: `POST`
   - URL: `https://your-server:8449/system_monitoring/mcp`

**Note**: You may see a validation warning "Description not defined" - this is informational only and won't prevent the connector from working.

Click **Create connector** (top right).

### 6. Test the Connection

After creating the connector, you'll be on the **Test** tab:

1. Click **+ New connection**

2. You'll be prompted for "API Key" - Enter your full Authorization header value:
   ```
   Bearer eyJ0eXAiOiJKV1QiLCJhbGc...your-full-token...
   ```
   **Important**: Include the word `Bearer` followed by a space, then your token

3. Click **Create connection**

4. Select the connection you just created

5. Choose one of the operations (e.g., `InvokeMCPJobManagement`)

6. Click **Test operation**

7. If successful, you should see a 200 response with MCP protocol data

### 7. Add Connector to Copilot Studio

1. Go to [Microsoft Copilot Studio](https://copilotstudio.microsoft.com)

2. Open your agent or create a new one

3. Navigate to **Tools** in the left sidebar

4. Click **+ Add a tool**

5. Select **Custom connector**

6. Find your newly created AAP MCP connector (e.g., `aap-mcp-job-management`)

7. Select your existing connection or create a new one

8. Click **Add to agent**

### 8. Use in Your Agent

Your agent can now use AAP MCP tools! Try asking:

- "List my recent Ansible jobs"
- "Show me all hosts in my inventory"
- "What job templates do I have configured?"
- "Check the status of job 1846"
- "How many hosts are in the AWS inventory?"

## Troubleshooting

### SSL/TLS Certificate Errors

**Error**: `"The underlying connection was closed: Could not establish trust relationship for the SSL/TLS secure channel"`

**Solutions**:
1. Verify your AAP server has a **valid SSL certificate** (Let's Encrypt or commercial CA)
2. Self-signed certificates will **not work** with Microsoft Copilot Studio
3. Check that your certificate is not expired
4. Verify the hostname matches the certificate's Common Name (CN)

**Test your certificate**:
```bash
curl -vI https://your-aap-server:8449/job_management/mcp
```

Look for: `SSL certificate verify ok.`

### Port Configuration

- **Port 8449**: If you have a valid Let's Encrypt certificate on this port, use it
- **Port 8448**: If you set up a proxy, ensure it has a valid certificate
- Microsoft Copilot Studio connects from Azure IPs - ensure your firewall allows them

### Authentication Issues

If you get 401 Unauthorized:
1. Verify your token is still valid
2. Ensure you included `Bearer ` (with space) before your token
3. Check token permissions in AAP
4. Test with curl:
   ```bash
   curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://your-server:8449/job_management/mcp
   ```

### Connection Timeouts

If operations timeout:
1. Verify your AAP server is publicly accessible from Azure
2. Check firewall rules
3. Test connectivity from an external service

## Differences from Cursor Configuration

| Feature | Cursor | Microsoft Copilot Studio |
|---------|--------|--------------------------|
| Configuration | JSON file with env vars | OpenAPI YAML + Power Apps |
| SSL Certificates | Can bypass with env var | Must have valid certificate |
| Authentication | Direct Bearer token | Via Custom Connector |
| Setup Method | Copy/paste config | Multi-step wizard |
| Environment Variables | Supported | Not supported |

## Advanced: Adding More Endpoints

To add more MCP endpoints (user management, security & compliance, etc.), update the `aap-mcp-openapi.yaml` file:

```yaml
paths:
  /user_management/mcp:
    post:
      summary: Ansible Automation Platform User Management Server
      x-ms-agentic-protocol: mcp-streamable-1.0
      operationId: InvokeMCPUserManagement
      responses:
        '200':
          description: Success
```

Then re-import the YAML file to update your custom connector.

## Security Notes

- **Never commit your API token** to version control
- Store tokens securely (use Azure Key Vault for production)
- Rotate tokens regularly
- Use proper SSL certificates in production
- Review AAP token permissions and use least-privilege principle

## Additional Resources

### Microsoft Documentation
- [Connect to an existing MCP server](https://learn.microsoft.com/en-us/microsoft-copilot-studio/mcp-add-existing-server-to-agent)
- [Power Apps Custom Connectors](https://learn.microsoft.com/en-us/connectors/custom-connectors/)
- [OpenAPI specification](https://learn.microsoft.com/en-us/connectors/custom-connectors/define-openapi-definition)

### AAP MCP Server
- [Deploy on RHEL](https://red.ht/mcp_rhel)
- [Deploy on OpenShift](https://red.ht/mcp_openshift)
- [GitHub Repository](https://red.ht/aap-mcp)

## Support

**Open an issue** on this repository if you run into problems, have questions, or want to suggest improvements:

- [GitHub Issues](https://github.com/IPvSean/mcp-demo/issues)

**Join the Ansible Community Forum** at [forum.ansible.com](https://forum.ansible.com). The forum is the central hub for the Ansible community—it's where users, contributors, and developers come together to ask questions, share knowledge, and help each other. Whether you're troubleshooting a playbook, looking for best practices, or want to connect with other automation engineers, the forum is the best place to start.

- [Get Help](https://forum.ansible.com/c/help/6) - Post questions and get answers from the community
- [Social Spaces](https://forum.ansible.com/c/chat/4) - Connect with fellow automation enthusiasts  
- [News & Announcements](https://forum.ansible.com/c/news/5) - Stay up to date with the Ansible ecosystem

For issues with the AAP MCP server itself, file issues at the [official AAP MCP repository](https://red.ht/aap-mcp).

## License

GNU General Public License v3.0 or later.

See [LICENSE](../LICENSE) to see the full text.
