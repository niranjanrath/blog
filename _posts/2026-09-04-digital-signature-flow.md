---
title: Digital Signature Process in SOAP Integration
date: 2026-09-04
author: Niranjan Rath
topics:
  - Integration
  - SOAP
  - Security
tags:
  - security
  - digital-signature
  - soap
summary: >-
  High-level overview of how a sender signs a request and how a receiver
  validates the signature to ensure message integrity and authenticity.
---

# Digital Signature Flow

## Sender Side (Consumer)

### Security

- Prepare the request payload to be sent.
- Generate a digest (hash) of the payload using the agreed algorithm (for example, SHA-256).
- Sign the generated hash using the consumer's private key.
- Encode the generated signature as required by the interface specification.
- Populate the signature value in the request's security section.
- Send the payload together with the signature to the provider.

### Result

- The payload remains readable.
- The signature proves that the payload was signed by the holder of the private key.
- Any modification to the payload after signing will invalidate the signature.

---

## Receiver Side (Provider)

### Security

- Receive the request containing the payload and signature.
- Determine the appropriate public key associated with the sender.
- Generate a new hash from the received payload using the same hashing algorithm.
- Verify the received signature using the selected public key.
- Extract and validate the signed hash value.
- Compare:
  - Hash calculated from the received payload
  - Hash obtained through signature verification
- Accept the request if both hashes match.
- Reject the request if the verification fails or hashes differ.

### Result

- Matching hashes confirm message integrity.
- Successful verification confirms the signature was created using the corresponding private key.
- Verification failure indicates either data tampering or use of an incorrect key.

---

## End-to-End Flow

### Security

1. Consumer creates payload.
2. Consumer generates payload hash.
3. Consumer signs hash using private key.
4. Consumer sends payload + signature.
5. Provider receives payload + signature.
6. Provider selects sender's public key.
7. Provider verifies signature.
8. Provider recalculates payload hash.
9. Provider compares hash values.
10. Provider accepts or rejects the request based on verification outcome.

### Validation Outcome

- ✅ Signature Valid → Integrity and authenticity confirmed.
- ❌ Signature Invalid → Request rejected.
