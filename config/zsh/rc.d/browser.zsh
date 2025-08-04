# Tool: Browser Selection
# Desc: Set BROWSER based on available options (stops at first found)

# Priority order: nbrowser > zen-browser > firefox > firefox-developer-edition > vivaldi > ungoogled-chromium > chromium
if (( $+commands[nbrowser] )); then
    export BROWSER="nbrowser"
elif (( $+commands[zen-browser] )); then
    export BROWSER="zen-browser"
elif (( $+commands[firefox] )); then
    export BROWSER="firefox"
elif (( $+commands[firefox-developer-edition] )); then
    export BROWSER="firefox-developer-edition"
elif (( $+commands[vivaldi] )); then
    export BROWSER="vivaldi"
elif (( $+commands[ungoogled-chromium] )); then
    export BROWSER="ungoogled-chromium"
elif (( $+commands[chromium] )); then
    export BROWSER="chromium"
fi

