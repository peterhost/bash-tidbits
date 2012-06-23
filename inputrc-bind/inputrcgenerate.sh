# -----------------------------------------------------------------------------
# INPUTRC  (Custom Key remapping)


  # Create ~/.inputrc if needed
  function inputrcGenerate() {
    local irc_quiet_
    local irc_frombashrc_
    for i in $*
    do
      case $i in
              --quiet | -q) irc_quiet_=1                  ;;
              --frombashrc) irc_frombashrc_=1             ;;
              *) echo "unknown option $i"; return 1       ;;
      esac
    done



    [ "$irc_quiet_" != 1 ] && { if __confirm $__M_"This will reset your .inputrc file"; then :; else return 0; fi; }

    # if called outside this script, re-source bashrc before
    [ "$irc_frombashrc_" == 1 ] || { echo -e $__B_"Sourcing .bashrc"; srcbrcq; }

    # ERASE/CREATE .inputrc for user
    > ~/.inputrc
    inputrcTemplate
  }

  function inputrcTemplate() {
    > ~/.inputrc  # ERASE/CREATE .inputrc for user


    cat > ~/.inputrc <<'TOTO'

    #_______________________________________
    # MACOS
    #
    #  REMAP DUMB macosX Terminal First
    #
    #  SUMMARY :
    #  _______________________________________________________________
    # |        |    ←     |  →     |   ↑    |   ↓        |    DEL     |
    # |________|__________|________|________|____________|____________|
    # |  <>    |   cursB  |cursF   | hiPREV | hiNEXT     | del        |
    # |________|__________|________|________|____________|____________|
    # |  <S>   |   wordB  |wordF   | hiFIRST| hiLAST     | del to EOL |
    # |________|__________|________|________|____________|____________|
    # |  <C>   |     -    |   -    |   -    |    -       | del to BOL |
    # |________|__________|________|________|____________|____________|
    # |  <A>   |  transpC |transpW | upcaseW| downcaseW  | yank LAST  |
    # |________|__________|________|________|____________|____________|
    # |  <Fn>  |   BOL    | EOL    | setMark| backToMark |            |
    # |        |    (↖ )  | (↘ )   |  (⇞)   |  (⇟)       |     -      |
    # |________|__________|________|________|____________|____________|
    # | <S-Fn> |   buffB  |buffE   | pageU  | pageD      |            |
    # |        |   (S ↖ ) |(S ↘ )  | (S ⇞)  | (S ⇟)      |     -      |
    # |________|__________|________|________|____________|____________|
    #
    #
    #
    #
    #  Terminal -> Preferences and the Settings-pane, then select the Keyboard-tab.
    #
    #
    #  __________________________________________________________________________________________________________________
    # |                      |  *MAP TO*    |             *DOES*                    |              *WAS*                 |
    # |______________________|______________|_______________________________________|____________________________________|
    # | CHANGE some keys:                                                                                                |
    # |                                                                                                                  |
    # | This sends end, home, page up/down to the shell instead of the scroll buffer,                                    |
    # | and uses the shift-modifier for page up/down to scroll, like in every other                                      |
    # | terminals of this world.                                                                                         |
    # |------------------------------------------------------------------------------------------------------------------|
    # |                      |              |                                       |                                    |
    # | end                  | \033[F       |  EOL                                  |  scroll to end of buffer           |
    # | home                 | \033[H       |  BOL                                  |  scroll to start of buffer         |
    # | page down            | \033[6~      |  will map to goto mark                |  scroll to next page in buffer     |
    # | page up              | \033[5~      |  will map to set  mark                |  scroll to previous page in buffer |
    # |                      |                                                      |                                    |
    # | shift end            | scroll to end of buffer                              |                                    |
    # | shift home           | scroll to start of bufer                             |                                    |
    # | shift page down      | scroll to next page in buffer                        |                                    |
    # | shift page up        | scroll to previous page in buffer                    |                                    |
    # |                      |                                                      |                                    |
    # |………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………|
    # | ADD new ones                                                                                                     |
    # |------------------------------------------------------------------------------------------------------------------|
    # |                      |              |                                       |                                    |
    # | shift forward delete | C-k  (\013)  |  kill line          (delete to EOL)   |                                    |
    # | ctrl  forward delete | C-u  (\025)  |  backward-kill-line (delete to BOL)   |                                    |
    # | alt   forward delete | C-y  (\031)  |  paste              (paste buffer)    |                                    |
    # |                      |              |                                       |                                    |
    # | shift up arrow       | \e>          |  beginning-of-history                 |                                    |
    # | shift down arrow     | \e<          |  end-of-history                       |                                    |
    # | shift left arrow     | \eb          |  backward-word                        |                                    |
    # | shift down arrow     | \ef          |  forward-word                         |                                    |
    # |                      |              |                                       |                                    |
    # | alt   up arrow       | \e>          |  beginning-of-history                 |                                    |
    # | alt   down arrow     | \e<          |  end-of-history                       |                                    |
    # | alt   left arrow     | C-t          |  transpose-chars                      |                                    |
    # | alt   down arrow     | \et          |  transpose-word                       |                                    |
    # |______________________|______________|_______________________________________|____________________________________|
    #
    # some defaults / modifications for the emacs mode
    $if mode=emacs

    # mappings for "page up" and "page down" to step to the beginning/end
    # of word
    "\e[6~": exchange-point-and-mark
    "\e[5~": set-mark

    "ƒ": character-search           # alt+f
    "·": character-search-backward  # alt+shift+f
    "º": undo                       # alt+u
    "Ò": re-read-init-file          # alt+s (source)

    $endif




    #_______________________________________
    # HISTORY
    # By default up/down are bound to previous-history
    # and next-history respectively. The following does the
    # same but gives the extra functionality where if you
    # type any text (or more accurately, if there is any text
    # between the start of the line and the cursor),
    # the subset of the history starting with that text
    # is searched (like 4dos for e.g.).
    # Note to get rid of a line just Ctrl-C
    "\e[B": history-search-forward
    "\e[A": history-search-backward

    # ESC+P -> better history search (than CTRL+R)
    "\ep": history-search-backward

    #set history-preserve-point on
    #set mark-modified-lines on

    #_______________________________________
    # TEXT SNIPPETS

    # >GIT
      # Insert: @{} move cursor into braces
      "\e@": "@{}\e[D"

    # >TESTS
      # Insert: if ;then echo "true";else echo "false";fi
      # and move cursor after if
      "\ei": "if\ ;then\  echo\ \"true\";else\ echo\ \"false\";fi\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D"

      # Same with [  ] && echo "true" || echo "false"
      "\eI": "[\ \ ]\ &&\ then\ echo\ \"true\" ||\ echo\ \"false\"\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D\e[D"

      # Same with ">/dev/null 2>&1"
      "\ed": " >/dev/null 2>&1"

      #VARS
      "\e$": "${}\e[D"                # Esc+$ insert ${}
      "\e*": "${___}\e[D\e[D"           # Esc+* insert ${___}
      "\e€": "${__PS1_}\e[D\e[D"           # Esc+* insert ${__PS1_}



    #_______________________________________
    # MISC

    # ESC+c -> better history search (than CTRL+R)
    "\ec": clear-screen


    #_______________________________________
    # COMPLETION

    # Shows all files instead of beep when tab-completing
    set show-all-if-ambiguous on
    # Ignore case when completing, very nice!
    set completion-ignore-case on

    # if there are more than 150 possible completions for a word, ask the
    # user if he wants to see all of them
    set completion-query-items 200

    # do not bell on tab-completion
    #set bell-style none

    # Completed dir names have a slash appended
    set mark-directories on

    # Completed names which are symlinks to dirs have a slash appended
    set mark-symlinked-directories on

    # List ls -F for completion
    set visible-stats on


    # (LIST) COMPLETE                       ALT+@
    "\C-@": complete

    # (MENU) Complete (instead of list)     TAB
    "\C-i": menu-complete

    # (MENU) Backward Complete              SHIFT-TAB
    # WARNING: for this to work properly:
    #            1) your prompt ($PS1) has to be well formated.
    #               Pay close attention to PS1-escape (  \[ ... \] )
    #               ALL ANSI color escape codes.
    #            2) ALL ansi escape color codes have to be followed
    #               by a corresponding \[\e[0m\], by pairs, otherwise
    #               this functionnality will get confused no matter what
    "\e[Z": "\e-1\C-i"

    "\ez": "\C-b\e-1\C-i"


    $if Bash
      # F11 toggles mc on and off
      # Note Ctrl-o toggles panes on and off in mc
      "\e[11~": "mc\C-M"

      # do history expansion when space entered after !xxx
      Space: magic-space
    $endif

    #_______________________________________
    ## Include system wide settings which are ignored
    ## by default if one has their own .inputrc
    $include /etc/inputrc


TOTO

    echo "-> CREATED .inputrc"
  }


  inputrchelp(){
    echo -e "
  $__K_# in order to find an escape sequence suitable for your (readline) .inputrc, do :
    $__B_\$ read$__K_
  # press a key (here : SHIFT+TAB)
    $__EMR_^[$__EMG_[Z$__K_

  # $__EMR_^[$__K_ is equivalent to $__EMR_\\e$__K_
  # $__EMG_[Z$__K_ is our escape proper
  # So in .inputrc, map :
    $__B_\"$__EMR_\\e$__EMG_[Z$__B_\": function_you_wish_to_map$__K_

  # I personally like :$__B_
    \"\\e[Z\":\"\\e-1\\C-i\" # map SHIFT-TAB to backward completion$__K_
  # but it somewhat fucks up with badly formated colored prompts. Beware

  # MORE:
     ${__B_}$ bash -c \"help bind\" $__K_# more on bind function
     ${__B_}$ bindhelp            $__K_# (custom func) list ALL$__B_ key bindings, functions, variables$__K_
                             see also 'bindhelp key|var|func' for partial result

  # Readline init syntax file :  $__Y_ http://www.faqs.org/docs/bashman/bashref_90.html#SEC97$__K_
  # Conditional init constructs :$__Y_ http://www.faqs.org/docs/bashman/bashref_91.html#SEC98$__K_
  # Sample init file :           $__Y_ http://www.faqs.org/docs/bashman/bashref_92.html#SEC99$__NN_

"

  }


  # List all keybindings, bind functions, and bind variables, in colors & readable way
  bindhelp(){
    case $1 in
      k|key|keys|bind|binding|bindings)
        __bindhelpk
        ;;
      v|variable|variables|var)
        __bindhelpv
        ;;
      f|func|function|functions)
        __bindhelpf
        ;;
      *)
        __bindhelpf; __bindhelpk; __bindhelpv; __bindhelpa
        ;;
    esac

  }

  __bindhelpa(){

    echo -e "
    $__K_# Also, read :  ${__Y_}http://www.faqs.org/docs/bashman/bashref_93.html$__K_

      8.4 Bindable Readline Commands

      8.4.1 Commands For Moving                   Moving about the line.
      8.4.2 Commands For Manipulating The History Getting at previous lines.
      8.4.3 Commands For Changing Text            Commands for changing text.
      8.4.4 Killing And Yanking                   Commands for killing and yanking.
      8.4.5 Specifying Numeric Arguments          Specifying numeric arguments, repeat counts.
      8.4.6 Letting Readline Type For You         Getting Readline to do the typing for you.
      8.4.7 Keyboard Macros                       Saving and re-executing typed characters
      8.4.8 Some Miscellaneous Commands           Other miscellaneous commands.

"

  }

  __bindhelpf(){
    echo
    echo -e $__EMM_"inputrc FUNCTIONS : GENERAL"$__NN_
    printf "\e[0;33m%-45s \e[0;31m%-45s \e[0;32m%-45s\n" $(bind -l | grep -v "vi-")
    echo -e $__EMM_"                    VI MODE"$__NN_
    printf "\e[0;33m%-45s \e[0;31m%-45s \e[0;32m%-45s\n" $(bind -l | grep "vi-")
  }

  __bindhelpk(){
    echo
    echo -e $__EMM_"inputrc KEYBINDINGS"$__NN_
    echo
    echo -e $__EMM_"        BOUND"$__NN_
    local __list=`bind -p | grep -v '^#' | grep -v "self-insert" | grep -v '\\e[[:space:]]*"'`
    printf "\e[0;31m%-12s \e[1;32m%-40s \e[0;31m%-12s \e[1;32m%s\n" $__list
    echo
    echo -e $__EMM_"        UNBOUND"$__NN_
    __list=`bind -p | grep '^#' | grep -v 'vi-' | grep -v "self-insert" | grep -v '\\e[[:space:]]*"' | sed 's/#//' | sed 's/(not bound)$//'`
    printf "\e[0;33m%-53s \e[0;33m%s\n" $__list
    __list=`bind -p | grep '^#' | grep  'vi-' | grep -v "self-insert" | grep -v '\\e[[:space:]]*"' | sed 's/#//' | sed 's/(not bound)$//'`
    printf "\e[1;30m%-53s \e[1;30m%s\n" $__list
  }

  __bindhelpv(){
    echo
    echo -e $__EMM_"inputrc VARIABLES"$__NN_
    printf "\e[0;30m%s \e[0;31m%-35s \e[0;32m%3s\n" $(
      echo "___ ______________________________ ___"
      bind -v | grep 'on$'
      echo "___ ______________________________ ___"
      bind -v | grep 'off$'
      echo "___ ______________________________ ___"
      bind -v | grep -v 'on$\|off$'
      )
  }

  # UNCOMMENT following line to automatically generate an .inputrc file
  # if none exists. Iy you don't know what it is, YOU ARE MISSING SOMETHING !!

  #[ ! -f ~/.inputrc ] && inputrcGenerate --quiet --frombashrc # build inputrc if it doesn't yet exist
