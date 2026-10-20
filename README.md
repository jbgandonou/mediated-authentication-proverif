# ProVerif models: delegated authentication under mediated access

Companion material for the article

> J.-B. Gandonou, J. Dégila, T. Wandji, T. K. Dagba, I. Tognisse, and A. Adehan,
> "Digital Literacy, Intermediation, and the Failure of Delegated Authentication in Sub-Saharan Africa," 2026.

The models check, with ProVerif 2.05, the three security properties of the article against eight families of authentication mechanisms when an intermediary operates the only terminal of the session.

- **P1**, non-delegable active consent: injective correspondence `ConsentAccepted ==> ConsentGiven`.
- **P2**, non-forgeability of authentication: injective correspondence `AuthAccepted ==> AuthUsed` (covers replay and forgery).
- **P3**, exclusive delivery: secrecy of `secretDoc`.

## Encoding of the constraints

| Constraint | Encoding |
|---|---|
| C1, no effective control of the terminal | No private channel between citizen and server |
| C2, limited infrastructure | Only primitives realistic for an access point are used |
| C3, non-exclusion of the intermediary | Terminal channel `chT` is public: the Dolev-Yao attacker stands where the intermediary stands |

The channel between server and civil registry (`chS`) is private.

## Models

| File | Categories of the article | P1 | P2 | P3 |
|---|---|---|---|---|
| `cat1_knowledge.pv` | A (memorized secrets), B (look-up secrets) | attack | attack | attack |
| `cat2_oob.pv` | C (out-of-band devices) | attack | attack | attack |
| `cat3_otp_local.pv` | D (OTP tokens) | attack | attack | attack |
| `cat4_federated.pv` | G (federated identity) | attack | attack | attack |
| `cat5_crypto_deleg.pv` | E (software cryptographic), H (cryptographic delegation) | attack | attack | attack |
| `cat6_fido2.pv` | F (hardware cryptographic, FIDO2) | attack | **proved** | attack |
| `cat6_fido2_public_response.pv` | F, with the authenticator's response on a public channel | attack | **proved** | attack |

Seventeen of the eighteen verifications of the six main models produce an attack trace; only P2 for category F is proved. The variant `cat6_fido2_public_response.pv` shows that this proof does not depend on hiding the authenticator's response from the attacker: freshness of the challenge and non-extractability of the key carry it.

All models share `common.pvl` (types, channels, primitives, events, queries), so differences between verdicts come from the mechanism, not from the way the code is written.

## Running

Install ProVerif 2.05, for instance with opam:

```bash
opam install proverif
```

Run one model:

```bash
proverif -lib common.pvl cat6_fido2.pv
```

Run all models and write a summary:

```bash
./run_all.sh
```

Full logs, including attack traces, are written to `results/`, and the verdicts to `results/summary.txt`. The files in `results/` were produced with ProVerif 2.05.

## Scope

The models are symbolic (Dolev-Yao). For P1 and P3, declaring the terminal channel public is already the hypothesis of the hand proofs, so the attack traces confirm the internal consistency of the model rather than its truth in the field; the article tests the premises with a survey. For P2 in category F, the private status of the key encodes the hardware-confinement axiom: the proof says that no valid proof exists without the device, not who operates it.
