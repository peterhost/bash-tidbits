# check if 'ag' (the SIlver Finder) is installed on the system
ag --help >/dev/null 2>&1
[ 0 = $? ] && [ -d "$HOME/Dropbox/notesy/" ] && {
    export __notesearch=

    # search markdown notes, print ordered list, keep that in ENV variable
    function nvs() {
        local searchword="$@"
        export __notesearch="$(ag -i -l $searchword "$HOME/Dropbox/notesy/")";
        ag -i -l "$searchword" "$HOME/Dropbox/notesy/" | nl
    }

    function nvs_without_linenumbers() {
        local searchword="$@"
        export __notesearch="$(ag -i -l $searchword "$HOME/Dropbox/notesy/")";
        ag -i -l "$searchword" "$HOME/Dropbox/notesy/"
    }

    # open note of said number in latest nvs search, in vim
    function nvo() {
        [ -n "$__notesearch" ] && {
            local i=""
            local __i=0
            local __found=0

            while read -r i; do
                __i=$((__i + 1))
                [ "$__i" -eq "$1" ] && {
                    __found=1
                    break

                }
            done <<< "$__notesearch"
            [ "$__found" -eq "0" ] && {
                echo $__R_"Index $__i not found in previous nvs search"$__NN_
            } || {
                    echo $__C_"opening file $__EMC_$__i$__NN_$__C_ from previous nvs search :  $__EMC_$i"$__NN_

                    # if Goyo and **** are installed for vim markdown, we open the file with those modules loaded
                    # else we open it plain
                    [ -d ~/.vim/bundle/goyo.vim/ ] && {
                        echo "vim -c "Goyo" "$HOME/Dropbox/notesy/$i""
                        vim -c "Goyo" "$i"
                    } || {
                        vim "$i"
                    }
            }
        } || echo $__R_"no previous nvs search yet"$__NN_
    }






    function nv() {
        local ncol=
        local nlines=

        sttysize=$(stty size 2>/dev/null)
        [ $? -eq 0 ]  && {
            nlines=${sttysize%% *}
            ncol=${sttysize##* }
        } || {
            nlines=$(tput lines);
            ncol=$(tput cols);
        }


        local highlight=
        local alllines=
        local totlines=
        local firstline=
        local searchstring=
        local specialkey=
        local nvs=
        local char=
        local length=0
        local firstL=0
        local firstC=0
        local curL=$((firstL + 2))
        local listzone_top=2                  # first line of the list zone
        local listzone_bottom=$((nlines - 3)) # last line of the list zone
        local listzone_height=$((listzone_bottom - listzone_top)) # height of the list zone

        local blankline="$(head -c $((ncol)) < /dev/zero | tr '\0' ' ')"

        local top_line_text="ESC = quit | ENTER = prompt for filenumber to open | TYPING = augment fuzzy search string"
        local top_line_text_len_with_nonansi=$(echo "$top_line_text" | wc -c)
        # strip non-ansii chars from length
        local top_line_text_len=$(printf "%s" "$top_line_text_len_with_nonansi" | perl -pe 's/\e\[?.*?[\@-~]//g');
        local top_line_minus_text=

        local bottom_line_prompt="search for :"
        local bottom_line_prompt_len=$(echo "$bottom_line_prompt" | wc -c)
        local bottom_line_minus_prompt=

        # initialise bottom line zone
        bottom_line_minus_prompt="$(head -c $((ncol - bottom_line_prompt_len)) < /dev/zero | tr '\0' ' ')"
        # generate a '$ncol' long '_' string
        underscore_bottom_line="$(head -c $ncol < /dev/zero | tr '\0' '_')"
        # initialise top line zone
        underscore_top_line="$(head -c $ncol < /dev/zero | tr '\0' '_')"
        top_line_minus_text="$(head -c $((ncol - top_line_text_len)) < /dev/zero | tr '\0' ' ')"




        # INUTILE ??
        tput sc; # Save current cursor position

        # save, clear screen
        tput smcup
        clear


        # BUILD INITIAL UI

        # > BLANK top line
        tput cup $((firstL + 0)) $firstC;
        printf $__RV_$__W_"%s"$__NN_ "$top_line_text"
        printf $__RV_$__W_"%s"$__NN_ "$top_line_minus_text"
        tput cup $((firstL + 1)) $firstC;
        printf $__RV_$__W_"%s"$__NN_ "$underscore_top_line"

        # > BLANK bottom line
        tput cup $((firstL + nlines - 2)) $firstC;
        printf $__K_"%s"$__NN_ "$underscore_bottom_line"
        tput cup $((firstL + nlines)) $firstC;
        printf $__RV_$__G_"%s" "$bottom_line_prompt"
        printf $__RV_$__C_"%s"$__NN_ "$bottom_line_minus_prompt"


        # MAIN LOOP
        while IFS= read -r -s -n 1 char; do

            # Detect special keys
            specialkey=
            case $char in
                $'\e') echo $__Y_"search aborted"$__NN_; break;;                                            # exit on escape
                $'\177') specialkey="backspace"; length=$((length - 1)); searchstring=${searchstring::-1};; # trim searchstring on backspace
                'J') specialkey="down";;                                                                    # select line under
                'K') specialkey="up";;                                                                      # select line above
                '')  specialkey="enter";;                                                                   # select line above
            esac

            case $specialkey in
                'backspace')
                    # Reset bottom prompt
                    tput cup $((firstL + nlines)) $firstC;
                    printf $__RV_$__G_"%s" "$bottom_line_prompt"
                    printf $__RV_$__C_"%s"$__NN_ "$bottom_line_minus_prompt"
                    ;;
                'enter')
                    # ENTER key
                    local file="$(getline $highlight "$alllines")"

                    vim -c "Goyo" "$file"
                    #continue
                    ;;
                'down')
                    # > MOVE HIGHLIGHT DOWN
                    [ "$highlight" -eq "$totlines" ] && continue
                    highlight=$((highlight + 1))
                    thisline="$highlight $(getline $highlight "$alllines")";
                    thisprevline="$((highlight - 1)) $(getline $((highlight - 1)) "$alllines")";
                    tput cup $((listzone_top + highlight - 1 )) $((firstC + 1));
                    printf $__NN_"%s"$__NN_ "$thisprevline"
                    tput cup $((listzone_top + highlight )) $((firstC + 1));
                    printf $__RV_$__Y_"%s"$__NN_ "$thisline"
                    continue
                    ;;
                'up')
                    # > MOVE HIGHLIGHT UP
                    [ "$highlight" -eq "1" ] && continue
                    highlight=$((highlight - 1))
                    thisline="$highlight $(getline $highlight "$alllines")";
                    thisprevline="$((highlight + 1)) $(getline $((highlight + 1)) "$alllines")";
                    tput cup $((listzone_top + highlight + 1 )) $((firstC + 1));
                    printf $__NN_"%s"$__NN_ "$thisprevline"
                    tput cup $((listzone_top + highlight )) $((firstC + 1));
                    printf $__RV_$__Y_"%s"$__NN_ "$thisline"
                    continue
                    ;;
                *)
                    # Refine fuzzy search
                    length=$((length + 1))
                    searchstring=$searchstring$char
                    ;;
            esac

            # REFINE FUZZYSEARCH and RESET HIGHLIGHT
            highlight=1



            # print searchstring as it is augmented
            #tput cup $((firstL + nlines)) $((firstC + length));
            ##tput cup $firstL $((firstC + length));
            #printf $__RV_$__C_"%s"$__NN_ $char

            # > UPDATE bottom line prompt
            tput cup $((firstL + nlines)) $firstC;
            printf $__RV_$__G_"%s"$__RV_$__C_"%s"$__NN_ "$bottom_line_prompt" " $searchstring"

            # blank list zone before refresh
            blankzone $listzone_top $listzone_bottom "$blankline"

            # print fuzzysearch result
            tput cup $((firstL + 2)) $((firstC + 1));
            nvs=$(nvs_without_linenumbers "$searchstring")
            firstline=
            totlines=0
            alllines=
            while read -r line; do
                [ -z "$line" ] && continue # skip blank lines
                curL=$((curL + 1))
                totlines=$((totlines + 1))

                # CUT LIST if it overflows the list zone
                [ "$curL" -gt "$listzone_bottom" ] && break
                alllines="$(echo "$alllines"; echo $line)"  # augment the line buffer used for highlight
                                                            # DIFFERENT from $nvs !
                tput cup $curL $((firstC + 1));
                printf "%s" "$curL $line"

                # memorize the first line for highlight
                [ -z "$firstline" ] && firstline="$line"

            done <<< "$nvs"
            # reset curL
            curL=$((firstL + 2))

            # > UPDATE HIGHLIGHT
            tput cup $((listzone_top + highlight )) $((firstC + 1));
            #printf $__RV_$__Y_"%s"$__NN_ $firstline
            printf $__RV_$__Y_"%s"$__NN_ "$highlight $(getline $highlight "$alllines")";

            #printf "%s" "$searchstring"
            #printf "%s" $char
        done



        # restore
        tput rmcup

        # INUTILE ??
        tput rc;
    }

    function getline() {

        local nb=$1
        local alllines="$2"
        local i=0
        local lastline=

        while read -r line; do
            [ -z "$line" ] && continue # skip blank lines
            i=$((i + 1))
            lastline="$line"
            [ "$i" -eq "$nb" ] && break
        done <<< "$alllines"

        echo "$lastline"

        echo "_______________________" > toto.txt
        echo "$alllines" >> toto.txt
        echo "nb=$nb" >> toto.txt
        echo "i=$i" >> toto.txt
        echo "line=$lastline" >> toto.txt

    }

    function blankzone() {
        local top=$1
        local bottom=$2
        local blankstring=$3
        local i=
        for (( i=$top; i<=$bottom; i++ )); do
            tput cup $i 0;
            printf "%s" "$blankstring"
        done
    }


}
