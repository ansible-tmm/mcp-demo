# MCP Tool Name Length Analysis - All AAP MCP Servers

## The Problem

Cursor's MCP implementation has a **60-character limit** for the combined:
**Server Name** + **Tool Name**

**Important**: The "Server Name" is the key in your `mcp.json` config, NOT the server URL.

---

## 1. Job Management (`aap-mcp-job-management`)

**Server name length**: 23 characters
**Characters left for tool names**: 37 characters

### Tools List

```
controller_analytics_retrieve                           (29 chars) ✅
controller_jobs_cancel_create                           (29 chars) ✅
controller_jobs_job_events_list                         (31 chars) ✅
controller_jobs_job_host_summaries_list                 (39 chars) ❌ TOO LONG (62 total)
controller_jobs_list                                    (20 chars) ✅
controller_jobs_relaunch_create                         (31 chars) ✅
controller_jobs_relaunch_retrieve                       (33 chars) ✅
controller_jobs_retrieve                                (24 chars) ✅
controller_jobs_stdout_retrieve                         (31 chars) ✅
controller_job_templates_launch_create                  (38 chars) ❌ TOO LONG (61 total)
controller_job_templates_list                           (29 chars) ✅
controller_job_templates_retrieve                       (33 chars) ✅
controller_metrics_retrieve                             (27 chars) ✅
controller_projects_list                                (24 chars) ✅
controller_workflow_jobs_list                           (29 chars) ✅
controller_workflow_jobs_retrieve                       (33 chars) ✅
controller_workflow_jobs_workflow_nodes_list            (44 chars) ❌ TOO LONG (67 total)
controller_workflow_job_templates_launch_create         (47 chars) ❌ TOO LONG (70 total)
controller_workflow_job_templates_list                  (38 chars) ❌ TOO LONG (61 total)
```

**Failed tools**: 5 out of 19

---

## 2. Inventory Management (`aap-mcp-inventory-management`)

**Server name length**: 29 characters
**Characters left for tool names**: 31 characters

### Tools List

```
controller_groups_create                                (24 chars) ✅
controller_groups_list                                  (22 chars) ✅
controller_hosts_list                                   (21 chars) ✅
controller_hosts_retrieve                               (25 chars) ✅
controller_inventories_list                             (27 chars) ✅
```

**Failed tools**: 0 out of 5

---

## 3. System Monitoring (`aap-mcp-system-monitoring`)

**Server name length**: 25 characters
**Characters left for tool names**: 35 characters

### Tools List

```
controller_instances_create                             (27 chars) ✅
controller_instances_retrieve                           (31 chars) ✅
gateway_activitystream_list                             (27 chars) ✅
gateway_authenticators_list                             (27 chars) ✅
gateway_status_retrieve                                 (23 chars) ✅
```

**Failed tools**: 0 out of 5

---

## 4. User Management (`aap-mcp-user-management`)

**Server name length**: 23 characters
**Characters left for tool names**: 37 characters

### Tools List

```
controller_activity_stream_list                         (31 chars) ✅
gateway_activitystream_list                             (27 chars) ✅
gateway_authenticators_create                           (29 chars) ✅
gateway_authenticators_destroy                          (30 chars) ✅
gateway_authenticators_list                             (27 chars) ✅
gateway_authenticators_retrieve                         (31 chars) ✅
gateway_authenticators_update                           (29 chars) ✅
gateway_authenticator_maps_list                         (31 chars) ✅
gateway_me_list                                         (15 chars) ✅
gateway_organizations_create                            (28 chars) ✅
gateway_organizations_destroy                           (29 chars) ✅
gateway_organizations_list                              (26 chars) ✅
gateway_organizations_retrieve                          (30 chars) ✅
gateway_organizations_update                            (28 chars) ✅
gateway_role_definitions_list                           (29 chars) ✅
gateway_teams_create                                    (20 chars) ✅
gateway_teams_destroy                                   (21 chars) ✅
gateway_teams_list                                      (18 chars) ✅
gateway_teams_retrieve                                  (22 chars) ✅
gateway_teams_update                                    (20 chars) ✅
gateway_teams_users_list                                (24 chars) ✅
gateway_users_create                                    (20 chars) ✅
gateway_users_destroy                                   (21 chars) ✅
gateway_users_list                                      (18 chars) ✅
gateway_users_retrieve                                  (22 chars) ✅
gateway_users_teams_list                                (24 chars) ✅
gateway_users_update                                    (20 chars) ✅
```

**Failed tools**: 0 out of 27

---

## 5. Security & Compliance (`aap-mcp-security-compliance`)

**Server name length**: 29 characters
**Characters left for tool names**: 31 characters

### Tools List

```
controller_credentials_list                             (27 chars) ✅
controller_jobs_list                                    (20 chars) ✅
gateway_activitystream_list                             (27 chars) ✅
```

**Failed tools**: 0 out of 3

---

## 6. Platform Configuration (`aap-mcp-platform-configuration`)

**Server name length**: 32 characters
**Characters left for tool names**: 28 characters

### Tools List

```
controller_config_create                                (24 chars) ✅
controller_settings_list                                (24 chars) ✅
gateway_settings_getter                                 (23 chars) ✅
gateway_settings_list                                   (21 chars) ✅
gateway_settings_update                                 (23 chars) ✅
```

**Failed tools**: 0 out of 5

---

## Summary by Server

| Server Name | Name Length | Failed Tools | Total Tools | Success Rate |
|-------------|-------------|--------------|-------------|--------------|
| `aap-mcp-job-management` | 23 | **5** | 19 | 74% |
| `aap-mcp-inventory-management` | 29 | 0 | 5 | 100% |
| `aap-mcp-system-monitoring` | 25 | 0 | 5 | 100% |
| `aap-mcp-user-management` | 23 | 0 | 27 | 100% |
| `aap-mcp-security-compliance` | 29 | 0 | 3 | 100% |
| `aap-mcp-platform-configuration` | 32 | 0 | 5 | 100% |
| **TOTAL** | - | **5** | **64** | **92%** |

---

## Failed Tools (All from Job Management)

These 5 tools exceed the 60-character limit:

1. `aap-mcp-job-management:controller_jobs_job_host_summaries_list` (62 chars)
2. `aap-mcp-job-management:controller_job_templates_launch_create` (61 chars)
3. `aap-mcp-job-management:controller_workflow_jobs_workflow_nodes_list` (67 chars)
4. `aap-mcp-job-management:controller_workflow_job_templates_launch_create` (70 chars)
5. `aap-mcp-job-management:controller_workflow_job_templates_list` (61 chars)

---

## Solution: Shorten Server Names

### Recommended Configuration

Change server names to be much shorter. Here's the optimal setup:

```json
{
  "mcpServers": {
    "aap-job": {
      "type": "streamable-http",
      "url": "https://172.16.14.100:8448/job_management/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    },
    "aap-inv": {
      "type": "streamable-http",
      "url": "https://172.16.14.100:8448/inventory_management/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    },
    "aap-mon": {
      "type": "streamable-http",
      "url": "https://172.16.14.100:8448/system_monitoring/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    },
    "aap-user": {
      "type": "streamable-http",
      "url": "https://172.16.14.100:8448/user_management/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    },
    "aap-sec": {
      "type": "streamable-http",
      "url": "https://172.16.14.100:8448/security_compliance/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    },
    "aap-cfg": {
      "type": "streamable-http",
      "url": "https://172.16.14.100:8448/platform_configuration/mcp",
      "headers": {
        "Authorization": "Bearer ${env:MY_SERVICE_TOKEN}"
      }
    }
  }
}
```

### Name Length Comparison

| Current Name | Length | New Name | Length | Saved |
|--------------|--------|----------|--------|-------|
| `aap-mcp-job-management` | 23 | `aap-job` | 7 | 16 chars |
| `aap-mcp-inventory-management` | 29 | `aap-inv` | 7 | 22 chars |
| `aap-mcp-system-monitoring` | 25 | `aap-mon` | 7 | 18 chars |
| `aap-mcp-user-management` | 23 | `aap-user` | 8 | 15 chars |
| `aap-mcp-security-compliance` | 29 | `aap-sec` | 7 | 22 chars |
| `aap-mcp-platform-configuration` | 32 | `aap-cfg` | 7 | 25 chars |

With these shorter names, **all 64 tools will work** without any naming conflicts! ✅
