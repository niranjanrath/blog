---
title: C4 Model Deployment Diagrams vs Network Diagrams - Understanding Where Each Fits
date: 2026-09-11
author: Niranjan Rath
topics:
  - Architecture
  - C4 Model
  - Enterprise Architecture
  - Infrastructure
tags:
  - c4
  - architecture
  - network-diagram
  - deployment-diagram
  - infrastructure
summary: >-
  The C4 model is excellent for documenting software architecture, but it does
  not replace network diagrams. This article explains where network diagrams fit,
  how they complement C4 deployment diagrams, and why modern architecture
  documentation requires both perspectives.
---

## Introduction

The **C4 Model** has become one of the most widely adopted approaches for documenting software architecture because it focuses on abstraction and stakeholder communication.

The model provides four levels of architectural detail:

- Context
- Container
- Component
- Code

These diagrams answer questions such as:

- What is the system?
- Who interacts with it?
- What applications make up the solution?
- What components exist within an application?

However, teams often struggle when they need to document infrastructure and connectivity details.

A common question is:

> Where do network diagrams fit within the C4 model?

The answer is simple:

**They don't completely fit into the C4 abstractions, and that is by design.**

<br>

---

<br>

## What the C4 Model Focuses On

C4 is primarily concerned with **software architecture** and the relationships between software building blocks.

For example:

```text
Customer
    |
    v
Order Management System
    |
    +--> Order API
    +--> Order Database
    +--> SAP Integration
```

This view helps stakeholders understand:

- System boundaries
- Responsibilities
- Dependencies
- Information flow between applications

The goal is to provide clarity without exposing unnecessary implementation details.

<br>

---

<br>

## Where Network Diagrams Fit

A network diagram answers a different set of questions.

Consider the following example:

```text
Application A
     |
     | HTTPS
     |
Load Balancer
     |
     |
Web Server
     |
     | JDBC
     |
Database
```

Unlike C4 diagrams, stakeholders reviewing a network diagram are typically interested in:

- Which subnet hosts the application?
- Which firewall zones are involved?
- Which ports are open?
- Which load balancer is being used?
- Which DNS records are configured?
- Which VNET or VPC contains the resources?
- Which region or datacenter hosts the workload?

These are not software design concerns.

They are:

- Infrastructure concerns
- Networking concerns
- Security concerns
- Connectivity concerns

<br>

### Key Observation

A network diagram is concerned with:

> How things are connected.

While C4 diagrams are concerned with:

> What things exist and how they logically relate.

Both perspectives are important, but they serve different audiences.

<br>

---

<br>

## The Closest C4 View: Deployment Diagram

Within the C4 model, the closest representation of infrastructure is the **Deployment Diagram**.

A deployment diagram typically illustrates:

- Infrastructure nodes
- Containers
- Runtime environments
- Deployment locations
- High-level infrastructure relationships

Example:

```text
+----------------------+
| Azure Kubernetes     |
| Service Cluster      |
+----------------------+
           |
           v
+----------------------+
| Order API Container  |
+----------------------+
           |
           v
+----------------------+
| Azure SQL Database   |
+----------------------+
```

This helps stakeholders understand:

- Where applications run
- Which infrastructure hosts them
- How major deployment units are connected

<br>

---

<br>

## Why Deployment Diagrams Are Not Enough

Although deployment diagrams show infrastructure, they intentionally remain at a high level.

A network architect may also need details such as:

```text
Internet
    |
Azure Front Door
    |
Web Application Firewall
    |
DMZ Network
    |
Application Subnet
    |
Private Endpoint
    |
Database Subnet
```

Additional details often include:

- CIDR ranges
- Firewall rules
- Route tables
- Network Security Groups
- ExpressRoute connections
- VPN gateways
- DNS zones
- Traffic routing

Adding these details directly into a C4 deployment diagram often creates visual clutter and makes the architecture harder to understand.

<br>

---

<br>

## Recommended Approach: Use Both

Instead of forcing all infrastructure details into C4, use separate but complementary views.

```text
C4 Deployment Diagram

            +

Network Diagram
```

This separation allows each diagram to focus on a specific concern.

<br>

### C4 Deployment Diagram

Focuses on:

- Applications
- Services
- Containers
- Runtime environments
- Deployment locations

Typical audience:

- Solution Architects
- Software Architects
- Developers
- Product Owners

<br>

### Network Diagram

Focuses on:

- Subnets
- Firewall zones
- Network boundaries
- DNS
- Load balancers
- Connectivity paths
- Security controls

Typical audience:

- Network Architects
- Infrastructure Engineers
- Security Teams
- Operations Teams

<br>

---

<br>

## Architecture Documentation Strategy

A mature architecture document rarely consists of a single diagram.

Instead, multiple views are used to address different stakeholder concerns.

A practical architecture pack may include:

```text
1. C4 Context Diagram
2. C4 Container Diagram
3. C4 Component Diagram
4. C4 Deployment Diagram
5. Network Diagram
6. Security Architecture Diagram
7. Data Flow Diagram
8. End-to-End Chain Diagram
9. Sequence Diagrams
```

Each view tells a different part of the story.

<br>

---

<br>

## Example: Order Management Platform

### C4 Container View

```text
Customer Portal
Order API
Inventory Service
SAP Connector
Order Database
```

### Deployment View

```text
AKS Cluster
Azure SQL
Azure Service Bus
```

### Network View

```text
Internet
    |
Front Door
    |
WAF
    |
DMZ
    |
Application Subnet
    |
Private Link
    |
Database Subnet
```

All three views describe the same solution from different perspectives.

<br>

---

<br>

## Conclusion

The C4 model was never intended to replace every architecture diagram.

It excels at documenting **software architecture**, while network diagrams excel at documenting **infrastructure connectivity and topology**.

A useful way to think about the distinction is:

| View | Primary Question |
|--------|------------------|
| C4 Context | What is the system and who uses it? |
| C4 Container | What applications make up the system? |
| C4 Component | How is the application structured internally? |
| C4 Deployment | Where is the software deployed? |
| Network Diagram | How is the infrastructure connected? |

The most effective architecture documentation combines both approaches.

**C4 explains what exists. Network diagrams explain how it is connected. Together they provide a complete architectural picture.**
