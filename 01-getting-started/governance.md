# Governance: First-Time Setup

> Part of the [Getting Started: Tenant & Subscription First-Time Setup](README.md) guide.

One-time governance setup checklist for a new Azure tenant or subscription.
Complete these steps **before** deploying any workloads.

---

## 1. Management Group Hierarchy

> Management Groups allow you to apply policies and access controls across multiple subscriptions.

### Recommended hierarchy
```
Root Management Group (Tenant)
├── Platform
│   ├── Identity
│   ├── Management
│   └── Connectivity
└── Landing Zones
    ├── Production
    ├── Non-Production
    └── Sandbox
```

> See [`02-azure-commands/governance/management-groups.md`](../02-azure-commands/governance/management-groups.md) for commands.

---

## 2. Subscription Design

- [ ] Place subscriptions under the correct Management Group
- [ ] Apply subscription-level tags (owner, environment, cost center)
- [ ] Set a spending budget and alert thresholds

> See [`02-azure-commands/governance/subscriptions.md`](../02-azure-commands/governance/subscriptions.md) for commands.

---

## 3. Resource Group Naming Convention

Adopt a consistent naming convention before creating any resource groups.

**Recommended pattern:** `<workload>-<environment>-<region>-rg`

| Example | Meaning |
|---|---|
| `network-prod-eastus-rg` | Networking, Production, East US |
| `webapp-dev-westus-rg` | Web App, Development, West US |
| `shared-mgmt-eastus-rg` | Shared Management, East US |

> See [`02-azure-commands/governance/resource-groups.md`](../02-azure-commands/governance/resource-groups.md) for commands.

---

## 4. Tagging Strategy

Define tags at the subscription level before deploying resources.

| Tag | Example Value | Purpose |
|---|---|---|
| `owner` | `john.doe@company.com` | Accountability |
| `environment` | `prod` / `dev` / `staging` | Cost separation |
| `cost-center` | `CC-1234` | Billing allocation |
| `workload` | `webapp` | Resource grouping |
| `created-date` | `2026-07-12` | Lifecycle tracking |

> See [`02-azure-commands/governance/tags.md`](../02-azure-commands/governance/tags.md) for commands.

---

## 5. Azure Policy Baseline

Assign foundational policies before workloads are deployed.

**Recommended baseline policies:**
- [ ] Require tags on resource groups (`owner`, `environment`, `cost-center`)
- [ ] Allowed locations (restrict regions to approved list)
- [ ] Allowed VM SKUs
- [ ] Enforce HTTPS on Storage Accounts
- [ ] Enable Microsoft Defender for Cloud

> See [`02-azure-commands/governance/azure-policy.md`](../02-azure-commands/governance/azure-policy.md) for commands.

---

## 6. Budgets and Cost Alerts

- [ ] Set a subscription-level budget
- [ ] Configure alerts at 80% and 100% of budget
- [ ] Assign Cost Management Reader role to finance team

> See [`02-azure-commands/governance/budgets-alerts.md`](../02-azure-commands/governance/budgets-alerts.md) for commands.

---

## 7. RBAC Role Assignments

Assign roles at the subscription level following least-privilege principle.

| Role | Scope | Who |
|---|---|---|
| Owner | Subscription | Platform admin only |
| Contributor | Resource Group | Workload team |
| Reader | Subscription | Audit/Finance team |
| Cost Management Reader | Subscription | Finance team |

> See [`02-azure-commands/governance/rbac.md`](../02-azure-commands/governance/rbac.md) for commands.

---

## Additional Resources

- [Azure Management Groups](https://learn.microsoft.com/azure/governance/management-groups/overview)
- [Azure Policy overview](https://learn.microsoft.com/azure/governance/policy/overview)
- [Resource naming and tagging](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [Azure Cost Management](https://learn.microsoft.com/azure/cost-management-billing/cost-management-billing-overview)
- [Azure RBAC overview](https://learn.microsoft.com/azure/role-based-access-control/overview)
