# World TLDR - Global Trends Digest

A monthly research project that identifies and analyzes structurally significant global events and developments. This repository archives monthly digests that focus on completed changes with long-term implications rather than daily news cycles.

## About the Project

This project creates comprehensive monthly summaries of global developments that will matter in hindsight. Each digest is researched and written by Claude AI following a systematic methodology that:

- Prioritizes structural significance over daily noise
- Covers multiple languages and regions to avoid Western bias
- Cross-references traditional media with social media validation
- Applies the "Archive Test" - will this matter in 10 years?

## Repository Structure

```
/
├── instructions.md     # Research methodology and guidelines
├── publish.sh         # Publishing automation script
├── current/           # Current month's files
│   ├── world-tldr-YYMM.md
│   └── world-tldr-trends-YYMM.md
└── archive/           # Previous months' digests
    └── YYMM/
        ├── world-tldr-YYMM.md
        ├── world-tldr-trends-YYMM.md
        └── commit-hash.txt
```

## Files Explained

- **`world-tldr-YYMM.md`** - Monthly digest ranking the most significant global events
- **`world-tldr-trends-YYMM.md`** - Monitoring database tracking ongoing developments
- **`instructions.md`** - Detailed research methodology that evolves over time
- **`publish.sh`** - Automation script for archiving and publishing new months

## Publishing Workflow

1. **Research Phase**: Claude conducts systematic multilingual research following the methodology in `instructions.md`

2. **Publication**: Place new month's files in the root directory and run:
   ```bash
   ./publish.sh
   ```

3. **What the script does**:
   - Archives previous month's files to `archive/YYMM/`
   - Moves new files to `current/` directory
   - Creates git commit with descriptive message
   - Tags release (e.g., `v2025-08`)
   - Generates permalink to instructions used for that month

## Versioned Instructions

Each month's digest includes a permalink to the exact version of `instructions.md` used for research, ensuring transparency about methodology evolution. Example:

> "Researched and written by Claude Sonnet on September 12, 2025 using [these instructions](https://github.com/user/repo/blob/abc123/instructions.md)"

## Research Methodology

The project follows a rigorous approach detailed in `instructions.md`:

- **Significance Filtering**: Events ranked by structural importance using the "Archive Test"
- **Language Coverage**: Systematic searches in English, French, Portuguese, Danish, Russian, and others
- **Bias Mitigation**: Active seeking of non-Western perspectives and alternative narratives  
- **Social Validation**: Cross-referencing traditional media with social platform discussions
- **Temporal Focus**: Emphasis on completed events rather than predictions

## Archive Navigation

- **Current month**: Always in `/current/` directory
- **Previous months**: Organized by YYMM in `/archive/`
- **Instruction versions**: Use commit hashes in `commit-hash.txt` for permalinks

This structure balances easy access to recent content with organized historical archives.