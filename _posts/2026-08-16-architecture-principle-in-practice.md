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
Over time, I've realised that being a Solution Architect is not really about knowing the most technologies or drawing the most detailed architecture diagrams.

It's about **making good decisions when the problem is not always clear, the requirements are changing, and every decision has a consequence.**

The more systems I work with, the more I come back to a simple principle:

> **Understand the problem → Simplify it → Choose the right architecture → Explain the trade-offs → Guide the team → Operate it safely**

It sounds simple. In practice, it takes a lot of discipline.

Here is how I think about each step.

## 1. Understand the problem

This is where I try to slow down.

When someone comes to me with a requirement, my first instinct should not be to think about technology like Spring Boot, Kafka, Azure, microservices or databases etc.

Instead, I ask:

> **What problem are we actually trying to solve?**

I want to understand:

- Who has the problem?
- What are they trying to achieve?
- Why is it important?
- What does success look like?
- What does the system really need to do?
- What constraints are we working with?

Sometimes the requirement we receive is actually a solution disguised as a requirement.

For example:

> "We need a Kafka-based asynchronous solution."

That's not really the problem.

The real problem might be:

> "The processing takes several minutes and the user should not have to wait."

Now we can explore different solutions.

Maybe Kafka is appropriate.

Maybe a simple background job is enough.

The difference starts with **understanding the problem before accepting the proposed solution.**

### The question I keep coming back to

> **What problem are we actually solving?**

## 2. Simplify it

Once the problem is understood, I ask myself:

> **Can we make this simpler?**

This is probably one of the most important questions an architect can ask.

We naturally tend to add things:

- Another microservice
- Another database
- Kafka
- Redis
- API Gateway
- Event bus
- Kubernetes
- Service mesh

Each one might be useful.

But each one also creates another thing that somebody has to understand, maintain, monitor, secure and troubleshoot.

So I ask:

- What can we remove?
- Do we really need another service?
- Do we really need asynchronous processing?
- Do we need another database?
- Can an existing platform capability solve this?
- Can a simple application solve the problem?

Sometimes the answer really is:

**Spring Boot + PostgreSQL + REST.**

And that's perfectly fine.

Simple does not mean primitive.

Simple means **no unnecessary complexity**.

### The question I keep coming back to

> **What is the simplest solution that satisfies the real requirements?**

## 3. Choose the right architecture

Only after understanding and simplifying the problem do I start thinking about architecture.

Now I can look at the things that actually matter:

- Scalability
- Availability
- Performance
- Security
- Resilience
- Data
- Change frequency
- Integration
- Operational requirements
- Team structure

This is where architecture patterns become useful.

Maybe we need:

- Modular monolith
- Microservices
- Event-driven architecture
- CQRS
- Batch processing
- API-based integration
- Asynchronous processing

But I don't want to start with the pattern.

I want the **problem to lead me to the pattern.**

For example:

If we have a relatively simple business domain, a small team and moderate scale, a modular monolith may be a very good architecture.

If we have independently evolving domains, different scaling requirements and multiple teams, microservices may make more sense.

Neither is automatically better.

The right question is:

> **What architecture fits this problem?**

## 4. Explain the trade-offs

This is where architecture becomes a decision rather than a diagram.

Every architectural choice has a price.

Take Kafka as an example.

Kafka can give us:

- Decoupling
- Asynchronous processing
- Durable events
- Multiple consumers

But we also get:

- More infrastructure
- More operational work
- Eventual consistency
- More complicated debugging
- More failure scenarios

So instead of saying:

> "Kafka is scalable, therefore we should use Kafka."

I'd rather say:

> "Kafka gives us the decoupling and asynchronous processing we need, and we're willing to accept the additional operational complexity."

That makes the decision much more honest.

There is usually no perfect architecture.

There are only **trade-offs that we consciously accept.**

### The question I keep coming back to

> **What are we gaining, and what are we accepting in return?**

## 5. Guide the team

Architecture doesn't end when the architecture diagram is approved.

That's when the real work starts.

The development team now has to turn the architecture into working software.

As an architect, I need to help with that.

I want the team to understand:

- Why the architecture looks the way it does
- Where the boundaries are
- Who owns what
- How services communicate
- How data is handled
- What happens when things fail
- How the solution should be tested
- What decisions still need to be made

But there is another important part.

**The team should be able to challenge the architecture.**

If a developer says:

> "Why are we using Kafka here? A database-backed job would be much simpler."

that's not a challenge to authority.

That's a valuable architecture conversation.

Maybe the developer is wrong.

Maybe the architect is wrong.

The important thing is that we explore the reasoning.

### The question I keep coming back to

> **Can the team build and evolve this architecture successfully?**

## 6. Operate it safely

One thing I've learned is that an architecture can look great on a diagram and still be terrible in production.

Production doesn't care how beautiful the architecture diagram is.

Things fail.

Databases become unavailable.

APIs time out.

Messages get stuck.

Deployments go wrong.

Certificates expire.

Unexpected data arrives.

Users do things we never anticipated.

So I want to think about operations while designing the system, not after it is deployed.

I ask:

- How will we know something is wrong?
- What happens when a dependency fails?
- Can we retry safely?
- Can we recover?
- Can we roll back?
- Do we have useful logs, metrics and traces?
- Who gets alerted?
- Can we restore the data?
- What happens during a disaster?

This is where observability, resilience, security, backup, disaster recovery and safe deployment become part of architecture.

### The question I keep coming back to

> **Can we run this system safely in the real world?**

# Putting It All Together

For me, Solution Architecture can be reduced to six simple questions:

| Step | Question |
|---|---|
| **Understand** | What problem are we solving? |
| **Simplify** | Can we make it simpler? |
| **Choose** | What architecture fits? |
| **Trade-offs** | What do we gain and give up? |
| **Guide** | Can the team build it successfully? |
| **Operate** | Can we run it safely? |

And there is one question sitting underneath all of them:

> **Why?**

Why this requirement?

Why this boundary?

Why this technology?

Why this complexity?

Why can't we make it simpler?

# Architecture Is a Continuous Loop

I don't see architecture as something we do once and then forget.

We make assumptions.

We design something.

The team builds it.

We put it into production.

Then reality teaches us something.

Maybe the system doesn't scale the way we expected.

Maybe a component is unnecessarily complicated.

Maybe users don't actually need a capability we spent months building.

Maybe an operational problem reveals that we made the wrong trade-off.

That's valuable information.

So the loop continues:

> **Understand → Simplify → Choose → Explain → Guide → Operate → Learn**

Then start again.

# The Mindset

I don't think a good Solution Architect is the person who knows the most technologies.

It's the person who can look at a messy problem and help the team move towards a **simple, appropriate and sustainable solution.**

Technology is the toolbox.

Architecture is knowing **which tool to use, why to use it, and when not to use it.**

And perhaps the most useful question an architect can ask is also the simplest:

> ## **"Can we make this simpler?"**

That question alone can prevent a lot of unnecessary architecture.
