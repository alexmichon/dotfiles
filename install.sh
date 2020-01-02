#!/bin/sh

contains () {
    local list=$1[@]
    local elem=$2

    for i in "${!list}"
    do
        if [ "$i" == "${elem}" ] ; then
            return 0
        fi
    done

    return 1
}

confirm () {
    while true
    do
        read -r -p "Overwrite $HOME/$1? [Y/n] " input

        case $input in
            [yY][eE][sS]|[yY])
                return 0
                ;;
            [nN][oO]|[nN])
                return 1
                ;;
            *)
                echo "Invalid input..."
                ;;
        esac
    done
}

exclude_files=(".git" "install.sh")

script_path=$(realpath $(dirname "$0"))

echo "$script_path"

shopt -s dotglob
for file in "$script_path"/*; do
    filename=${file##"$script_path/"}
    if contains exclude_files "$filename"; then
        continue
    fi
    if [[ -f "$HOME/$filename" ]]; then
        if ! confirm "$filename"; then
            continue
        fi
    fi
    ln -sf $file $HOME/$filename
done
