---
title: Digital Signature Flow
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
  Quick reference for request signing and signature validation in a SOAP
  integration.
---
## Sender Side

### Security

- Prepare the payload.
- Generate a hash of the payload (for example, SHA-256).
- Sign the hash using the sender's private key.
- Encode and populate the signature in the security section.
- Send the payload and signature to the receiver.

### Result

- The payload remains unchanged and readable.
- The signature proves the payload was signed by the holder of the private key.
- Any modification to the payload invalidates the signature.

---

## Receiver Side

### Security

- Receive the payload and signature.
- Determine the sender's public key.
- Generate a hash of the received payload.
- Verify the signature using the public key.
- Compare:
  - Hash calculated from the received payload
  - Hash obtained from signature verification
- Accept the request if the hashes match.
- Reject the request if verification fails or hashes differ.

### Result

- Matching hashes confirm message integrity.
- Successful verification confirms the sender's authenticity.
- Failed verification indicates tampering or an incorrect key.

---

## Quick Flow

### Security

1. Sender prepares the payload.
2. Sender generates a payload hash.
3. Sender signs the hash using a private key.
4. Sender sends the payload and signature.
5. Receiver receives the payload and signature.
6. Receiver selects the sender's public key.
7. Receiver verifies the signature.
8. Receiver generates a hash of the received payload.
9. Receiver compares both hash values.
10. Receiver accepts or rejects the request.

### Validation Outcome

- ✅ Valid Signature → Integrity and authenticity confirmed.
- ❌ Invalid Signature → Request rejected.
