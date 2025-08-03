# Claude Code Env Vars
export DISABLE_AUTOUPDATER=1
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 # Equivalent of setting DISABLE_AUTOUPDATER, DISABLE_BUG_COMMAND, DISABLE_ERROR_REPORTING, and DISABLE_TELEMETRY
export DISABLE_TELEMETRY=1
export CLAUDE_CODE_ENABLE_TELEMETRY=0
export DISABLE_ERROR_REPORTING=1
export DISABLE_NON_ESSENTIAL_MODEL_CALLS=1

export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1
export CLAUDE_BASH_DEFAULT_TIMEOUT_MS=240000 # 4? minutes
export CLAUDE_BASH_MAX_TIMEOUT_MS=4800000    # 20? minutes
export BASH_MAX_OUTPUT_LENGTH=1024

export MAX_THINKING_TOKENS=60000       # TODO: Calibrate
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=1 # Max tokens: Opus 4 = 32k, Sonnet 4 = 64k, 1 = default
export MAX_MCP_OUTPUT_TOKENS=32000     # Defualt 25000
export cleanupPeriodDays=30            # Defualt: 30

export ANTHROPIC_MODEL=claude-opus-4-20250514          # TODO: Ensure that its up to date as well as ANTHROPIC_SMALL_FAST_MODEL in ~/.claude/settings.json
export ANTHROPIC_SMALL_FAST_MODEL_AWS_REGIO=me-south-1 # https://www.economize.cloud/resources/aws/regions-zones-map
export VERTEX_REGION_CLAUDE_4_0_OPUS=me-south-1
export VERTEX_REGION_CLAUDE_4_0_SONNET=me-south-1

# First-time Claude setup
if command_exists claude && [[ ! -f ~/.claude.json ]]; then
  claude config set -g verbose true
  claude config set -g preferredNotifChannel iterm2_with_bell
  claude config set -g editorMode vim
  claude config set -g supervisorMode true
  claude config set -g parallelTasksCount 4
  claude config set -g installMethod npm
fi
