#!/bin/bash

# get gateway
gateway=$(ip route | grep default | cut -d ' ' -f3)

echo "************************************************"

echo "*        starting connectivety test...         *"
echo "* Your default gateway is $gateway      *"

# ping default gw
$(ping -c 3 $gateway > /dev/null)
if [[ $? ]]
then
  echo "* Connection to default gateway is successful! *"
else
  echo "* Connection to default gateway failed! :(     *"
fi

# test remote connection 
$(ping -c 3 1.1.1.1 > /dev/null)
if [[ $? ]]
then
  echo "* Remote connection is successful!             *"
else
  echo "* Remote connection faild! :(                  *"
fi

# test DNS resolution
$(ping -c 3 google.com > /dev/null)
if [[ $? ]]
then
  echo "* DNS resolution is successful!                *"
else
  echo "* DNS resolution faild! :(                      *"
fi

echo "******************** Done! *******************"
