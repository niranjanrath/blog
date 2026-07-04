---
title: "Clean Architecture in Practice: What Actually Survives Contact With a Real Codebase"
date: 2026-06-01
author: Your Name
topics:
  - Architecture
tags:
  - clean-architecture
  - ddd
  - maintainability
summary: >-
  Clean Architecture diagrams look great on a whiteboard. Here's what
  actually holds up once a real team, a real deadline, and a real database
  get involved.
---

Every few years the industry rediscovers the same idea: keep your business
logic away from your frameworks. Hexagonal architecture, ports and adapters,
onion architecture, Clean Architecture — different names, same core bet.
The bet almost always pays off. The diagrams almost always mislead you about
the cost.

## The one rule that matters

Strip away the concentric circles and one rule survives everything else:

> Business rules should not know that a database, a web framework, or a
> message broker exists.

Everything else — the specific layer names, the exact folder structure, the
number of arrows in the diagram — is negotiable. This rule is not, because
it is the only one that actually protects you from a framework upgrade
turning into a six-month rewrite.

## Where teams actually get hurt

In practice, three shortcuts cause almost all the pain:

1. **Entities that know how to persist themselves.** The moment a domain
   object imports an ORM annotation, your "core" logic is coupled to a
   specific database library's lifecycle.
2. **Use cases that return framework types.** Returning a `ResponseEntity`
   or an HTTP status code from application logic means every future
   delivery mechanism inherits HTTP's assumptions.
3. **No enforcement mechanism.** Everyone agrees on the boundary in the
   design review, then a deadline hits and someone imports the repository
   directly into a domain class "just this once."

The fix for the third point is the one people skip: add an architecture
test. A single unit test that fails the build when a `domain` package
imports anything from `infrastructure` is worth more than a hundred
diagrams.

```java
@ArchTest
static final ArchRule domain_should_not_depend_on_infrastructure =
    noClasses().that().resideInAPackage("..domain..")
        .should().dependOnClassesThat().resideInAPackage("..infrastructure..");
```

## A pragmatic layering that survives real teams

Instead of four named layers, most teams do better with three, described by
what they are allowed to depend on rather than what they are called:

- **Domain** — pure logic, no dependencies outside the standard library.
- **Application** — orchestrates domain objects into use cases; may depend
  on domain, never the reverse.
- **Adapters** — everything that talks to the outside world: HTTP
  controllers, database repositories, message consumers. Depends on
  application and domain, and is the only layer allowed to import a
  framework.

That's it. No abstract "interface adapters" layer, no separate
"frameworks and drivers" ring unless your team is large enough to need the
extra ceremony.

## When *not* to bother

If your service is a thin CRUD façade over a single table with no real
business rules, this structure is pure overhead. Clean Architecture earns
its cost when the domain logic is genuinely complex and genuinely likely to
outlive the current framework or database choice. Judge that honestly
before you add the layers — the architecture test is cheap, but three
extra packages per feature is not free when there's no real domain logic to
protect.
