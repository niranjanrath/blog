---
title: Building AI Systems
date: 2026-07-04
author: Your Name
topics:
  - AI
tags:
  - spring-ai
  - rag
  - llm
summary: >-
  Notes on the parts of building an AI system that don't show up in the
  model's marketing copy: evaluation, guardrails, and cost.
---

Most write-ups about building AI systems focus on the model call itself —
which provider, which prompt, which framework. In practice, the model call
is the smallest part of the system. The rest of the work looks a lot like
any other backend engineering problem, just with a probabilistic component
sitting in the middle of it.

## Three things that matter more than model choice

**Evaluation before optimization.** It's tempting to start tuning prompts
the moment output looks slightly wrong. Without a fixed set of test cases
and a way to score them, every "fix" is a guess you can't verify. Build the
eval set first, even a small one, before touching the prompt.

**Guardrails at the boundary, not in the prompt.** Asking a model nicely
not to leak certain information or produce certain output is a suggestion,
not a control. Real guardrails — input validation, output filtering,
allow-lists for actions the system can take — belong in code that runs
regardless of what the model decides to do.

**Cost is a design constraint, not an afterthought.** Token costs and
latency compound quickly once a feature is in front of real users. Caching
repeated queries, choosing smaller models for classification-style
subtasks, and only calling a larger model for the step that actually needs
it will matter more to your bill than any prompt tweak.

## A minimal system, honestly described

A production RAG system, stripped of buzzwords, is: a job that keeps an
index up to date, a retrieval step with a measurable precision, a prompt
template with version control, and logging that lets you see exactly what
was retrieved and generated for any given request. None of that is
glamorous, and all of it is what actually determines whether the system is
trustworthy enough to ship.

The model gets better every few months regardless of what you do. The
evaluation harness, the guardrails, and the observability around your
system are the parts you're actually responsible for — and the parts that
keep paying off long after the current model is obsolete.
