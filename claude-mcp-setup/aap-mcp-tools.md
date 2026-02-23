# Ansible Automation Platform (AAP) MCP Tools

## Critical Rule: Use AAP MCP Tools for All AAP Interactions

**NEVER** use `curl`, `wget`, `httpie`, `ansible.builtin.uri`, or any direct HTTP/API calls to interact with AAP when AAP MCP servers are configured in `.claude.json`. Always use the MCP tools provided by the AAP MCP servers instead.

Use `ToolSearch` to load the appropriate MCP tool before calling it. Tools are deferred and must be loaded first.

### Anti-Patterns (DO NOT DO)

```bash
# WRONG - Do not use curl to query AAP
curl -k https://aap-host/api/controller/v2/job_templates/ -u admin:password

# WRONG - Do not use ansible.builtin.uri for AAP API queries in playbooks being tested/debugged
ansible.builtin.uri:
  url: "https://aap-host/api/controller/v2/jobs/"

# WRONG - Do not use wget, httpie, or python requests
wget --no-check-certificate https://aap-host/api/v2/inventories/
http --verify=no https://aap-host/api/v2/hosts/

# WRONG - Do not use WebFetch against AAP endpoints
WebFetch(url="https://aap-host/api/controller/v2/...")
```

### Correct Pattern

```
# CORRECT - Load the tool first, then call it
ToolSearch("select:mcp__aap-job-mgmt__job_templates_list")
mcp__aap-job-mgmt__job_templates_list()

# CORRECT - Use keyword search when unsure of exact tool name
ToolSearch("+inventory hosts")
# Then call the returned tool
```

---

## Important: Parameter Type Gotchas

The `id` parameter type varies by MCP server. Getting this wrong causes errors.

| Server | `id` type | Example |
|--------|-----------|---------|
| `aap-job-mgmt` | **string** (numeric) | `id: "42"` |
| `aap-inventory` | **string** (numeric) | `id: "7"` |
| `aap-security` | **string** (numeric) | `id: "3"` |
| `aap-config` | **string** (numeric) | `id: "5"` |
| `aap-monitoring` (instances, instance_groups, activity_stream) | **string** (numeric) | `id: "1"` |
| `aap-monitoring` (activitystream) | **number** | `id: 1` |
| `aap-user-mgmt` | **number** | `id: 1` |

When in doubt, check the tool's parameter schema after loading it with `ToolSearch`.

---

## AAP MCP Server Reference

### 1. Job Management (`aap-job-mgmt`) - 25 tools

Manage job templates, jobs, workflow jobs, projects, EDA activations, and metrics.

| Tool | Purpose |
|------|---------|
| `mcp__aap-job-mgmt__job_templates_list` | List all job templates |
| `mcp__aap-job-mgmt__job_templates_retrieve` | Get details of a specific job template by ID |
| `mcp__aap-job-mgmt__job_templates_launch_create` | Launch a job template |
| `mcp__aap-job-mgmt__job_templates_launch_retrieve` | Check launch requirements for a job template |
| `mcp__aap-job-mgmt__jobs_list` | List all jobs (running, completed, failed) |
| `mcp__aap-job-mgmt__jobs_retrieve` | Get details of a specific job by ID |
| `mcp__aap-job-mgmt__jobs_stdout_retrieve` | Get stdout output of a job |
| `mcp__aap-job-mgmt__jobs_cancel_create` | Cancel a running job |
| `mcp__aap-job-mgmt__jobs_relaunch_create` | Relaunch a completed/failed job |
| `mcp__aap-job-mgmt__jobs_relaunch_retrieve` | Check relaunch requirements for a job |
| `mcp__aap-job-mgmt__jobs_job_events_list` | List individual task events from a job |
| `mcp__aap-job-mgmt__jobs_job_host_summaries_list` | List per-host ok/changed/failed counts |
| `mcp__aap-job-mgmt__workflow_job_templates_list` | List all workflow job templates |
| `mcp__aap-job-mgmt__workflow_job_templates_retrieve` | Get details of a workflow job template |
| `mcp__aap-job-mgmt__workflow_job_templates_launch_create` | Launch a workflow job template |
| `mcp__aap-job-mgmt__workflow_jobs_list` | List all workflow jobs |
| `mcp__aap-job-mgmt__workflow_jobs_retrieve` | Get details of a specific workflow job |
| `mcp__aap-job-mgmt__workflow_jobs_workflow_nodes_list` | List nodes/steps within a workflow job |
| `mcp__aap-job-mgmt__workflow_jobs_cancel_create` | Cancel a running workflow job |
| `mcp__aap-job-mgmt__workflow_jobs_relaunch_create` | Relaunch a workflow job |
| `mcp__aap-job-mgmt__projects_list` | List all projects |
| `mcp__aap-job-mgmt__activation_instances_list` | List EDA activation instances |
| `mcp__aap-job-mgmt__activation_instances_logs_list` | Get logs for an EDA activation instance |
| `mcp__aap-job-mgmt__analytics_retrieve` | Retrieve analytics data |
| `mcp__aap-job-mgmt__metrics_retrieve` | Retrieve platform metrics (json or txt format) |

### 2. Inventory Management (`aap-inventory`) - 7 tools

Manage inventories, hosts, groups, and inventory sources.

| Tool | Purpose |
|------|---------|
| `mcp__aap-inventory__inventories_list` | List all inventories |
| `mcp__aap-inventory__hosts_list` | List all hosts |
| `mcp__aap-inventory__hosts_retrieve` | Get details of a specific host by ID |
| `mcp__aap-inventory__hosts_variable_data_retrieve` | Get host variables (json or yaml format) |
| `mcp__aap-inventory__groups_list` | List all groups |
| `mcp__aap-inventory__groups_create` | Create a new group in an inventory |
| `mcp__aap-inventory__inventory_sources_update_create` | Trigger an inventory source sync |

### 3. Security & Compliance (`aap-security`) - 12 tools

Manage credentials, credential types, and audit trail.

| Tool | Purpose |
|------|---------|
| `mcp__aap-security__credentials_list` | List all credentials |
| `mcp__aap-security__credentials_retrieve` | Get credential details (sensitive fields masked) |
| `mcp__aap-security__credentials_create` | Create a new credential |
| `mcp__aap-security__credentials_test_create` | Test a credential against its external system |
| `mcp__aap-security__credential_types_list` | List all credential types |
| `mcp__aap-security__credential_types_retrieve` | Get details of a credential type |
| `mcp__aap-security__credential_types_create` | Create a custom credential type |
| `mcp__aap-security__credential_types_update` | Update a credential type |
| `mcp__aap-security__credential_types_destroy` | Delete a credential type |
| `mcp__aap-security__jobs_list` | List jobs (security-scoped view) |
| `mcp__aap-security__activitystream_list` | List gateway activity stream events |
| `mcp__aap-security__activity_stream_list` | List controller activity stream events |

### 4. User Management (`aap-user-mgmt`) - 32 tools

Manage users, teams, organizations, RBAC roles, and authentication.

| Tool | Purpose |
|------|---------|
| `mcp__aap-user-mgmt__me_list` | Get current authenticated user info |
| `mcp__aap-user-mgmt__users_list` | List all users |
| `mcp__aap-user-mgmt__users_retrieve` | Get details of a specific user |
| `mcp__aap-user-mgmt__users_create` | Create a new user |
| `mcp__aap-user-mgmt__users_update` | Update a user |
| `mcp__aap-user-mgmt__users_destroy` | Delete a user |
| `mcp__aap-user-mgmt__users_teams_list` | List teams a user belongs to |
| `mcp__aap-user-mgmt__teams_list` | List all teams |
| `mcp__aap-user-mgmt__teams_retrieve` | Get details of a specific team |
| `mcp__aap-user-mgmt__teams_create` | Create a new team |
| `mcp__aap-user-mgmt__teams_update` | Update a team |
| `mcp__aap-user-mgmt__teams_destroy` | Delete a team |
| `mcp__aap-user-mgmt__teams_users_list` | List users in a team |
| `mcp__aap-user-mgmt__organizations_list` | List all organizations |
| `mcp__aap-user-mgmt__organizations_retrieve` | Get details of an organization |
| `mcp__aap-user-mgmt__organizations_create` | Create a new organization |
| `mcp__aap-user-mgmt__organizations_update` | Update an organization |
| `mcp__aap-user-mgmt__organizations_destroy` | Delete an organization |
| `mcp__aap-user-mgmt__role_definitions_list` | List available RBAC role definitions |
| `mcp__aap-user-mgmt__role_user_assignments_list` | List user role assignments |
| `mcp__aap-user-mgmt__role_user_assignments_create` | Assign a role to a user |
| `mcp__aap-user-mgmt__role_user_assignments_destroy` | Remove a role from a user |
| `mcp__aap-user-mgmt__role_team_assignments_list` | List team role assignments |
| `mcp__aap-user-mgmt__authenticators_list` | List authentication backends (LDAP, SAML, OAuth) |
| `mcp__aap-user-mgmt__authenticators_retrieve` | Get details of an authenticator |
| `mcp__aap-user-mgmt__authenticators_create` | Create an authenticator |
| `mcp__aap-user-mgmt__authenticators_update` | Update an authenticator |
| `mcp__aap-user-mgmt__authenticators_destroy` | Delete an authenticator |
| `mcp__aap-user-mgmt__authenticator_maps_list` | List authenticator trigger/mapping rules |
| `mcp__aap-user-mgmt__authenticator_maps_create` | Create an authenticator mapping rule |
| `mcp__aap-user-mgmt__activitystream_list` | List gateway activity stream events |
| `mcp__aap-user-mgmt__activity_stream_list` | List controller activity stream events |

### 5. System Monitoring (`aap-monitoring`) - 13 tools

Monitor platform health, instances, instance groups, and mesh topology.

| Tool | Purpose |
|------|---------|
| `mcp__aap-monitoring__status_retrieve` | Get overall platform status and health |
| `mcp__aap-monitoring__instances_retrieve` | Get details of a specific controller node |
| `mcp__aap-monitoring__instances_create` | Register a new controller node instance |
| `mcp__aap-monitoring__instance_groups_list` | List all instance groups |
| `mcp__aap-monitoring__instance_groups_retrieve` | Get details of an instance group |
| `mcp__aap-monitoring__instance_groups_create` | Create a new instance group |
| `mcp__aap-monitoring__mesh_visualizer_retrieve` | Get automation mesh topology visualization |
| `mcp__aap-monitoring__feature_flags_state_retrieve` | Get feature flags state |
| `mcp__aap-monitoring__authenticators_list` | List authenticators (monitoring view) |
| `mcp__aap-monitoring__activitystream_list` | List gateway activity stream events |
| `mcp__aap-monitoring__activitystream_retrieve` | Get a specific gateway activity stream event |
| `mcp__aap-monitoring__activity_stream_list` | List controller activity stream events |
| `mcp__aap-monitoring__activity_stream_retrieve` | Get a specific controller activity stream event |

### 6. Platform Configuration (`aap-config`) - 17 tools

Manage settings, execution environments, and notification templates.

| Tool | Purpose |
|------|---------|
| `mcp__aap-config__settings_list` | List all settings categories |
| `mcp__aap-config__settings_retrieve` | Get settings for a specific category by slug |
| `mcp__aap-config__settings_getter` | Get settings for a specific category by slug (alternate) |
| `mcp__aap-config__settings_update` | Full-replace settings for a category |
| `mcp__aap-config__settings_partial_update` | Partially update settings for a category |
| `mcp__aap-config__execution_environments_list` | List all execution environments |
| `mcp__aap-config__execution_environments_retrieve` | Get details of an execution environment |
| `mcp__aap-config__execution_environments_create` | Register a new execution environment image |
| `mcp__aap-config__execution_environments_update` | Update an execution environment |
| `mcp__aap-config__execution_environments_destroy` | Delete an execution environment |
| `mcp__aap-config__notification_templates_list` | List notification templates |
| `mcp__aap-config__notification_templates_retrieve` | Get details of a notification template |
| `mcp__aap-config__notification_templates_create` | Create a notification template |
| `mcp__aap-config__notification_templates_update` | Update a notification template |
| `mcp__aap-config__notification_templates_destroy` | Delete a notification template |
| `mcp__aap-config__config_create` | Apply sitewide configuration (license, analytics) |
| `mcp__aap-config__config_retrieve` | Retrieve sitewide configuration |

---

## AAP Resource Relationships and Query Strategies

### Resource Hierarchy

```
Organization
  └── Inventory
        ├── Group (e.g., os_windows, os_linux, os_rhel, os_amazon)
        │     └── Host
        └── Host (ungrouped)
```

- Inventories contain Groups and Hosts
- Groups contain Hosts
- A Host belongs to one Inventory and zero or more Groups
- Use group membership for efficient filtering -- do not manually filter all hosts

### Inventory Groups as Filters

AAP inventories use **groups** to categorize hosts. Common group naming conventions:
- OS-based: `os_windows`, `os_linux`, `os_rhel`, `os_amazon`
- Role-based: `webservers`, `databases`, `loadbalancers`
- Environment-based: `production`, `staging`, `development`

**Always check groups first** before iterating over all hosts. For example, to count Windows hosts, find the `os_windows` group rather than scanning every host's variables.

### Host Variables

Each host has a `variables` field (JSON or YAML string) containing metadata:
- `ansible_facts.os_family` -- "Windows", "RedHat", "Debian"
- `ansible_facts.distribution` -- "Ubuntu", "CentOS", "Amazon"
- `ansible_facts.system` -- "Linux", "Win32NT"
- Custom variables: `os`, `operating_system`, etc.

Use `hosts_variable_data_retrieve` to get parsed variables for a specific host. When working with multiple hosts, retrieve from `hosts_list` and parse the `variables` field.

### Common Query Strategies

**"How many Windows hosts?"**
```
# Preferred: use groups
mcp__aap-inventory__groups_list(search="os_windows")
# Group response includes host count

# Fallback: iterate hosts and parse variables
mcp__aap-inventory__hosts_list()
# Parse each host's variables field for OS info
```

**"List all hosts by OS"**
```
# List all groups to find OS-based groups
mcp__aap-inventory__groups_list(search="os_")
# Then query hosts per group as needed
```

**"What OS is host X running?"**
```
mcp__aap-inventory__hosts_variable_data_retrieve(id="<host_id>", format="json")
# Look for ansible_facts.os_family or custom OS variables
```

---

## Key Operation Parameter Reference

### Launching a Job Template

```
mcp__aap-job-mgmt__job_templates_launch_create(
  id: "42",                          # REQUIRED - string
  requestBody: {
    extra_vars: { key: "value" },    # optional - override variables
    inventory: 3,                    # optional - override inventory
    limit: "webservers",             # optional - host pattern limit
    credentials: [1, 5],             # optional - override credentials
    job_tags: "install,configure",   # optional - run only these tags
    skip_tags: "cleanup",            # optional - skip these tags
    verbosity: 2,                    # optional - 0=Normal, 1=Verbose, 2=More, 3=Debug, 4=Connection, 5=WinRM
    job_type: "run",                 # optional - "run" or "check" (dry-run)
    diff_mode: false,                # optional - show file diffs
    scm_branch: "feature-branch",   # optional - override SCM branch
    forks: 10,                       # optional - parallelism
    timeout: 3600                    # optional - max runtime seconds
  }
)
```

### Launching a Workflow Job Template

```
mcp__aap-job-mgmt__workflow_job_templates_launch_create(
  id: "15",                          # REQUIRED - string
  requestBody: {
    extra_vars: "key: value",        # optional - YAML string
    inventory: 3,                    # optional - override inventory
    limit: "webservers",             # optional - host pattern limit
    job_tags: "deploy",              # optional
    skip_tags: "test",               # optional
    scm_branch: "main",             # optional
    labels: [1, 2]                   # optional - label IDs
  }
)
```

### Creating a Credential

```
mcp__aap-security__credentials_create(
  requestBody: {
    name: "My SSH Key",              # REQUIRED
    credential_type: 1,              # REQUIRED - get types from credential_types_list
    organization: 2,                 # optional
    inputs: {                        # type-specific; inspect credential_type for schema
      username: "admin",
      ssh_key_data: "-----BEGIN..."
    }
  }
)
```

### Creating a Group in an Inventory

```
mcp__aap-inventory__groups_create(
  requestBody: {
    inventory: 2,                    # REQUIRED - inventory ID
    name: "webservers",              # REQUIRED
    description: "Web tier hosts",   # optional
    variables: "---\nhttp_port: 80"  # optional - YAML or JSON string
  }
)
```

### Creating a User

```
mcp__aap-user-mgmt__users_create(
  requestBody: {
    username: "jdoe",                # REQUIRED - max 150 chars
    password: "securepass123",       # optional
    email: "jdoe@example.com",      # optional
    first_name: "Jane",             # optional
    last_name: "Doe",               # optional
    is_superuser: false,            # optional
    is_platform_auditor: false      # optional
  }
)
```

### Assigning a Role to a User

```
mcp__aap-user-mgmt__role_user_assignments_create(
  requestBody: {
    role_definition: 5,              # REQUIRED - from role_definitions_list
    user: 3,                         # user ID (or use user_ansible_id)
    object_id: 7                     # resource ID (or use object_ansible_id)
  }
)
```

### Registering an Execution Environment

```
mcp__aap-config__execution_environments_create(
  requestBody: {
    name: "Custom EE",                                          # REQUIRED
    image: "registry.example.com/my-ee:latest",                 # REQUIRED - full image path
    credential: 4,                                              # optional - registry credential ID
    organization: 2,                                            # optional
    pull: "missing",                                            # optional - "always", "missing", "never"
    description: "Custom EE with extra collections"             # optional
  }
)
```

### Creating a Notification Template

```
mcp__aap-config__notification_templates_create(
  requestBody: {
    name: "Slack Alerts",                                       # REQUIRED
    notification_type: "slack",                                 # REQUIRED - slack|email|webhook|pagerduty|etc.
    organization: 2,                                            # REQUIRED
    notification_configuration: {                               # type-specific config
      token: "xoxb-...",
      channels: ["#alerts"]
    }
  }
)
```

### Registering a Controller Instance

```
mcp__aap-monitoring__instances_create(
  requestBody: {
    hostname: "controller-2.example.com",                       # REQUIRED
    node_type: "execution",                                     # optional - control|execution|hybrid|hop
    node_state: "installed",                                    # optional - installed|ready|unavailable|...
    enabled: true,                                              # optional
    listener_port: 27199,                                       # optional
    peers_from_control_nodes: true                              # optional
  }
)
```

---

## Multi-Step Workflow Patterns

### Launch a job and monitor it to completion

```
# Step 1: Find the job template
mcp__aap-job-mgmt__job_templates_list(search="LINUX | Patching")

# Step 2: Check what the template needs before launch
mcp__aap-job-mgmt__job_templates_launch_retrieve(id="29")

# Step 3: Launch the job
result = mcp__aap-job-mgmt__job_templates_launch_create(id="29")
# Note the returned job ID

# Step 4: Poll job status until complete
mcp__aap-job-mgmt__jobs_retrieve(id="<job_id>")
# Check the "status" field: pending, waiting, running, successful, failed, error, canceled

# Step 5: Get the output
mcp__aap-job-mgmt__jobs_stdout_retrieve(id="<job_id>", format="txt")

# Step 6 (optional): Check per-host results
mcp__aap-job-mgmt__jobs_job_host_summaries_list(id="<job_id>")
```

### Investigate a failed job

```
# Step 1: List recent failed jobs
mcp__aap-job-mgmt__jobs_list(search="failed")

# Step 2: Get job details
mcp__aap-job-mgmt__jobs_retrieve(id="<job_id>")

# Step 3: Get stdout for error messages
mcp__aap-job-mgmt__jobs_stdout_retrieve(id="<job_id>")

# Step 4: Get granular task-level events
mcp__aap-job-mgmt__jobs_job_events_list(id="<job_id>")

# Step 5: Check which hosts failed
mcp__aap-job-mgmt__jobs_job_host_summaries_list(id="<job_id>")
```

### Audit user activity

```
# Step 1: List users
mcp__aap-user-mgmt__users_list()

# Step 2: Check a user's team memberships
mcp__aap-user-mgmt__users_teams_list(id="3")

# Step 3: Check their role assignments
mcp__aap-user-mgmt__role_user_assignments_list()

# Step 4: Review recent activity
mcp__aap-security__activitystream_list()
```

### Check platform health

```
# Step 1: Overall status
mcp__aap-monitoring__status_retrieve()

# Step 2: Instance groups and capacity
mcp__aap-monitoring__instance_groups_list()

# Step 3: Mesh topology
mcp__aap-monitoring__mesh_visualizer_retrieve()

# Step 4: Detailed metrics
mcp__aap-job-mgmt__metrics_retrieve(format="json")
```

### Inventory exploration

```
# Step 1: List inventories
mcp__aap-inventory__inventories_list()

# Step 2: List hosts in the inventory
mcp__aap-inventory__hosts_list()

# Step 3: Get host details and variables
mcp__aap-inventory__hosts_retrieve(id="5")
mcp__aap-inventory__hosts_variable_data_retrieve(id="5", format="yaml")

# Step 4: List groups
mcp__aap-inventory__groups_list()
```

---

## ToolSearch Tips

Use these keyword patterns to find the right tool quickly:

| What you need | ToolSearch query |
|---------------|-----------------|
| Any job template tool | `"+job-mgmt job_templates"` |
| Launch a job | `"+job-mgmt launch"` |
| Anything about hosts | `"+inventory hosts"` |
| Credential operations | `"+security credentials"` |
| User management | `"+user-mgmt users"` |
| Platform health | `"+monitoring status"` |
| Settings/config | `"+config settings"` |
| Specific tool by name | `"select:mcp__aap-job-mgmt__jobs_list"` |

---

## Pagination

Most `_list` tools support:
- `page` (number): Page number (1-indexed)
- `page_size` (number): Results per page (default typically 25)
- `search` (string): Free-text search term

Response structure:
- `count`: Total number of matching resources
- `next`: URL path for next page (null if last page)
- `previous`: URL path for previous page (null if first page)
- `results`: Array of resource objects

When `count` exceeds the page size, iterate through pages to get all results.

Some `_list` tools in `aap-user-mgmt` and `aap-monitoring` also support:
- `order` / `order_by`: Field name for sorting (prefix `-` for descending)
- `type`: Filter by object type
- Extensive field-level filters with `__gt`, `__gte`, `__lt`, `__lte`, `__icontains` suffixes

---

## MCP Server Summary

| Server | Tool Prefix | Tool Count | Scope |
|--------|-------------|------------|-------|
| Job Management | `aap-job-mgmt` | 25 | Job templates, jobs, workflows, projects, EDA, metrics |
| Inventory | `aap-inventory` | 7 | Inventories, hosts, groups, inventory sources |
| Security | `aap-security` | 12 | Credentials, credential types, audit trail |
| User Management | `aap-user-mgmt` | 32 | Users, teams, orgs, RBAC, authenticators |
| Monitoring | `aap-monitoring` | 13 | Status, instances, instance groups, mesh, feature flags |
| Configuration | `aap-config` | 17 | Settings, execution environments, notifications |
| **Total** | | **106** | |
