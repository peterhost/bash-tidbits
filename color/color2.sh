# OUTPUT all available colors in a TERMINFO/TERMCAP safe way (with `tput`)
colors2(){
  local __res1=""
  # terminfo has setaf/setab
  echo -ne "\n\n"$__B_"TPUT SETAF 1..256"$__NN_
  if tput setab 9 && tput setaf 9 2>/dev/null; then
    local a=$(tput sgr0)
    for ((i=0;i<256;i++))
    do
      __res1=$__res1$(tput setaf $i)$i$(tput setab $i)"~ "
    done
    printf "[%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a]\n" $__res1
  else
    echo -ne $__B_"--> non supported"
  fi
  # terminfo has setf/setb
  echo -ne $__B_"\n\nTPUT SETF 1..256"
  if tput setf 9 && tput setb 9 2>/dev/null; then
    __res1=
    local a=$(tput sgr0)
    for ((i=0;i<256;i++))
    do
      __res1=$__res1$(tput setf $i)$i$(tput setb $i)"~ "
    done
    printf "[%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a] [%-3s$a]\n" $__res1
  else
    echo -ne $__B_"--> non supported"
  fi
  echo
}
