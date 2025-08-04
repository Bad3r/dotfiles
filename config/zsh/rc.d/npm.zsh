local npm_config_prefix="$HOME/.npm-global"

# if npm is not installed, of if its already configured; exit.
if ! (( $+commands[npm] )) || [ -d "$npm_config_prefix" ]; then
    return
fi

local npm_cache_dir="$XDG_CACHE_HOME/npm"
local npm_config_dir="$XDG_CONFIG_HOME/npm"

mkdir -p "$npm_config_prefix" >/dev/null 2>&1
mkdir -p "$npm_cache_dir" >/dev/null 2>&1
mkdir -p "${npm_config_dir}" >/dev/null 2>&1

# Update $PATH
export PATH="$npm_config_prefix/bin:$PATH"

local npm_userconfig="$npm_config_dir/usernpmrc"
local npm_globalconfig="$npm_config_dir/globalnpmrc"
local npm_init="$npm_config_dir/npm-init.js" # `npm init` command customization

# Set config
npm config set prefix $npm_config_prefix >/dev/null 2>&1
npm config set userconfig "$npm_userconfig" >/dev/null 2>&1
npm config set globalconfig "$npm_globalconfig" >/dev/null 2>&1
npm config set init-module "$npm_init" >/dev/null 2>&1

# cache
npm config set cache "$npm_cache_dir" >/dev/null 2>&1
npm config set cache-max 1073741824 >/dev/null 2>&1 # 1GB limit

# Registry & Network
# https://registry.npmjs.cf is Cloudflare's npm mirror
npm config set registry https://registry.npmjs.cf >/dev/null 2>&1
npm config set progress false >/dev/null 2>&1 # cleaner install output

# Development workflow
npm config set save-exact true >/dev/null 2>&1    # exact versions in package.json
npm config set engine-strict true >/dev/null 2>&1 # enforce engine requirements

# misc
npm config set audit-level moderate >/dev/null 2>&1
npm config set fund false >/dev/null 2>&1
npm config set update-notifier false >/dev/null 2>&1
npm config set color true >/dev/null 2>&1
