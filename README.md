# betrusted-ed25519-verified

Formal verification of the ed25519 implementation in **betrusted-io/curve25519-dalek (Precursor/Xous fork, v4.1.2)**, built as a
coherent proof pyramid in Lean 4 via the Charon/Aeneas transpilation pipeline:

```
        ┌──────────────────────────────┐
        │  Signature (EdDSA verify)    │   accepted ⇒ [8][S]B = [8]R + [8][k]A
        ├──────────────────────────────┤
        │  Scalar arithmetic mod ℓ     │   Scalar52 ops correct mod ℓ
        ├──────────────────────────────┤
        │  Group law (twisted Edwards) │   point ops = complete addition law
        ├──────────────────────────────┤
        │  Field 𝔽_p, p = 2²⁵⁵ − 19    │   FieldElement51 ops correct mod p
        └──────────────────────────────┘
```

Every layer states its theorems about the **actual Aeneas-transpiled Rust
code** (never about a hand-written re-model), and every claim in the status
table below is backed by a compiled proof plus an axiom audit of the named
certificate. Files that do not compile under `verification/check.sh` are not
in this repository.

## Layer status

| Layer | Certificate | Status | Axioms of certificate |
|-------|-------------|--------|-----------------------|
| Field 𝔽_p          | `fieldImplementation`    | ✅ proven | `[propext, Classical.choice, Quot.sound]` |
| Group law (Edwards) | `edwardsImplementation`  | ⏳ in progress | — |
| Scalar mod ℓ        | `scalarImplementation`   | ⏳ in progress | — |
| Signature (EdDSA)   | `verifyEquation`          | ⏳ in progress | — |

Status legend: ✅ proven & axiom-audited · ⏳ in progress · ❌ not started.
This table is updated only when `verification/check.sh` passes for the layer.

## Source

- **Upstream**: [betrusted-io/curve25519-dalek](https://github.com/betrusted-io/curve25519-dalek), commit `16e087a`
- **Pinned/patched source**: [saymrwulf/betrusted-curve25519-dalek-source](https://github.com/saymrwulf/betrusted-curve25519-dalek-source), commit `64ee8f0`
- **Patches**: minimal Aeneas-compatibility only (documented in the source repo)
- **Scope caveat**: this verifies the fork's pure-Rust `serial/u64` path. The Engine25519 hardware-accelerator path on Precursor is different code and is NOT covered by these proofs.

## Toolchain (pinned)

| Component | Version |
|-----------|---------|
| Aeneas    | `bf13c42e` |
| Charon    | `9dd7f23c` |
| Lean      | `v4.30.0-rc2` |
| OCaml     | `5.3.0` |

## Reproducing

```bash
source ~/aeneas-toolchain/env.sh
cd verification
./extract.sh    # Rust → LLBC → Lean (regenerates gen/)
./check.sh      # compiles EVERY shipped file + axiom-audits EVERY certificate
```

## Trusted base

See [TRUSTED-BASE.md](TRUSTED-BASE.md) for the complete list of assumptions
(Lean kernel, mathlib, Charon/Aeneas semantics, external-function models,
and — in the signature layer only — an opaque SHA-512 model).
