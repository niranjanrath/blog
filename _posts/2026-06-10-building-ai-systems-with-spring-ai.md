---
title: "Building a RAG Pipeline with Spring AI: A Practical Walkthrough"
date: 2026-06-10
author: Your Name
topics:
  - AI
  - Spring
  - Java
tags:
  - spring-ai
  - rag
  - llm
  - vector-search
summary: >-
  A hands-on look at wiring retrieval-augmented generation into a Spring
  Boot service without hand-rolling an embeddings pipeline.
---

Retrieval-augmented generation (RAG) has become the default answer whenever
an LLM needs to talk about your own data instead of whatever it memorized
during training. Spring AI removes most of the plumbing so you can focus on
the parts that are actually specific to your domain: chunking strategy,
retrieval quality, and prompt structure.

## The shape of a RAG pipeline

At a high level, every RAG system does the same four things:

1. Split source documents into chunks.
2. Embed each chunk into a vector.
3. Store vectors in a searchable index.
4. At query time, embed the question, retrieve the closest chunks, and
   stuff them into the prompt.

## Ingestion

```java
@Component
public class DocumentIngestionService {

    private final VectorStore vectorStore;

    public DocumentIngestionService(VectorStore vectorStore) {
        this.vectorStore = vectorStore;
    }

    public void ingest(Resource resource) {
        var reader = new TikaDocumentReader(resource);
        var splitter = new TokenTextSplitter();
        List<Document> chunks = splitter.apply(reader.get());
        vectorStore.add(chunks);
    }
}
```

`TikaDocumentReader` handles PDFs, Word docs, and plain text without extra
code. `TokenTextSplitter` chunks by token count rather than character count,
which matters once you're paying per token and trying to keep chunks under
a model's context window.

## Retrieval and generation

```java
@Service
public class QuestionAnsweringService {

    private final VectorStore vectorStore;
    private final ChatClient chatClient;

    public QuestionAnsweringService(VectorStore vectorStore, ChatClient.Builder builder) {
        this.vectorStore = vectorStore;
        this.chatClient = builder.build();
    }

    public String answer(String question) {
        List<Document> results = vectorStore.similaritySearch(
            SearchRequest.query(question).withTopK(4)
        );

        String context = results.stream()
            .map(Document::getContent)
            .collect(Collectors.joining("\n---\n"));

        return chatClient.prompt()
            .system("Answer only using the provided context. Say so if it's insufficient.")
            .user(u -> u.text("Context:\n{context}\n\nQuestion: {question}")
                        .param("context", context)
                        .param("question", question))
            .call()
            .content();
    }
}
```

## Two decisions that matter more than the framework

**Chunk size is a tuning parameter, not a constant.** Too small and you lose
surrounding context the model needs to answer correctly; too large and
irrelevant text drowns out the signal. Start around 500 tokens with modest
overlap and measure actual answer quality against your own documents before
trusting a default.

**Retrieval quality caps generation quality.** No amount of prompt
engineering fixes a retriever that returns the wrong chunks. If answers are
wrong, check what was actually retrieved before touching the prompt —
logging the retrieved documents alongside every answer during development
will save more debugging time than any other single change.

Spring AI's abstraction over vector stores means swapping between, say, a
local PGVector instance in development and a managed vector database in
production is a configuration change, not a rewrite. That portability is
the main reason to reach for the framework instead of calling an embeddings
API directly.
