---
name: lightsquares-dependency-canary
description: Import Light Squares' Dependency Canary audits into a Rust project's cargo-vet setup. The Canary publishes machine-reviewed `safe-to-run` and `safe-to-deploy` audits of crates.io updates as a cargo-vet audits file; every entry links to a public case page showing when, how, and by which models the update was reviewed. Use when a project runs `cargo vet` and wants a baseline of third-party audits for dependency updates, when `cargo vet` reports unaudited crates, or when someone asks what a "Baseline check by Light Squares' Dependency Canary" note in imports.lock means. Triggers — cargo vet, cargo-vet, supply-chain audit, audits.toml, imports.lock, dependency canary, crate update review.
license: MIT
compatibility: Requires cargo-vet (`cargo install cargo-vet`) and network access to app.lightsquares.dev.
metadata:
  version: "0.1.0"
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

Open the URL in `notes` to see the review date, strategy, the models used,
the criteria, the sha256 of the reviewed tarball, and the recorded entry.
The feed of everything published is at
<https://app.lightsquares.dev/canary/feed>.

## Caveats

- An entry is published only when the review cleared **both** criteria;
  anything cleared for one but not the other goes to a human instead.
- Absence of an entry means "not cleared", not "malicious": the Canary only
  publishes clean verdicts.
- Treat it as a baseline, not a replacement for your own review of
  high-risk dependencies.

To stop importing, delete the `[imports.lightsquares-canary]` table and run
`cargo vet regenerate imports`.
