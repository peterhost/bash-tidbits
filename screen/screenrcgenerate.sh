# .........................................................................
# SCREENRC generation function
# if you are on a blank *nix config, you might want some .screenrc to be
# set for you. This function will automatically generate a screenrc for
# you.
# choose either S (simple) or F (full) at the function's command prompt


function screenrcGENERATE() {
  local origDir__=`pwd`

  if [ -f ~/.screenrc ]; then
    echo -ne "
    ${_EMR_}WARNING: ${_EMQ_}there is already a file named '${_EM_}.screenrc${_EMQ_}' in your homedir
    Delete the old one first, and call this function again

    ${_NN_}\n"

  elif [ -d ~/.screenrcconfig ]; then
    echo -ne "
    ${_EMR_}WARNING: ${_EMQ_}there is already a directory named '${_EM_}.screenrcconfig${_EMQ_}' in your homedir
    Delete this dir first, and call this function again

    ${_NN_}\n"

  else
    # prompt user for install type
    echo -ne "\n${_EMY_}This script will generate a .screenrc file for you."
    echo -ne "\n${_Y_}-> basic  : will work on all systems, even with oldest versions of GNU screen"
    echo -ne "\n${_Y_}-> simple : fully featured screnrc (with lots of keybindings, layout support, ...)"
    echo -ne "\n${_Y_}-> full   : adds a bottom menubar with system monitoring tools (à la Byobu)\n"
    echo -ne "\n${_G_}Which version of .screenrc would you like to install (basic/simple/full) ? ${_EM_}(b/s/f)${_EMQ_} "
    local confirm_
    read confirm_
    if [[ "$confirm_" =~ ^[bBsSfF]$ ]]
    then
      echo -ne "-> proceeding...\n"
    else
      echo -ne "${_R_}\n... ABORTED${_NN_}\n\n"
      return 0
    fi
    #
    mkdir ~/.screenrcconfig
    cd ~/.screenrcconfig

    ## BASIC screenrc
    if [[ "$confirm_" =~ ^[bB]$ ]]; then
      OUTFILE=~/.screenrc
      # -----------------------------------------------------------
      # 'Here document containing the body of the generated script.
      (
      cat <<'EOF'
      vbell off
      autodetach on
      defscrollback 10000
      startup_message off
      pow_detach_msg "Screen session of \$LOGNAME \$:cr:\$:nl:ended."
      caption always "%{= gk}%-Lw%{= rW}%50> %n%f* %t %{-}%+Lw%< %= %{= Gk} %H %{= rW} %l %{= Gk} %0c:%s %d/%m %{-}"
      shell -$SHELL
      bindkey -t "^a^[OD" prev                                    #       c+a right-arrow         next window (in the same region)
      bindkey -t "^a^[OC" next                                    #       c+a left-arrow          previous window (in the same region)
      bindkey -t "^a^[OA" focus up                                #       c+a up-arrow            switch to previous REGION
      bindkey -t "^a^[OB" focus down                              #       c+a down-arrow          switch to next REGION

EOF
      ) > $OUTFILE
      # -----------------------------------------------------------
      echo -ne "\n${_EMB_}Screenrc sucessfully generated...\n${_B_} "
      return 0;
    fi

    ## FULL screenrc ADDONS installation
    ###################
    ##<<<<<BEGIN>>>>>##
    ###################
    if [[ "$confirm_" =~ ^[fF]$ ]]; then

      echo -ne "\n${_EMB_}Retrieving Files...\n${_B_} "

      echo -ne "arch=1 \n battery=1 \n cpu_count=1 \n cpu_freq=1 \n cpu_temp=1 \n date=1 \n disk=1 \n disk_io=1 \n ec2_cost=1 \n fan_speed=1 \n hostname=1 \n ip_address=1 \n load_average=1 \n mail=1 \n mem_available=1 \n mem_used=1 \n network=1 \n processes=1 \n raid=1 \n rcs_cost=1 \n reboot_required=1 \n release=1 \n services=1 \n swap=1 \n time=1 \n updates_available=1 \n uptime=1 \n users=1 \n whoami=1 \n wifi_quality=1" > status


      OUTFILE=color         # Name of the file to generate.
      # -----------------------------------------------------------
      # 'Here document containing the body of the generated script.
      (
      cat <<'EOF'
      #!/bin/bash
      # Define colors
      color() {
        local ESC="\005"
        case "$1" in
          "") return 0 ;;
          -)   printf "$ESC{-}" ;;
          esc)    printf "$ESC" ;;
          bold1)  printf "$ESC{=b }" ;;
          bold2)  printf "$ESC{+b }" ;;
          none)   printf "$ESC{= }" ;;
          invert) printf "$ESC{=r }" ;;
          *)
            if [ "$#" = "2" ]; then
              [ "$MONOCHROME" = "1" ] && printf "$ESC{= }"   || printf "$ESC{= $1$2}"
            else
              [ "$MONOCHROME" = "1" ] && printf "$ESC{=$1 }" || printf "$ESC{=$1 $2$3}"
            fi
          ;;
        esac
      }
      export -f color
      sh ~/.screenrcconfig/byobubackticks/$1
EOF
      ) > $OUTFILE
      # -----------------------------------------------------------
      chmod 755 color

      local baseaddress=http://bazaar.launchpad.net/%7Ekirkland/byobu/trunk/download/
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101031182009-5048na5jcpa4c4pr/rates.eu_ie-20100303173410-mjydnebc7xh18872-1/rates.eu_ie
      mv rates.eu_ie ec2_rates

      mkdir ~/.screenrcconfig/byobubackticks
      cd ~/.screenrcconfig/byobubackticks
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/arch-20090312225857-1st1ay5546dx55jk-1/arch
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/battery_state-20090401154511-2t9aivk19efvb2iz-1/battery
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/cpucount-20081216054030-smm2s18rkws9jxd7-1/cpu_count
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101124184432-pza712mygpyh1a7r/cpufreq-20081214220426-kfo9fcntn5diq3q3-7/cpu_freq
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101213200956-ba33ioi4q3lytam1/tempc-20090520094940-1aoyo03d32amr34f-1/cpu_temp
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/date-20090417150542-duen9aww9as2kxxu-1/date
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100426232824-exobfdhqnusrv3fr/diskavailable-20090507053626-puu7z2omvy3obugh-1/disk
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/disk_io-20100426185945-jr1dxurzzi3saa28-1/disk_io
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/fan_speed-20090703225809-90ke124jc8cqgapq-1/fan_speed
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/hostname-20090219163709-ravva6wnn302udh2-1/hostname
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101208040503-mhv9934zc2vg1w0p/ipaddress-20090428021737-5em40o7qah3j0gr4-1/ip_address
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/loadaverage-20090109204230-ge9tf1sqquvlx80g-1/load_average
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101107025252-v8xtofwfx8r4h3y2/mail-20090617195519-mcksfzbh4ic2q4hf-1/mail
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/memavailable-20090109204230-ge9tf1sqquvlx80g-2/mem_available
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/memused-20090122050806-wzggcnjhmbou5ht1-1/mem_used
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/network-20090616214401-pxgd4tpak9lxs6oh-1/network
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/processes-20090403172058-otp9m0o67vnahnwk-1/processes
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101205171126-jmu59xdy1k11crwo/raid-20101107023323-088k7gfxm7qtv9c8-1/raid
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/rebootrequired-20081214220426-kfo9fcntn5diq3q3-8/reboot_required
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101119034144-pomi7xbc318s3i0k/release-20081214220426-kfo9fcntn5diq3q3-9/release
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/cloud-20100107231422-ifxea19nqdxpcuht-1/services
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101119024319-m00jrfu8bb8b1v6m/swap-20101119021638-aj7k75vwfzljfeny-1/swap
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/time-20090417150542-duen9aww9as2kxxu-2/time
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/updatesavailable-20081214220426-kfo9fcntn5diq3q3-10/updates_available
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/uptime-20090402151814-8zrx0cposuht4g87-2/uptime
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112142910-lt54mmg5527m36mq/nbusers-20090402151814-8zrx0cposuht4g87-1/users
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101128163758-icxiuw243f9rq6tr/whoami-20090219163925-5tazmp3lboni6k4n-1/whoami
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40x200-20100112144644-ktden041npb67lt0/wifiquality-20090406204854-x9nofv5z9pgdda3c-1/wifi_quality


      # rackspace cloud
      if [[ "$(uname -a )" =~ rscloud ]]; then
        wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20100914204003-t5i55bjawkzpbqcl/rcs_cost-20100428144127-lnxp8ec343nz3wjl-1/rcs_cost
      fi

      # Amazon EC2 cloud
      wget --tries=3 --no-verbose ${baseaddress}kirkland%40ubuntu.com-20101113042803-6mklbnkrk9irlu8p/ec2cost-20090204095049-1w4nilg6tqxgx41y-1/ec2_cost

      chmod 755 ./*

      # -----------------------------------------------------------
      # DO SOME REPLACEMENT of the default byobu backtick files
      # (colors, PKG variable)

      if [[ "$OSflavor" =~ Darwin || "$OSflavor" =~ BSD ]]
      # MACOS (cf. http://alexle.net/archives/tag/invalid-command-code)
      then
        # replace PKG="byobu" by PKG="screenrcconfig" in all those files
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "PKG=\"byobu\"" -sl | sed -E  's/[[:space:]]+/\\ /g' | xargs sed -i "" "s/PKG=\"byobu\"/PKG=\"screenrcconfig\"/g"
        # replace white with blue for text output in backtick commands
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "W)" -sl | sed -E  's/[[:space:]]+/\\ /g' | xargs sed -i "" "s/W)/K)/g"
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "w)" -sl | sed -E  's/[[:space:]]+/\\ /g' | xargs sed -i "" "s/w)/k)/g"
        # bring back white on magenta background
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "M K)" -sl | sed -E  's/[[:space:]]+/\\ /g' | xargs sed -i "" "s/M K)/M W)/g"
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "M k)" -sl | sed -E  's/[[:space:]]+/\\ /g' | xargs sed -i "" "s/M k)/M w)/g"
        # uptime
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "(color w b)" -sl | sed -E  's/[[:space:]]+/\\ /g' | xargs sed -i "" "s/(color w b)/(color w B)/g"

      # BUSYBOX
      elif [[ "$OSspecific" =~ Synology ]]
      then
      # replace PKG="byobu" by PKG="screenrcconfig" in all those files
      find . -type f -name '*' -print |  xargs grep "PKG=\"byobu\"" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/PKG=\"byobu\"/PKG=\"screenrcconfig\"/g"
      # replace white with blue for text output in backtick commands
      find . -type f -name '*' -print |  xargs grep "W)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/W)/K)/g"
      find . -type f -name '*' -print |  xargs grep "w)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/w)/k)/g"
      # bring back white on magenta background
      find . -type f -name '*' -print |  xargs grep "M K)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/M K)/M W)/g"
      find . -type f -name '*' -print |  xargs grep "M k)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/M k)/M w)/g"
      # uptime
      find . -type f -name '*' -print |  xargs grep "(color w b)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/(color w b)/(color w B)/g"


      # LINUX
      else
        # replace PKG="byobu" by PKG="screenrcconfig" in all those files
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "PKG=\"byobu\"" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/PKG=\"byobu\"/PKG=\"screenrcconfig\"/g"
        # replace white with blue for text output in backtick commands
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "W)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/W)/K)/g"
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "w)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/w)/k)/g"
        # bring back white on magenta background
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "M K)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/M K)/M W)/g"
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "M k)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/M k)/M w)/g"
        # uptime
        find . -wholename './*.git' -prune -o -type f -name '*' -print0 |  xargs -0 grep "(color w b)" -sl | sed -r  's/[[:space:]]+/\\ /g' | xargs sed -i "s/(color w b)/(color w B)/g"


      fi

    fi
    ## FULL screenrc ADDONS installation
    ###################
    ##<<<<<<END>>>>>>##
    ###################


    # -----------------------------------------------------------
    # GENERATE misc snippets (color themes for caption line)
    mkdir ~/.screenrcconfig/snippets
    cd ~/.screenrcconfig/snippets

    echo 'caption always "%?%F%{=b gk}%:%{= yk}%?%-Lw%{= rW}%50> %n%f* %t %{-}%+Lw%< %= %{= yk} %{=bu yk}%110`%{= yM} %{= yk}%109` %{-}%122`%10` %<"'>captionlight # LIGHT
    echo 'caption always "%?%F%{=b Bk}%:%{= bk}%?%-Lw%{= rW}%50> %n%f* %t %{-}%+Lw%< %= %{= yk} %{=bu yk}%110`%{= yM} %{= yk}%109` %{-}%122`%10`%<"'>captionblue # BLUE
    echo 'caption always "%?%F%{=b Bk}%:%{= bk}%?%-Lw%{= rW}%50> %n%f* %t %{-}%+Lw%< %= %{= mk} %{=bu mk}%110`%{= mM} %{= mk}%109` %{-}%122`%10`%<"'>captionblueMagenta # MAGENTA
    echo 'caption always "%?%F%{=b Gk}%:%{= gk}%?%-Lw%{= rW}%50> %n%f* %t %{-}%+Lw%< %= %{= yk} %{=bu yk}%110`%{= yM} %{= yk}%109` %{-}%122`%10`%<"'>captiongreen # GREEN
    echo 'caption always "%?%F%{=b wk}%:%{= kw}%?%-Lw%{= rW}%50> %n%f* %t %{-}%+Lw%< %= %{= kw} %{=bu kw}%110`%{= Kw} %{= kw}%109` %{-}%122`%10`%<"'>captiongrey # GREY


    # -----------------------------------------------------------
    # GENERATE the .screenrc, proper!
    local part1=~/scrctmp__1
    local part2=~/scrctmp__2
    local part3=~/scrctmp__3
    local part4=~/scrctmp__4
    (
    cat <<'EOF'
    ##############################################
    # NB :
    # this .screenrc config rips backticks from
    # byobu. It doesn't need byobu to be installed
    # as it doesn't use byobu's runtimes


    # ===========================================
    #            GENERAL TWEAKS
    # ===========================================

    # -------------------------------------------
    # TERM COLORS
    # terminfo for screen-256color
    # (http://blog.bulix.org/index.php/blog/1016)

      # <DESACTIVATED : scrambles too many things>
      ## Enable 256 color terminal
      #attrcolor b ".I"
      #termcapinfo xterm 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm'
      #defbce "on"

      #term screen-256color  #Deactivated when running opensim : scrambles OPENSIM console's colored output

    # Turns off alternate screen switching in xterms,
    # so that text in screen will go into the xterm's scrollback buffer:
      termcapinfo xterm* ti@:te@
      altscreen on

    # -------------------------------------------
    # UTF8 as default
      defutf8 on

    # -------------------------------------------
    # Ensure the default shell is the same as the $SHELL environment variable
      shell -$SHELL
      autodetach on
    # verbose messages
      verbose on
    # always activate multiuser mode
      multiuser on

    # -------------------------------------------
    # BELLS
    # audible bell, even from hidden windows
      bell "Bell in window %^G"
    # visual bell too
      vbell on
    # or... turn off the fucking visual bell
      #  vbell off

    # -------------------------------------------
    # MESSAGES
      msgwait 1
    # remove copyright message
      startup_message off
    # activity message
      activity "Activity in %t(%n)"
      # activity "activity in %n (%t) [%w:%s]~"

    # -------------------------------------------
    # SCROLLBACK
    # increase the scrollback (10 000 lines)
      defscrollback 10000

    # -------------------------------------------
    # Change default escape sequence from C-a to a backtick
        #escape ``                            # default ^Aa

    # disable screensaver by default
      idle 0


    # -------------------------------------------
    # MISC
      pow_detach_msg "Screen session of \$LOGNAME \$:cr:\$:nl:ended."

    # FIND as you type              (doc here http://lists.gnu.org/archive/html/screen-users/2007-02/msg00065.html)
      markkeys "^S=/:^R=?"

    # don't kill window after the process died
    #  zombie "^["

EOF
    ) > $part1

    # Only used if the 'full' option was chosen for screenrc generation
    (
    cat <<'EOF'

    # ===========================================
    #                CUSTOM BACKTICKS
    # ===========================================

    # BYOBU-based BACKTICKS (also used by COLOR THEME SWITCHER)

        # ===========================================
        # STATUS COMMANDS (used in STATUS/CAPTION bars)
        # ===========================================

        # ===> BYOBU inspired
        # Define status commands
        #   Use prime number intervals, to decrease collisions, which
        #   yields some less expensive status updates.
        #   ~86000 ~1 day
        #   ~600   ~10 minutes
        #   ~180   ~3 minutes
        #   ~60    ~1 minute
        #backtick 10         86389   86389           $HOME/.screenrcconfig/byobu-janitor
        backtick 11 86399   86399           printf "\005-1="
        backtick 101        7       7               $HOME/.screenrcconfig/color updates_available
        backtick 102        5       5               $HOME/.screenrcconfig/color reboot_required
        backtick 103        2       2               $HOME/.screenrcconfig/color cpu_freq
        backtick 104        86017   86017           $HOME/.screenrcconfig/color cpu_count
        backtick 105        86027   86027           $HOME/.screenrcconfig/color mem_available
        backtick 106        2       2               $HOME/.screenrcconfig/color load_average
        backtick 107        13      13              $HOME/.screenrcconfig/color mem_used
        backtick 108        17      17              $HOME/.screenrcconfig/color raid
        backtick 109        607     607             $HOME/.screenrcconfig/color hostname
        backtick 110        86029   86029           $HOME/.screenrcconfig/color whoami
        backtick 112        86077   86077           $HOME/.screenrcconfig/color arch
        backtick 113        61      61              $HOME/.screenrcconfig/color battery
        backtick 114        11      11              $HOME/.screenrcconfig/color users
        backtick 115        29      29              $HOME/.screenrcconfig/color uptime
        backtick 116        7       7               $HOME/.screenrcconfig/color processes
        backtick 117        3       3               $HOME/.screenrcconfig/color network
        backtick 119        17      17              $HOME/.screenrcconfig/color wifi_quality
        backtick 120        86111   86111           $HOME/.screenrcconfig/color date
        backtick 121        86113   86113           $HOME/.screenrcconfig/color time
        backtick 122        127     127             $HOME/.screenrcconfig/color ip_address
        backtick 123        13      13              $HOME/.screenrcconfig/color disk
        backtick 124        3       3               $HOME/.screenrcconfig/color disk_io
        backtick 125        19      19              $HOME/.screenrcconfig/color cpu_temp
        backtick 127        5       5               $HOME/.screenrcconfig/color mail
        backtick 128        23      23              $HOME/.screenrcconfig/color fan_speed
        backtick 130        86017   86017           $HOME/.screenrcconfig/color release
        backtick 131        11      11              $HOME/.screenrcconfig/color services
        backtick 132        17      17              $HOME/.screenrcconfig/color swap
        backtick 140        601     601             $HOME/.screenrcconfig/color ec2_cost
        backtick 141        601     601             $HOME/.screenrcconfig/color rcs_cost


    # ===========================================
    #                MENU BARS
    # ===========================================

      # ===========================================
      # HARDSTATUS MENUBAR
      # ===========================================
      # BOTTOM menubar - Configure status bar at the bottom of the terminal
        hardstatus alwayslastline
        hardstatus string '%{= kw} %120`%121`   %130` %112` %{= BR} UPTIME COST %{-}%115`%141` %= %{= BR} SYS INFOS %{-} %102`%101`%114`%127` %113`%104`%103`%125`%106`%116`%128`%119`%117`%105`%107`%132`%123`%108`%124`'



EOF
    ) > $part2
    (
    cat <<'EOF'

    # ===========================================
    #                MENU BARS
    # ===========================================

      # ===========================================
      # HARDSTATUS MENUBAR
      # ===========================================
      # BOTTOM menubar - Configure status bar at the bottom of the terminal
      hardstatus alwayslastline
      hardstatus string '%?%{yk}%-Lw%?%{wb}%n*%f %t%?(%u)%?%?%{yk}%+Lw%?'

EOF
    ) > $part3
    (
    cat <<'EOF'
      # ===========================================
      # CAPTION MENUBAR (one per screen REGION)
      # ===========================================
      # CAPTION menubar - bottom of each region

      # by default, we load the GREEN caption bar. Colors can be changed via the color-theme-switcher (see common.env)
        # LIGHT GREEN THEME
        caption always "%?%F%{=b gk}%:%{= yk}%?%-Lw%{= rW}%50> %n%f* %t %{-}%+Lw%< %= %{= yk} %{=bu yk}%110`%{= yM} %{= yk}%109` %{-}%122`%10` %<"


    # ===========================================
    #                KEY BINDINGS
    # ===========================================


    # -------------------------------------------
    # BASIC (functiunalities) key-bindings

      # remove DANGEROUS KILL key bindings and set it to UPPERCASE
        bind k
        bind 'K' kill

      # adds the C+a # functionality which enables reseting the window's number on the fly
        bind \# colon "number "

      #  Toggle 'fullscreen' or not.
        bind f eval "caption splitonly" "hardstatus ignore"
        bind F eval "caption always"    "hardstatus alwayslastline"


    # -------------------------------------------
    # COLOR THEMES switcher key-bindings

        # | CAPTION-THEME switcher : C+a e 0,1,2,3,4
        # | SCREEN-SAVER switcher  : C+a e s,S

      # _________________________________________
      # BINDING GROUPE : e = themes
      # CAPTION-THEME switcher : C+a e 0,1,2,3,4
      # SCREEN-SAVER switcher  : C+a e s,S

        # ----------------
        # CAPTIONS THEMES
        register l "^a:source $HOME/.screenrcconfig/snippets/captionlight ^M"                       #               | Goes with e 0 definition
        register g "^a:source $HOME/.screenrcconfig/snippets/captiongreen ^M"                       #               | Goes with e 1 definition
        register b "^a:source $HOME/.screenrcconfig/snippets/captionblue ^M"                        #               | Goes with e 2 definition
        register m "^a:source $HOME/.screenrcconfig/snippets/captionblueMagenta ^M" #               | Goes with e 3 definition
        register k "^a:source $HOME/.screenrcconfig/snippets/captiongrey ^M"                        #               | Goes with e 4 definition

        bind e command -c themes            #       ^A e                    PREPENDS the following key bindings (to the "e" intermediate key)
        bind -c themes 0    process l               #       ^Ae0                    Caption Theme set to LIGHT-GREEN (&yellow)
        bind -c themes 1    process g               #       ^Ae1                    Caption Theme set to BRIGHT-GREEN
        bind -c themes 2    process b               #       ^Ae2                    Caption Theme set to LIGHT-GREEN (&yellow)
        bind -c themes 3    process m               #       ^Ae3                    Caption Theme set to LIGHT-GREEN (&yellow)
        bind -c themes 4    process k               #       ^Ae4                    Caption Theme set to LIGHT-GREEN (&yellow)



        # <DEPRECATED : trying to use the FUNCTION KEYS
        #  bindkey -k k5 process l          # works but problematic         # F5            | Captions set to LIGHT (yellow)
        #  bindkey -k k6 process g          # works but problematic         # F6            | Captions set to GREEN
        #  bindkey  "^a^[OP" process l                                              # C+a F1        | Caption Theme set to LIGHT-GREEN (&yellow)
        #  bindkey  "^a^[OQ" process g                                              # C+a F2        | Caption Theme set to BRIGHT-GREEN
        #  bindkey  "^a^[OR" process b                                              # C+a F3        | Caption Theme set to BLUE
        #  bindkey  "^a^[OS" process m                                              # C+a F4        | Caption Theme set to BLUE & MAGENTA
        # />


        # -------------
        # SCREENSAVERS
        register d "^a:idle 600 ^M^a:wall Screensaver-activated ^M"         #               | Goes with e s definition
        register f "^a:idle 0 ^M^a:wall Screensaver-DEactivated ^M"         #               | Goes with e S definition
        bind -c themes s    process d               #       ^Aes                    ENABLE SCREENSAVER after 10 minutes idle time
        bind -c themes S    process f               #       ^AeS                    DISABLE SCREENSAVER


    # -------------------------------------------
    # We load the common WINDOWS/REGIONS navigation key-bindings

      # __________________________
      # NAVIGATION between REGIONS
      #  with the arrow keys

        #bindkey -t "^[OD" prev                                     # urxvt: left arrow ALONE (works, but bothering)
        #bindkey -t "^[OC" next                                     # urxvt: right arrow ALONE (works, but bothering)
        bindkey -t "^a^[OD" prev                                    #       c+a right-arrow         next window (in the same region)
        bindkey -t "^a^[OC" next                                    #       c+a left-arrow          previous window (in the same region)
        bindkey -t "^a^[OA" focus up                                #       c+a up-arrow            switch to previous REGION
        bindkey -t "^a^[OB" focus down                              #       c+a down-arrow          switch to next REGION
        bindkey -t "^aj" focus down
        bindkey -t "^ak" focus up
        bindkey -t "^at" focus top
        bindkey -t "^ab" focus bottom

        #bindkey -t "^q^[OA" focus top                      # urxvt: c+a up-arrow   =>      top REGION
        #bindkey -t "^q^[OB" focus bottom                   # urxvt: c+a down-arrow=>       bottom REGION

      # Make navigating between regions easier (standard, VI-compatible way)
        #bind s split
        bind j focus down
        bind k focus up
        bind t focus top
        bind b focus bottom

      # Make resizing regions easier
        bind = resize =
        bind + resize +1
        bind - resize -1

      # Rebing the vertical split
        bind | split -v


    # -------------------------------------------
    # common LAYOUT navigation key-bindings


      # ===========================================
      #     LAYOUT specific   KEY BINDINGS
      # ===========================================
      # C+a y 0,1,2,3,...           select layout number n
      # C+a y c                             create a new layout
      # C+a y \                             select this layout
      # C+a y i                             show current layout's NUMBER & NAME
      # C+a y ?                             show list of existing layouts



      # from Michael Schroeder's .screenrc           (http://lists.gnu.org/archive/html/screen-users/2007-02/msg00009.html)
      #
      # for playing with layouts. Thus you can use ^Ayc to create a new layout,
      # ^Ay? to show the available layouts, ^Ayy to move to the next layout,
      # and so on.


        bind y command -c layout
        bind -c layout y    layout next             #       ^Ay0            NEXT layout
        bind -c layout ' '  layout next             #       ^Ay" "          NEXT layout
        bind -c layout ^?   layout prev             #       ????            PREV layout
        bind -c layout n    layout next             #       ^Ayn            NEXT layout
        bind -c layout p    layout prev             #       ^Ayp            PREV layout
        bind -c layout 0    layout select 0         #       ^Ay0
        bind -c layout 1    layout select 1         #       ^Ay1
        bind -c layout 2    layout select 2         #       ...
        bind -c layout 3    layout select 3
        bind -c layout 4    layout select 4
        bind -c layout 5    layout select 5
        bind -c layout 6    layout select 6
        bind -c layout 7    layout select 7
        bind -c layout 8    layout select 8
        bind -c layout 9    layout select 9
        bind -c layout \'   layout select           #'      ^Ay\            SELECT this layout
        bind -c layout ?    layout show             #       ^Ay?            show a LIST of existing layouts
        bind -c layout i    layout number           #       ^Ayi            show NUMBER & NAME of current layout
        bind -c layout c    layout new              #       ^Ayc            create a NEW layout


      # _______________
      # LAYOUT SWITCHER
        bindkey -t "^ay^[OD" eval "layout next" "layout show"               #       ^Ay left-arrow          switch to preceding LAYOUT
        bindkey -t "^ay^[OC" eval "layout prev" "layout show"               #       ^Ay right-arrow         switch to next LAYOUT


    # -------------------------------------------
    # Fast navigation in copy mode
      #page up et page down when ^a Esc
      bindkey -m "33[5~" stuff ^B
      bindkey -m "33[6~" stuff ^F
      #bindkey -m "t" stuff ^B
      #bindkey -m "b" stuff ^F



    # ===========================================
    #               LAYOUTS
    # ===========================================

    # disable LAYOUT autosave (modifying a layout does not modify the saved version)
    layout autosave off

    # THE layout files are to be sourced by the specific .env file which sourced
    # this file (common.env)
    # (see keybindings/*layouts files)
    #
    # For the time being, we save the basic layout (1 region)
      layout save default           # layout n°0

    # attach the last used layout by default when reattaching to a screen instance
      layout attach :last
      #layout attach MyCustomLayout



    # ===========================================
    #                   MISC
    # ===========================================


    # End of file


EOF
      ) > $part4

    # ---------------------------------------------------------------------
    # MATCH the pieces

    cd ~/

    if [[ "$confirm_" =~ ^[fF]$ ]]; then
      cat $part1 $part2 $part4 > .screenrc
    else
      cat $part1 $part3 $part4 > .screenrc
    fi

    rm -f $part1 $part2 $part3 $part4
    cd $origDir__
    echo -ne "\n${_EMB_}Screenrc sucessfully generated...\n${_B_} "


  fi
}

