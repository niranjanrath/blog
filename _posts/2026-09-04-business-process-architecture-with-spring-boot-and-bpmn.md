---
title: "Building Large Process-Driven Applications with Spring Boot and BPMN: A Scalable 4-Layer Architecture"
date: 2026-09-04

topics:
  - Architecture

tags:
  - spring-boot
  - bpmn
  - workflow
  - process-architecture
  - ddd
  - orchestration

summary: >-
  A practical approach to designing process-driven applications with
  Spring Boot, BPMN, and PostgreSQL. Learn how to separate user
  interactions, process orchestration, business capabilities, and
  persistence into clear architectural layers that remain maintainable
  as both business requirements and workflows evolve.
---

Many teams start a BPM project by putting the workflow engine at the center of the architecture. Before long, every business rule, every integration, and every database operation becomes entangled with the process engine.

The result is usually an application that works, but becomes increasingly difficult to change. A simple business rule update turns into a BPMN change. A database migration impacts process logic. Adding a new channel means understanding workflow internals.

A better approach is to treat the workflow engine as just one architectural component rather than the foundation of the system.

The architecture described here is based on a simple idea:

> User interactions, process orchestration, business capabilities, and business data are separate concerns and should be treated as such.

This becomes especially important in process-driven applications where business processes evolve frequently while core business capabilities often remain stable for years.

## The Business Requirement

Consider a bank offering a digital loan application service.

Customers should be able to submit loan applications online and receive a decision as quickly as possible. Some applications can be approved automatically. Others require review by a loan officer.

From a business perspective, the requirements are straightforward:

- Customers submit loan applications.
- Applications are validated.
- Creditworthiness is assessed.
- Business policies determine eligibility.
- Certain applications require manual approval.
- Customers receive a final decision.
- The process remains auditable and traceable.

The business is interested in outcomes, not implementation details.

Nobody in a business workshop asks whether a BPMN service task calls a delegate or whether a repository uses JPA. They care about ensuring every application follows the correct path and that business decisions are consistently applied.

## Understanding the Actors

Several participants contribute to the process.

### Customer

The customer initiates the loan application process and receives the final outcome.

### Loan Officer

The loan officer reviews applications that require manual assessment and makes approval decisions when automation alone is insufficient.

### Credit Bureau

An external provider supplying credit information required during risk assessment.

### Notification Service

A supporting service responsible for communicating updates and decisions to customers.

Together, these actors participate in a business process that spans both human and automated activities.

## Core Business Concepts

Although workflows may change, the business concepts usually remain stable.

### Loan Application

Represents a customer's request for financing.

### Customer

Represents the person applying for the loan.

### Credit Assessment

Represents the evaluation of financial risk.

### Loan Decision

Represents the outcome of the application:

- Approved
- Rejected
- Requires Manual Review

These concepts belong to the business domain regardless of the workflow technology used to implement the process.

## A Four-Layer Architecture
The application can be understood through four responsibility-based layers.

| Layer | Question It Answers |
|---------|---------|
| Experience Layer | What is the user trying to do? |
| Process Layer | What should happen next? |
| Domain Layer | How is the business action performed? |
| Data Layer | Where is information stored and retrieved? |

This structure creates clear ownership boundaries and prevents process logic from becoming mixed with business logic.

## Experience Layer

### What Users Do

The Experience Layer is the entry point into the application.

Its responsibility is to receive user requests and translate them into meaningful business actions.

Typical responsibilities include:

- Exposing REST APIs
- Validating requests
- Normalizing input
- Authorizing actions
- Starting or interacting with business processes

For example, a frontend application may invoke:

```http
POST /loan-applications
```

The Experience Layer validates the request and initiates the corresponding business process.

Importantly, the frontend does not need to know that a workflow engine exists.

From its perspective, it is simply interacting with loan-related business APIs.

> The frontend speaks the language of the business, not the language of BPM.

## Process Layer

### What Happens Next

The Process Layer coordinates the journey of a loan application.

This is where BPMN models and decision models live.

Its responsibility is orchestration.

The process knows:

- Which activity comes next
- Which path should be followed
- When human interaction is required
- When deadlines are reached
- When escalation is necessary

A simplified loan application process might look like this:

1. Validate application
2. Retrieve credit information
3. Assess eligibility
4. Determine routing
5. Perform manual review if required
6. Notify customer
7. Complete process

The process layer repeatedly answers a single question:

> What should happen next?

It does not answer:

> How should risk be calculated?

That responsibility belongs elsewhere.

### BPMN Describes the Journey

One of the most common mistakes in BPM projects is turning BPMN into a container for business logic.

A process model should describe the business journey, not implement business behaviour.

A useful mental model is:

> BPMN defines the flow of work, not the details of the work.

### Service Tasks Should Remain Focused

Each service task should execute one business capability.

Good examples include:

- Validate Application
- Assess Credit Risk
- Create Loan Agreement
- Send Notification

Each task should invoke a single business operation and then return control to the process.

This keeps BPMN diagrams understandable to both technical and business stakeholders.

## Domain Layer

### How Business Work Is Performed

The Domain Layer contains the business capabilities of the organization.

This is where actual business knowledge lives.

Examples include:

- Determining eligibility
- Calculating risk scores
- Calculating borrowing limits
- Approving loans
- Creating agreements

Suppose the BPMN process reaches a task called:

> Assess Credit Risk

The process itself should not contain the risk calculation.

Instead, it calls a domain service responsible for performing that capability.

This separation ensures business rules remain reusable and independent of workflow concerns.

The same credit assessment logic could later be used by:

- A workflow
- A REST API
- A batch job
- A future mobile application

without requiring duplication.

A useful distinction is:

> The Process Layer decides when work happens. The Domain Layer decides how the work is done.

## Data Layer

### Where Truth Lives

The Data Layer owns persistence and integration responsibilities.

It acts as the system of record for business information.

Typical responsibilities include:

- Persisting loan applications
- Reading customer information
- Communicating with external systems
- Managing integrations
- Executing database operations

Examples include:

- PostgreSQL
- Repository implementations
- Credit bureau integrations
- Messaging services
- Document services

A critical distinction is that workflow state and business data are not the same thing.

The process engine may store information required to continue a workflow, but the authoritative representation of the business remains in the system of record.

In other words:

> Workflow state belongs to the process engine. Business data belongs to the business data store.

Keeping this separation prevents the workflow engine from becoming the accidental owner of your business domain.

## Bringing the Layers Together

Let's walk through a loan application from start to finish.

A customer submits a loan application.

The Experience Layer receives the request and starts a new process instance.

The Process Layer begins orchestrating the loan application workflow.

The first service task asks for application validation.

A domain service performs the validation logic.

The data layer retrieves and persists the required business information.

The workflow moves to credit assessment.

A domain service calculates risk and determines eligibility using information retrieved from the database and external credit bureau systems.

The process then evaluates the outcome.

Applications may be:

- Approved automatically
- Routed to a loan officer
- Rejected

If manual review is required, the process waits for a loan officer decision.

Once a final decision is reached, the process orchestrates customer notification and completes the workflow.

Throughout this journey, each layer focuses on its own responsibility without leaking concerns into another layer.

## A Maven Structure That Reflects the Architecture

A project structure should make architectural boundaries visible.

```text
src/main/java
└── com.bank.loan

    ├── experience
    │   ├── controller
    │   ├── dto
    │   ├── mapper
    │   └── validation
    │
    ├── process
    │   ├── delegate
    │   ├── decision
    │   ├── listener
    │   └── variable
    │
    ├── domain
    │   ├── model
    │   ├── service
    │   ├── rule
    │   └── exception
    │
    ├── infrastructure
    │   ├── repository
    │   ├── entity
    │   ├── integration
    │   ├── client
    │   └── config
    │
    └── common
```

Process definitions remain separate from implementation code:

```text
src/main/resources

├── processes
│   └── loan-application.bpmn
│
├── decisions
│   └── loan-risk-assessment.dmn
│
├── application.yml
│
└── db
    └── migration
```

## Final Thoughts

Workflow engines are excellent at managing process state, routing decisions, timing, approvals, and orchestration. They are not a replacement for domain services, repositories, or business models.

Successful process-driven applications keep these responsibilities separate.

The Experience Layer captures business intent.

The Process Layer manages the journey.

The Domain Layer performs business work.

The Data Layer owns business truth.

When these boundaries remain clear, business processes can evolve without rewriting core business capabilities, and business capabilities can evolve without constantly redesigning workflows.

That separation is what keeps a process-driven application understandable long after the first BPMN diagram has been deployed.
