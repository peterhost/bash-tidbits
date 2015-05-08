
__prowlpostinstall() {
  printf "\n%s" $__Y_"installing prowlpost utility..."

  cat << 'EOF' > $HOME/bin/prowlpost
#!/bin/sh

# Kenneth Finnegan, 2012
# kennethfinnegan.blogspot.com

# Posts growl notifications to iOS device using prowl & curl
#
# Pass this script two (or three) arguments with the message title,
# (the message priority,) and the message.
#
# Dumps the XML response from prowl to LOG, which can be ignored
# unless you're coming anywhere close to the 1000/hr rate.

# 2012 03 08:  Initial fork from morningreport.sh
# 2012 03 21:  Replaced the hardcoded application name with `hostname`

APIKEY=73fa736a3e915e8fd087fbb33d0f09acd9523a9c
LOG="/tmp/prowl.log"
touch $LOG
chmod -f 666 $LOG

# Based on if we have two or three arguments, change the default priority
if [ $# -eq "2" ]; then
     EVENT_NAME=$1
     PRIORITY="0"
     EVENT_DESC=$2
elif [ $# -eq "3" ]; then
     EVENT_NAME=$1
     PRIORITY=$2
     EVENT_DESC=$3
else
     echo "USAGE: $0 \"Event name\" \"[priority]\" \"Message body\" " \
                                                                 >/dev/fd/2
     exit
fi

# Post notification to Prowl using curl
curl -s https://api.prowlapp.com/publicapi/add \
     -F apikey="$APIKEY" \
     -F priority="$PRIORITY" \
     -F application="`hostname`" \
     -F event="$EVENT_NAME" \
     -F description="$EVENT_DESC" > /tmp/prowl.log
EOF
  chmod +x  $HOME/bin/prowlpost
}
