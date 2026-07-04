---
title: "Stop Storing Secrets: Securing Azure Workloads with Managed Identity"
date: 2026-06-20
author: Your Name
topics:
  - Azure
  - Security
tags:
  - managed-identity
  - key-vault
  - rbac
summary: >-
  A connection string in an environment variable is a liability the moment
  it's created. Managed Identity removes the secret entirely.
---

The most common security finding in Azure environments isn't a missing
patch or an open port — it's a connection string sitting in an app
setting, a Key Vault reference that resolves to a static secret, or a
service principal password rotated once a year, if that. Managed Identity
exists specifically to make that class of finding disappear.

## What Managed Identity actually removes

Instead of a resource authenticating with a stored client secret, Azure
gives the resource itself an identity in Entra ID. There is no secret to
leak, rotate, or accidentally commit — the platform issues short-lived
tokens automatically.

```csharp
var credential = new DefaultAzureCredential();
var client = new SecretClient(
    new Uri("https://myvault.vault.azure.net/"), credential);

KeyVaultSecret secret = await client.GetSecretAsync("DbConnectionString");
```

`DefaultAzureCredential` tries Managed Identity first when running in
Azure, and falls back to your local Azure CLI login during development —
the same code runs unchanged in both environments.

## System-assigned vs. user-assigned

- **System-assigned**: tied to the resource's lifecycle. Simplest option,
  but if you delete the resource, the identity disappears with it — and
  you can't share it across resources.
- **User-assigned**: an identity you create and manage independently,
  then attach to one or more resources. Use this when several services
  need the same permissions, or when you need the identity to outlive a
  specific resource.

Default to system-assigned unless you have a concrete reason to share an
identity. Sharing identities across unrelated services quietly widens the
blast radius if one of them is compromised.

## Least privilege still applies

Managed Identity solves authentication, not authorization. It's easy to
stop there and grant the identity `Owner` on a resource group because it's
convenient. Don't. Scope role assignments to the specific resource and the
narrowest built-in role that covers the job:

```bash
az role assignment create \
  --assignee-object-id <managed-identity-object-id> \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Secrets User" \
  --scope /subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<vault-name>
```

`Key Vault Secrets User` can read secrets. It cannot manage access
policies, delete the vault, or read certificates. That distinction is the
whole point of RBAC — a compromised identity should only be able to do the
one thing it was ever supposed to do.

## The migration is usually smaller than it looks

If you're migrating an existing app off connection strings, you don't need
a big-bang cutover. Enable Managed Identity alongside the existing secret,
switch the code path to use it, verify in a non-production slot, then
revoke the old credential. The riskiest step — revoking the secret — is
also the last one, which means you can always roll back until you're
confident.
