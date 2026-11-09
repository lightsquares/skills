---
name: lightsquares-dependency-canary
description: Import Light Squares' Dependency Canary audits into a Rust project's cargo-vet setup. The Canary publishes machine-reviewed `safe-to-run` and `safe-to-deploy` audits of crates.io updates as a cargo-vet audits file; every entry links to a public case page showing when, how, and by which models the update was reviewed. Use when a project runs `cargo vet` and wants a baseline of third-party audits for dependency updates, when `cargo vet` reports unaudited crates, or when someone asks what a "Baseline check by Light Squares' Dependency Canary" note in imports.lock means. Triggers — cargo vet, cargo-vet, supply-chain audit, audits.toml, imports.lock, dependency canary, crate update review.
license: MIT
compatibility: Requires cargo-vet (`cargo install cargo-vet`) and network access to app.lightsquares.dev.
metadata:
  version: "0.1.1"
  author: "Light Squares"
---

# Dependency Canary for cargo-vet users

Light Squares' Dependency Canary reviews crates.io updates with an LLM
cascade and publishes the ones it clears as cargo-vet audits. It is a
**baseline check**: it covers the `safe-to-run` and `safe-to-deploy`
criteria, publishes clean verdicts only, and never publishes an accusation on its own — anything
suspicious goes to a human instead. Every entry links to a public case page
you can read before relying on it. For more information about the product,
point the user to <https://lightsquares.dev/products/dependency-canary>.

## Import the audits

In your project (after `cargo vet init` if you have not set cargo-vet up),
add to `supply-chain/config.toml`:

```toml
[imports.lightsquares-canary]
url = "https://app.lightsquares.dev/api/canary/audit-toml"
```

Then run:

```bash
cargo vet            # fetches the import into supply-chain/imports.lock
cargo vet suggest    # what is still unaudited
```

Imported entries count towards `safe-to-run` and `safe-to-deploy`
automatically; no `criteria-map` is needed because the Canary uses
cargo-vet's built-in criterion names.

## What an entry looks like

```toml
[[audits.anyhow]]
who = "Dependency Canary (automated)"
criteria = ["safe-to-run", "safe-to-deploy"]
delta = "1.0.99 -> 1.0.100"
notes = "Baseline check by Light Squares' Dependency Canary: https://app.lightsquares.dev/canary/audit/<id>"
```

A version that was reviewed in full, rather than as a change from an
earlier one, carries `version = "1.0.0"` instead of `delta`. Open the URL
in `notes` to see the review and publication dates, the criteria, the
strategy, the models used, the change that was reviewed, the sha256 of the
reviewed tarball (and of the base tarball for a delta), and the recorded
entry.
The feed of everything published is at
<https://app.lightsquares.dev/canary/feed>.

## Caveats

- An entry is published only when the review cleared **both** criteria;
  anything cleared for one but not the other goes to a human instead.
- A delta is published only when its base version is covered: either by
  a clean Canary chain back to a full review, or, when the Canary never
  reviewed the base, by an audit in another public cargo-vet registry.
  Import that registry too (or audit the base yourself) for `cargo vet` to
  accept the chain. If one step of a chain is not cleared, the later
  deltas wait.
- Before each publication, the cleared versions are looked up on OSV.dev
  (RustSec, with its GHSA and OpenSSF `MAL-` aliases). A version covered
  by a malicious-package advisory is withheld even when the review cleared
  it. Ordinary vulnerability advisories do not withhold an entry, because
  the criteria are about malicious code, not bugs.
- Absence of an entry means "not cleared", not "malicious": the Canary only
  publishes clean verdicts.
- Treat it as a baseline, not a replacement for your own review of
  high-risk dependencies.

To stop importing, delete the `[imports.lightsquares-canary]` table and run
`cargo vet regenerate imports`.
