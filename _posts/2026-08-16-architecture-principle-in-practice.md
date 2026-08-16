---
title: " Architecture Thinking: The 6-Step Loop"
date: 2026-08-16
topics:
  - Architecture
tags:
  - architectural-principle
  - simplicity-in-system-thinking
  - architectural-thinking
summary: >-
  Architecture is not about choosing technologies. It is about understanding the problem, simplifying complexity, making deliberate trade-offs, enabling teams, and building systems that can operate safely.
---
As a Solution Architect, my job is not simply to design systems.

It is to **understand the problem, make complexity manageable, help teams make good decisions, and ensure the solution can operate safely in the real world.**

A simple way to think about this is:

> **Understand the problem → Simplify it → Choose the right architecture → Explain the trade-offs → Guide the team → Operate it safely**

This is the architecture thinking loop.

---

## 1. Understand the Problem

### The goal

Before thinking about technology, understand **what problem we are actually trying to solve**.

Don't start with:

> "Should we use Kafka?"

Start with:

> "What problem are we trying to solve?"

### Meaningful questions

- What problem are we solving?
- Who has this problem?
- Why does it matter?
- What does success look like?
- What must the system do?
- What constraints do we have?
- What happens if we don't solve it?

### Architect mindset

> **Don't design yet. Understand first.**

A surprising amount of unnecessary architecture disappears once the problem is clearly understood.

---

# 2. Simplify It

### The goal

Remove unnecessary complexity before introducing new complexity.

Ask:

- Can we make this simpler?
- What can we remove?
- Do we really need another service?
- Do we really need Kafka?
- Do we really need a separate database?
- Can an existing capability solve the problem?
- Can a simple Spring Boot application solve it?
- What is the simplest solution that satisfies the requirements?

For example, don't automatically turn:

```text
Customer → Submit Request → Process Request
```

into:

```text
API Gateway
    ↓
Service A
    ↓
Kafka
    ↓
Service B
    ↓
Service C
    ↓
Redis
    ↓
PostgreSQL
    ↓
MongoDB
```

if the actual problem can be solved with:

```text
Spring Boot → PostgreSQL
```

### Architect mindset

> **Prefer simple until complexity is justified.**

Complexity should have a reason.

---

# 3. Choose the Right Architecture

### The goal

Choose an architecture that fits the **actual problem and its constraints**.

There is no universally "best" architecture.

The right architecture depends on things such as:

- Business requirements
- Scale
- Availability
- Performance
- Security
- Data characteristics
- Change frequency
- Team structure
- Operational capability
- Cost

### Meaningful questions

- What are the most important requirements?
- What needs to scale?
- What needs to be highly available?
- What will change frequently?
- Where should the boundaries be?
- Should communication be synchronous or asynchronous?
- Who owns the data?
- Do we need one database or multiple?
- What architecture pattern actually helps?

Then ask the most important question:

> **Why this architecture?**

### Architect mindset

> **Architecture should follow the problem, not technology fashion.**

Don't use microservices because "modern systems use microservices."

Use them when the problem and the organisational/operational context justify them.

---

# 4. Explain the Trade-offs

### The goal

Every architectural decision has consequences.

There is rarely a perfect solution.

A good architect makes the trade-offs visible.

For every important decision, ask:

- What do we gain?
- What do we give up?
- What complexity are we introducing?
- What risks are we accepting?
- What happens if we choose the alternative?
- Can we reverse the decision later?

### Example: Kafka

**Benefit**

- Asynchronous processing
- Decoupling
- Durable event streams
- Multiple consumers

**Cost**

- Additional infrastructure
- Operational complexity
- Eventual consistency
- More difficult debugging

So the architectural conversation should not be:

> "Kafka is scalable, so let's use Kafka."

It should be:

> "Kafka gives us asynchronous and decoupled processing, but introduces operational complexity and eventual consistency. We accept that trade-off because the requirements justify it."

### Architect mindset

> **Don't hide complexity. Explain why you accept it.**

---

# 5. Guide the Team

### The goal

Architecture is not a document.

It becomes valuable only when the team can **understand it, challenge it and build it**.

### Meaningful questions

- Does the team understand the architecture?
- Are the responsibilities clear?
- Are the boundaries clear?
- Who owns the data?
- How will errors be handled?
- How will we test it?
- What decisions still need to be made?
- What assumptions should we validate?
- Can we build a small proof of concept?

And an important question for the architect:

> **Can the team challenge my architecture?**

If engineers cannot question an architectural decision, you may have created authority rather than architecture.

### Architect mindset

> **Don't just design the solution. Enable the team to build it.**

The architect should help connect:

```text
Business Intent
       ↓
Architecture
       ↓
Engineering Decisions
       ↓
Working Software
```

---

# 6. Operate It Safely

### The goal

Architecture does not end when the application is deployed.

A system that works in development but cannot be safely operated is not a finished architecture.

### Meaningful questions

- How will we know something is wrong?
- What happens when a dependency fails?
- What happens when the database is unavailable?
- How do we recover?
- Can we deploy safely?
- Can we roll back?
- Do we have logs, metrics and traces?
- Who gets alerted?
- How do we handle security incidents?
- What happens during a disaster?
- How do we restore the system?

Think about:

**Observability**

Logs → Metrics → Traces → Alerts

**Resilience**

Timeouts → Retries → Circuit breakers → Graceful degradation

**Recovery**

Backup → Restore → DR → Recovery procedures

**Deployment**

CI/CD → Automated tests → Safe deployment → Rollback

### Architect mindset

> **If you cannot operate it safely, the architecture isn't finished.**

---

# The Complete Architecture Thinking Loop

Put the six steps together:

```text
┌──────────────────────┐
│  1. Understand       │
│  What problem?       │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│  2. Simplify         │
│  Can it be simpler?  │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│  3. Choose           │
│  What fits best?     │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│  4. Trade-offs       │
│  What do we gain?    │
│  What do we give up? │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│  5. Guide            │
│  Can we build it?    │
└──────────┬───────────┘
           ↓
┌──────────────────────┐
│  6. Operate          │
│  Can we run it safely│
└──────────┬───────────┘
           │
           └──────────────→ Learn & Improve
```

And then the loop starts again.

---

# The "Why?" Test

Behind all six steps is one simple question:

> ## **Why?**

Why this requirement?

Why this boundary?

Why this technology?

Why this complexity?

Why this architecture?

Why this trade-off?

Why can't we make it simpler?

The ability to repeatedly ask **"why?"** is one of the most valuable skills an architect can develop.

---

# A Simple Architecture Checklist

Before approving or recommending a solution, ask yourself:

### Problem

- [ ] Do I understand the real problem?
- [ ] Do I understand the desired business outcome?

### Simplicity

- [ ] Is this the simplest solution that works?
- [ ] Have we removed unnecessary components?

### Architecture

- [ ] Does the architecture fit the requirements?
- [ ] Are the boundaries clear?
- [ ] Are the important quality attributes addressed?

### Trade-offs

- [ ] Do we understand what we gain?
- [ ] Do we understand what we give up?
- [ ] Are the important decisions documented?

### Team

- [ ] Can the team understand and implement it?
- [ ] Have engineers had the opportunity to challenge it?

### Operations

- [ ] Can we monitor it?
- [ ] Can we recover it?
- [ ] Can we deploy and roll it back safely?
- [ ] Have security and failure scenarios been considered?

---

# The Mindset

The role of a Solution Architect is not to create the most sophisticated architecture.

It is to create the **right level of architecture for the problem**.

A good architect knows many technologies.

A great architect knows **when not to use them**.

So when entering an architecture discussion, don't start by asking:

> **"What architecture should I design?"**

Start with:

> **"What problem are we actually trying to solve?"**

Then follow the loop:

> **Understand → Simplify → Choose → Explain → Guide → Operate → Learn**

That is architecture thinking.
