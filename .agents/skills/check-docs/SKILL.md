---
name: check-docs
description: Use when verifying opencode features, functions, config options, commands, or settings actually exist. Use when the user asks about an opencode capability and the docs should be checked first.
metadata:
  author: maiconfaria
  source: https://github.com/maiconfaria/skills
  source-path: .agents/skills/check-docs
---

# Check opencode Documentation

## What I do

Before claiming opencode supports a feature, function, config key, command, or setting, fetch the relevant page from https://opencode.ai/docs to confirm it actually exists.

## When to use me

Use this skill whenever:
- The user asks about an opencode feature, command, or config option
- You are unsure if a specific opencode capability exists
- You want to reference an opencode function or setting correctly
- The user mentions a tool, permission, or configuration that might not be real

## How to use

1. Identify the opencode feature/command/config being asked about
2. Fetch the appropriate docs page from https://opencode.ai/docs to verify it exists
3. If found, reference the correct name and docs URL
4. If not found, tell the user it doesn't exist rather than hallucinating it

## Docs page mapping

- Config reference: https://opencode.ai/docs/config/
- LSP servers: https://opencode.ai/docs/lsp/
- MCP servers: https://opencode.ai/docs/mcp-servers/
- Custom tools: https://opencode.ai/docs/custom-tools/
- Agent Skills: https://opencode.ai/docs/skills/
- Permissions: https://opencode.ai/docs/permissions/
- Keybinds: https://opencode.ai/docs/keybinds/
- Commands: https://opencode.ai/docs/commands/
- Formatters: https://opencode.ai/docs/formatters/
- Tools: https://opencode.ai/docs/tools/
- Rules: https://opencode.ai/docs/rules/
- Providers: https://opencode.ai/docs/providers/
- Themes: https://opencode.ai/docs/themes/
- Models: https://opencode.ai/docs/models/
- TUI usage: https://opencode.ai/docs/tui/
- CLI usage: https://opencode.ai/docs/cli/
- Troubleshooting: https://opencode.ai/docs/troubleshooting/
- Network: https://opencode.ai/docs/network/
- ACP Support: https://opencode.ai/docs/acp/
