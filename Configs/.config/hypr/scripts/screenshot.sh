#!/usr/bin/env sh

# Restores the shader after screenhot has been taken
restore_shader() {
	if [ -n "$shader" ]; then
		hyprshade on "$shader"
	fi
}

# Saves the current shader and turns it off
save_shader() {
	shader=$(hyprshade current)
	hyprshade off
	trap restore_shader EXIT
}

save_shader # Saving the current shader

if [ -z "$XDG_PICTURES_DIR" ]; then
	XDG_PICTURES_DIR="$HOME/Pictures"
fi

ScrDir=$(dirname "$(realpath "$0")")
source $ScrDir/globalcontrol.sh
swpy_dir="${XDG_CONFIG_HOME:-$HOME/.config}/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"

mkdir -p $save_dir
mkdir -p $swpy_dir
echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" >$swpy_dir/config

function print_error
{
	cat <<"EOF"
    ./screenshot.sh <action>
    ...valid actions are...
        p : print all screens
        s : snip current screen
        sf : snip current screen (frozen)
        m : print focused monitor
EOF
}

mathpix() {
    result=$(curl -X POST https://api.mathpix.com/v3/text \
    -H 'content-type: application/json' \
    -H 'app_id: your-app-id' \
    -H 'app_key: your-app-key' \
    -d '{
        "src": "data:image/jpeg;base64,'$(base64 -w 0 $1)'",
        "formats": ["text", "latex_styled"]
    }' | jq -r '.latex_styled')
    echo $result | wl-copy
    notify-send -t 5000 "Mathpix snip: $result"
}

pix2mixed() {
	result=$($ScrDir/latex_ocr.py mixed $1)
	echo $result | wl-copy
    notify-send -t 5000 "Pix2text: $result"
}

pix2formula() {
	result=$($ScrDir/latex_ocr.py formula $1)
	echo $result | wl-copy
    notify-send -t 5000 "Pix2text: $result"
}


case $1 in
p) # print all outputs
	grimblast copysave screen $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
s) # drag to manually snip an area / click on a window to print it
	grimblast copysave area $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
sf) # frozen screen, drag to manually snip an area / click on a window to print it
	grimblast --freeze copysave area $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
m) # print focused monitor
	grimblast copysave output $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
mathpix)
	grimblast copysave area $temp_screenshot && restore_shader && mathpix $temp_screenshot ;;
pix2mixed)
	grimblast copysave area $temp_screenshot && restore_shader && pix2mixed $temp_screenshot ;;
pix2formula)
	grimblast copysave area $temp_screenshot && restore_shader && pix2formula $temp_screenshot ;;
*) # invalid option
	print_error ;;
esac

rm "$temp_screenshot"

if [ -f "$save_dir/$save_file" ]; then
	dunstify "t1" -a "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi
