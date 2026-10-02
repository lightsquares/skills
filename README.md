# Light Squares skills

This repository holds agent skills for working with
[Light Squares](https://lightsquares.dev). A skill is a folder with a
`SKILL.md` file that a coding agent such as Claude Code reads when a task
calls for it. The skills here teach an agent how to use our products, so you
can ask it to set things up for you instead of reading the documentation
yourself.

## Available skills

`lightsquares-attestable-builds/` helps an agent set up a Git project for
Attestable Builds. It writes the `lightsquares.toml` and a small builder
image, tests the same build locally with podman or docker, and explains how
to start the build on app.lightsquares.dev and add the badge to your README.
The result is a signed record that links each release binary to the exact
commit it was built from.

`lightsquares-dependency-canary/` helps an agent add the Dependency Canary
audits to a Rust project that uses cargo-vet. The Canary reviews updates of
crates.io packages and publishes the ones it clears as cargo-vet audits,
each with a public page that shows how the review was done.

## Installing a skill

Copy the skill's folder into the directory your agent loads skills from. For
Claude Code, that is `~/.claude/skills/` for all your projects or
`.claude/skills/` inside a single project:

```bash
git clone https://github.com/lightsquares/skills.git
cp -r skills/lightsquares-attestable-builds ~/.claude/skills/
```

The agent picks the skill up the next time it starts. You do not need to
mention it by name; it is used when your request matches the skill's
description.

## Feedback

These files are published from our main repository, so we cannot accept pull
requests here. If something is wrong or missing, please open an issue or
write to hello@lightsquares.dev.

The skills are released under the MIT license; see `LICENSE`.
