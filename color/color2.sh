# OUTPUT all available colors in a TERMINFO/TERMCAP safe way (with `tput`)
colors2(){
  # quick test to decide wehter or not to print the UTF8 char : ▊
  # (for better comparison between FG and BG colors, which for
  #  a given integer between 0 and 255, often don't match, according
  #  to your TERMINFO/TERMCAP and TERMINAL EMULATOR !!)
  local utf8char="|"
  locale >/dev/null 2>&1
  [ $? = 0 ] && locale | grep -i utf-8 >/dev/null 2>&1 && utf8char="▊"


  local __res1=""
  # terminfo has setaf/setab
  echo -ne "\n\n"$__B_"TPUT SETAF 1..256\n\n"$__NN_
  if tput setab 9 && tput setaf 9 2>/dev/null; then
    local a=$(tput sgr0)
    for ((i=0;i<256;i++))
    do
      __res1=$__res1$(tput setaf $i)$i$utf8char$(tput setab $i)"~ "
    done
    printf "[%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a]\n" $__res1
  else
    echo -ne $__B_"--> non supported"
  fi
  # terminfo has setf/setb
  echo -ne $__B_"\n\nTPUT SETF 1..256\n\n"
  if tput setf 9 && tput setb 9 2>/dev/null; then
    __res1=
    local a=$(tput sgr0)
    for ((i=0;i<256;i++))
    do
      __res1=$__res1$(tput setf $i)$i$utf8char$(tput setb $i)"~ "
    done
    printf "[%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a]\n" $__res1
  else
    echo -ne $__B_"--> non supported"
  fi
  echo
}
