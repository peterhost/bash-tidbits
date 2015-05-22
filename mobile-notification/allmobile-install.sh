# Function which sends a notification to both ios devices using prowl and android devices using nma
# Requires both __nmainstall() and __prowlpostinstall()
__allmobileinstall(){

  [ -x $HOME/bin/prowlpost ] && [ -x $HOME/bin/nma ] && {

    printf "\n%s" $__Y_"installing mobilenotify utility..."
    cat << 'EOF' > $HOME/bin/mobilenotify

#!/bin/sh

#nma : Application Event Description [priority]
# prowlpost :  "Event name" "[priority]" "Message body"
__app=$1
__event=$2
__desc=$3
__priority=$4

prowlpost "[$1] $2" "$4" "$3"
nma "$1" "$2" "$3" "$4"
EOF
  chmod +x  $HOME/bin/mobilenotify

  } || {
    echo "Cannot install mobilenotify utility : either prowlpost utility or nma utility is not installed : __prowlpostinstall & __nmainstall to install them first"
  }

}
