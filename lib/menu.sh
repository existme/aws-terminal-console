#!/bin/zsh

# Declare variables
menu_prompt="Select"
# "<b>hello user</b>&#x0A;select your action:"
menu_title_desc=""
#preferred_menu="dmenu"

# Define functions
menu_dmenu() {
    local res
    res=$(echo -e "$@" | dmenu -l 20 -b -nb '#02042f' -nf white -fn 'Ubuntu Mono:bold:pixelsize=22' -p "$menu_prompt")
    echo $res| cut -d' ' -f1
}

menu_rofi() {
    local res
    font="Ubuntu Mono 16"
#    font="FuraMono Nerd Font Regular 16"

    res=$(echo -e "$@" | rofi -markup -sep '\n' -p "$menu_prompt" -i  -e -mesg "$menu_title_desc" -markup-rows -dmenu -font $font -disable-history -levenshtein-sort -matching normal)
    echo $res
}

data_menu() {
    # See https://stackoverflow.com/a/75945264/161312
    local -A myOptions=(${(@Pkv)1})
    local option_list
    local selected_option

    # Generate option list
    option_list=$(for key in "${(@k)myOptions}"; do
        echo "${myOptions[$key]}"
    done)

    # Create reverse map
    local -A reverse_map
    for key in "${(@k)myOptions}"; do
        reverse_map[${myOptions[$key]}]=$key
    done

    # Call menu function
    selected_option=$(menu "$option_list")
    key=${reverse_map[$selected_option]}
    echo $key
}

menu() {
    # Check if Rofi or dmenu is available, install if not
    if ! command -v rofi &>/dev/null && ! command -v dmenu &>/dev/null; then
        echo "Rofi and dmenu are not available. Attempting to install..."
        sudo apt update && sudo apt install -y rofi dmenu || { echo "Failed to install Rofi and dmenu. Please install them manually to use the menu." && return 1; }
    fi

    # Determine preferred menu tool
    selected_menu="${preferred_menu:-rofi}"

    # Use preferred menu tool if set, otherwise default to rofi if available, otherwise dmenu
    if [[ "$selected_menu" == "rofi" && -x "$(command -v rofi)" ]]; then
        menu_rofi "$@"
    elif [[ "$selected_menu" == "dmenu" && -x "$(command -v dmenu)" ]]; then
        menu_dmenu "$@"
    else
        echo "Using default menu tool:"
        [[ -x "$(command -v rofi)" ]] && menu_rofi "$@" || menu_dmenu "$@"
    fi
}
