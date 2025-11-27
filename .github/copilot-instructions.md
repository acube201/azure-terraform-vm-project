# Copilot / AI Agent Instructions - azure-terraform-project

Purpose
- This repo is a single-file Terraform example that provisions an Azure Resource Group, Virtual Network, Subnet, NIC, Public IP, a Windows VM, and a Network Security Group (NSG).
- These instructions will guide an AI agent (Copilot) to make safe, consistent, and useful changes in the repo.

Quick facts (what you’ll see in the code)
- `main.tf` is the only meaningful source file: all resources are in a single Terraform file.
- Resources created: `azurerm_resource_group.rg`, `azurerm_virtual_network.vnet`, `azurerm_subnet.subnet`, `azurerm_network_interface.nic`, `azurerm_public_ip.vm_pip`, `azurerm_windows_virtual_machine.vm`, `azurerm_network_security_group.nsg`.
- Current provider: `azurerm` with lockfile pin to 4.x (see `.terraform.lock.hcl`).
- Local state file exists (`terraform.tfstate`) — this project currently uses local state.

Big picture / architecture (how resources relate)
- Resource Group (RG) is the parent container; location `East US` used across the board.
- VNet -> Subnet → NIC → VM (NIC attaches to the VM). Public IP is assigned to the NIC.
- NSG exists, but in the provided config it is NOT attached to the subnet or NIC; it only declares a rule to allow RDP (TCP/3389).
- References are implemented via direct interpolation of resource IDs, e.g., `public_ip_address_id = azurerm_public_ip.vm_pip.id`.

Project-specific conventions & patterns
- Resource naming convention: prefix `myTF` is used across resources (e.g., `myTFVNet`, `myTFVM`); continue this naming pattern where applicable.
- Hard-coded values appear (admin password, subscription_id, tenant_id, location, etc.). Treat these as sample-only values for development.
- No modules are used; the repo is single-file, focused on a small proof-of-concept environment.
- No outputs are defined — consider adding outputs for `public_ip` and `vm` fields where needed for downstream actions.

Security & state guidance (important to follow)
- Secrets: `admin_password` and subscription/tenant IDs are hard-coded in `main.tf` — DO NOT commit credentials in real PRs. Instead:
  - Use Terraform `variable`s and mark sensitive vars with `sensitive = true`.
  - Prefer environment variables (ARM_* for Azure CLI), or use managed identity/KV for real deployments.
- State: there is a local `terraform.tfstate` file; for teams, switch to a remote backend (Azure Storage) and state locking.

Integration points & external dependencies
- Azure provider (`azurerm`) and default feature flag are used. The provider block currently embeds `subscription_id` and `tenant_id` — replace with environment variables/service principal for automation.
- Azure CLI: developers commonly use `az login` or `az login --service-principal` followed by `terraform init`.

Developer workflows
- Standard sequence to validate and deploy locally:
  - `terraform init` (initializes provider and plugins)
  - `terraform fmt -recursive` (format styles)
  - `terraform validate` (config validation)
  - `terraform plan -out plan.tfplan`
  - `terraform apply plan.tfplan` (ask for confirmation before this step in PRs)

- If you prefer to use variables for auth & secrets:
  - `export ARM_SUBSCRIPTION_ID="<id>"` (PowerShell env equivalents in Windows: `$Env:ARM_SUBSCRIPTION_ID = "<id>"`)
  - `az login` or use `ARM_CLIENT_ID/ARM_CLIENT_SECRET/ARM_TENANT_ID` for service principal auth.

- Linting/validation and safety checks:
  - `terraform fmt` and `terraform validate` are musts for PRs.
  - Run `tflint` or `checkov` in CI for policy and security scanning (recommended but not enforced).
  - To debug: `TF_LOG=DEBUG terraform plan` or `terraform apply`.

Patterns to look for / common PR tasks
- Attaching the NSG: in `main.tf` the NSG is declared but not used. Attach it safely to the subnet or NIC using either:

```hcl
# Option A: Attach at subnet level (preferred if you want subnet-level control)
resource "azurerm_subnet" "subnet" {
  ...
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Option B: Create an explicit association resource
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
```

- When changing sensitive fields (passwords, subscription/tenant IDs, client secrets): move to Terraform variables and mark them `sensitive = true` and add guidance to `.gitignore` for any local `.tfvars` files you recommend.

- Add `tags` for resources (e.g., owner, environment) if you’re preparing work for production. Keep tags simple and consistent.

General rules for AI agents working here
- Never commit secrets to the repo. If you see `admin_password` or any secrets, escalate and replace with a variable or a placeholder.
- Maintain the `myTF` naming convention for new resources unless a PR says otherwise.
- Keep changes minimal and testable: always run `terraform plan` and provide a short reasoning for plan changes in PR description.
- Avoid destructive actions without explicit human approval (e.g., resource renames or re-creates that will cause downtime).

Examples (useful snippets to add/replace)
- Replace inline `admin_password` with a sensitive variable:

```hcl
variable "admin_password" {
  type      = string
  sensitive = true
}

resource "azurerm_windows_virtual_machine" "vm" {
  admin_username = "azurenuser"
  admin_password = var.admin_password
  ...
}
```

- Attach NSG to subnet using `network_security_group_id` (if you prefer subnet-level control): see above.

Closing / About changes
- This is a small, single-file, sample repo — keep the changes simple and explain behavior in PR descriptions.
- If you'd like more structure, propose modularization (split `main.tf` into modules), add remote state in `backend` configuration, and add outputs/tags.

Feedback
- Tell me if you want more samples (e.g., how to convert to an ARM Template, or how to add a remote backend with Azure Storage). Also tell me if there are project conventions not covered (region naming, tag usage, naming pattern changes)."}