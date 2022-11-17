# Valiases
alias camid='f() { vtoolbox device.lookup -s $1 | jq -r ".cameras[0].cameraId" | xsel --clipboard};f'

