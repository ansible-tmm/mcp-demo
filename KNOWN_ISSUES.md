# Known Issues and Status

## Current Status: ⚠️ Partially Working

As of January 8, 2026, there are compatibility issues between Cursor's MCP transport and the Ansible Automation Platform MCP server.

### Issue 1: Self-Signed Certificate Errors

**Problem**: `net::ERR_CERT_AUTHORITY_INVALID` errors when connecting to AAP servers with self-signed certificates.

**Solution**: Set environment variable before launching Cursor:
```bash
export NODE_TLS_REJECT_UNAUTHORIZED=0
open -a Cursor
```

See README for permanent setup instructions.

### Issue 2: Session-Based Protocol

**Problem**: The AAP MCP server responds with:
```json
{"jsonrpc":"2.0","error":{"code":-32000,"message":"Bad Request: No valid session ID provided"},"id":null}
```

This indicates the server uses a **session-based protocol** that Cursor's HTTP MCP client may not fully support yet.

### What We've Verified

✅ AAP server is accessible
✅ API token authenticates successfully
✅ `/api/mcp/` endpoint exists and responds
✅ Server accepts POST requests
✅ SSL certificate bypass works with environment variable
❌ Session ID handling may not work with Cursor's HTTP transport (still being investigated)

### Possible Solutions

1. **Use Environment Variable for SSL**: `NODE_TLS_REJECT_UNAUTHORIZED=0` (working solution)

2. **Wait for Cursor Updates**: Cursor may need to add session support to their HTTP MCP client

3. **Wait for AAP Updates**: AAP may add sessionless HTTP transport support

4. **Use Alternative Transport**: If AAP adds SSE or stdio transport for MCP, those may work better with Cursor

5. **Use Different MCP Client**: Try with Claude Desktop or other MCP-compatible clients that may have better session support

### Test Commands

Verify your server setup:

```bash
# Test server accessibility
curl -k -I https://aap-nostromo.demoredhat.com:8448/

# Test MCP endpoint
curl -k -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","params":{},"id":1}' \
  https://your-aap-server.com:8448/api/mcp/
```

### Contributing

If you find a working configuration, please contribute! This is an emerging integration and we're documenting what works (and what doesn't) as we discover it.

## Last Updated

January 8, 2026
