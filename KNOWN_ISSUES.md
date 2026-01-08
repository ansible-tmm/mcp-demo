# Known Issues and Status

## Current Status: ✅ Working (with workarounds)

As of January 8, 2026, AAP MCP servers work with Cursor using the configuration in this repo.

## Issue 1: Self-Signed Certificate Errors ✅ SOLVED

**Problem**: `net::ERR_CERT_AUTHORITY_INVALID` errors when connecting to AAP servers with self-signed certificates.

**✅ Solution**: Set environment variable before launching Cursor:

```bash
export NODE_TLS_REJECT_UNAUTHORIZED=0
open -a Cursor
```

See [README](README.md#2-set-environment-variables) for permanent setup instructions.

**Status**: ✅ Working

## Issue 2: Tool Name Length Warnings ⚠️ WORKAROUND AVAILABLE

**Problem**: Some tool names are very long. When combined with long server names like `aap-mcp-job-management` (23 chars), they exceed Cursor's 60-character limit.

**⚠️ Solution**: Use shorter server names in your `mcp.json`:
- `aap-job` instead of `aap-mcp-job-management`
- `aap-inv` instead of `aap-mcp-inventory-management`
- etc.

See [TOOL_NAME_LIMITS.md](TOOL_NAME_LIMITS.md) for detailed analysis and recommendations.

**Status**: ⚠️ Workaround available (use short names)

## Issue 3: Transport Protocol ✅ SOLVED

**Problem**: Initial testing with plain `http` transport showed session-based protocol issues.

**✅ Solution**: Use `streamable-http` transport type instead of plain `http`:

```json
{
  "mcpServers": {
    "aap-job": {
      "type": "streamable-http",  // ← Use this instead of "http"
      "url": "https://your-aap-server.com:8448/job_management/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    }
  }
}
```

**What is streamable-http?**
- Enhanced HTTP transport that handles streaming responses
- Better suited for MCP servers that use Server-Sent Events (SSE) style communication
- Falls back to SSE transport if needed
- Works better with AAP's session-based MCP implementation

**Status**: ✅ Working with `streamable-http`

## What's Working

✅ AAP server is accessible
✅ API token authentication works
✅ All 6 MCP server endpoints connect successfully
✅ SSL certificate bypass works with environment variable
✅ `streamable-http` transport handles AAP's MCP protocol
✅ Tools are accessible from Cursor AI chat

## Recommendations

### For Best Results:

1. **Use `streamable-http` transport** (not plain `http`)
2. **Use short server names** (7 chars or less) to avoid tool name length issues
3. **Set `NODE_TLS_REJECT_UNAUTHORIZED=0`** for self-signed certificates
4. **Launch Cursor from terminal** to ensure environment variables are loaded

### Example Working Configuration:

```json
{
  "mcpServers": {
    "aap-job": {
      "type": "streamable-http",
      "url": "https://172.16.14.100:8448/job_management/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    }
  }
}
```

## Test Commands

Verify your server setup:

```bash
# Test server accessibility
curl -k -I https://your-aap-server.com:8448/

# Test MCP endpoint (may show session error, but endpoint is working)
curl -k -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"initialize","params":{},"id":1}' \
  https://your-aap-server.com:8448/job_management/mcp
```

Note: You may see a session ID error from curl, but that's expected. Cursor's `streamable-http` transport handles this correctly.

## Contributing

If you discover additional optimizations or issues, please contribute! This is an emerging integration.

## Last Updated

January 8, 2026
