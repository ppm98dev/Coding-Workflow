# Technology Stack

> Updated post-v3.2 milestone completion (2026-05-24)

## Runtime

| Technology | Version | Purpose |
|------------|---------|---------|
| Markdown | N/A | Core framework — all logic is markdown prompts |
| YAML | N/A | Frontmatter in workflows/skills, model capabilities |
| XML | N/A | Semantic containers in workflows (`<task>`, `<role>`) |
| Bash | 3.2+ | Cross-platform orchestration scripts (macOS/Linux only) |
| Git | 2.x | Version control, atomic commits |
| MCP | Dynamic | Model Context Protocol server tools dynamically scanned |
| Custom Skills | Dynamic | Third-party skills from skills.sh dynamically scanned |

## Dependencies

### Production
| Package | Version | Purpose |
|---------|---------|---------|
| None | — | Zero dependencies — pure markdown framework |

### Development / Optional
| Package | Version | Purpose |
|---------|---------|---------|
| ripgrep (`rg`) | optional | Fast search (context-fetch skill) |
| fd | optional | Fast file finding (context-fetch skill) |
| jq | optional | JSON parsing in Bash scripts |

## Infrastructure

| Service | Provider | Purpose |
|---------|----------|---------|
| GitHub | GitHub | Version control, distribution |
| AI Agent | Model-agnostic | Reads and executes markdown prompts |

## File Type Distribution

| Type | Count | Purpose |
|------|-------|---------|
| `.md` | 194 | Workflows, skills, templates, docs, examples, archives |
| `.sh` | 4 | Bash validation/setup scripts |
| `.yaml` | 1 | Model capabilities registry |
| `.svg` | 1 | Banner asset |
| `.gitignore` | 1 | Git ignore rules |

## Configuration

| Variable | Purpose | Location |
|----------|---------|----------|
| `VERSION` | Framework version (1.5.0) | `./VERSION` |
| `model_capabilities.yaml` | Optional model capability registry | `./model_capabilities.yaml` |

## Outdated Packages

No traditional packages — this is a zero-dependency markdown framework.
Upstream dependency: `toonight/get-shit-done-for-antigravity` (originally from `gsd-build/get-shit-done`).
