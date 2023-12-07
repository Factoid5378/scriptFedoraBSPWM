#!/bin/bash

# Verificar si el usuario tiene privilegios de sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta el script con privilegios de superusuario."
  exit 1
fi

# Instalar BSPWM, SXHKD, feh, Rofi, Alacritty y Neofetch con DNF
dnf install -y bspwm sxhkd feh rofi alacritty neofetch picom polybar playerctl

# Crear directorios y archivos de configuración

mkdir "/home/iago/.config/bspwm"
mkdir "/home/iago/.config/sxhkd"
mkdir "/home/iago/.config/rofi"
mkdir "/home/iago/.config/alacritty"
mkdir "/home/iago/Imágenes/wallpaper"
mkdir "/home/iago/.config/picom"
mkdir "/home/iago/.config/polybar"
mkdir "/home/iago/.config/neofetch"

# Configurar bspwmrc
sudo cat <<EOL > /home/iago/.config/bspwm/bspwmrc
#!/bin/bash

bspc config split_ratio 0.52
sxhkd &
bspc config borderless_monocle true
bspc config window_gap 4
bspc config border_width 2
bspc config normal_border_color "#313244"
bspc config focused_border_color "#7f849c"
bspc config border_radius 10
bspc config border_style none
bspc monitor -d 1 2 3 4 5 6 7 8 9

# Verificar si existe el directorio de wallpapers
if [ ! -d ~/Imágenes/wallpaper ]; then
  echo "Crea el directorio ~/Imágenes/wallpaper y guarda tus fondos de pantalla allí con el nombre 'image.jpg'."
else
  feh --bg-fill ~/Imágenes/wallpaper/image.jpg
fi

picom -b
polybar
EOL

# Configurar sxhkdrc
sudo cat <<EOL > /home/iago/.config/sxhkd/sxhkdrc
#apagar sistema operativo
ctrl + alt + p
	systemctl poweroff
# windows + enter terminal
super + Return
	alacritty
# windows + s firefox
super + s
	firefox
# windows + w cerrar ventana
super + w
	bspc node -c
# reiniciar sistema
ctrl + alt  + k
	systemctl reboot
# cambiar ventana derecha windows + flecha derecha
super + Right
	bspc node -f east
# cambiar ventana izquierda windows + flecha izquierda
super + Left
	bspc node -f west
# cambiar ventana arriba windows + flecha arriba
super + Up
	bspc node -f north
# cambiar ventana abajo windows + flecha abajo
super + Down
	bspc node -f south
# ctrl + izquierda aumentar /disminuir tamaño ventana
ctrl + Left
	bspc node -z left -70 0 || bspc node -z right -70 0
# ctrl + derecha aumentar /disminuir tamaño ventana
ctrl + Right
	bspc node -z right 70 0 || bspc node -z left 70 0

# ctrl + arriba aumentar /disminuir tamaño ventana
ctrl + Up
	bspc node -z top 0 -70 || bspc node -z bottom 0 -70
# ctrl + abajo aumentar /disminuir tamaño ventana
ctrl + Down
	bspc node -z bottom 0 70 || bspc node -z top 0 70
# windows + espacio cambiar de bspwm a ventanas flotantes
super + space
	bspc node -t {tiled,floating}
# windows + numero cambiar de escritorio del 1 al 9
super + {1-9}
	bspc desktop -f ^{1-9}
# Windows + Alt + q para hacer log out
super + alt + q
    bspc quit
# Mover la ventana actual al escritorio especificado
ctrl + super + {1-9}
    bspc node -d '^{1-9}'
# abrir rofi
super + d
    rofi -show drun
# Bajar volumen
XF86AudioLowerVolume
    amixer -q sset Master 5%-
# Subir volumen
XF86AudioRaiseVolume
    amixer -q sset Master 5%+
# Mutear
XF86AudioMute
    amixer -q sset Master toggle
EOL

# Configurar la configuración de Rofi
sudo cat <<EOL > /home/iago/.config/rofi/config.rasi
configuration {
  display-drun: "Applications:";
  display-window: "Windows:";
  drun-display-format: "{name}";
  font: "JetBrainsMono Nerd Font Medium 10";
  modi: "window,run,drun";
 
  // enabling the icons
  show-icons: true;
  icon-theme: "Papirus";
}

@theme "/dev/null"

* {
  bg: #1e1e2e66;
  bg-alt: #585b7066;
  bg-selected: #31324466;

  fg: #cdd6f4;
  fg-alt: #7f849c;

 
  border: 0;
  margin: 0;
  padding: 0;
  spacing: 0;
}

window {
  width: 30%;
  background-color: @bg;
}

element {
  padding: 8 12;
  background-color: transparent;
  text-color: @fg-alt;
}

element selected {
  text-color: @fg;
  background-color: @bg-selected;
}

element-text {
  background-color: transparent;
  text-color: inherit;
  vertical-align: 0.5;
}

element-icon {
  size: 14;
  padding: 0 10 0 0;
  background-color: transparent;
}

entry {
  padding: 12;
  background-color: @bg-alt;
  text-color: @fg;
}

inputbar {
  children: [prompt, entry];
  background-color: @bg;
}

listview {
  background-color: @bg;
  columns: 1;
  lines: 10;
}

mainbox {
  children: [inputbar, listview];
  background-color: @bg;
}

prompt {
  enabled: true;
  padding: 12 0 0 12;
  background-color: @bg-alt;
  text-color: @fg;
}
EOL

# Configurar la configuración de Alacritty
sudo cat <<EOL > /home/iago/.config/alacritty/alacritty.yml
colors:
  # Default colors
  primary:
    background: '0x1b182c'
    foreground: '0xcbe3e7'

  # Normal colors
  normal:
    black:   '0x100e23'
    red:     '0xff8080'
    green:   '0x95ffa4'
    yellow:  '0xffe9aa'
    blue:    '0x91ddff'
    magenta: '0xc991e1'
    cyan:    '0xaaffe4'
    white:   '0xcbe3e7'

  # Bright colors
  bright:
    black:   '0x565575'
    red:     '0xff5458'
    green:   '0x62d196'
    yellow:  '0xffb378'
    blue:    '0x65b2ff'
    magenta: '0x906cff'
    cyan:    '0x63f2f1'
    white:   '0xa6b3cc'
font:
  normal:
    family: FiraCode Nerd Font
    size: 16
shell:
  program: bash
  args:
    - --login
    - -c
    - |
      neofetch
      exec /bin/bash
EOL
sudo cat <<EOL > /home/iago/.config/neofetch/config.conf

# See this wiki page for more info:
# https://github.com/dylanaraps/neofetch/wiki/Customizing-Info
print_info() {
    info title
    info underline

    info "Kernel" kernel
    info "Uptime" uptime
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory

    # info "GPU Driver" gpu_driver  # Linux/macOS only
    # info "CPU Usage" cpu_usage
    # info "Disk" disk
    info "Battery" battery
    # info "Font" font
    # info "Song" song
    # [[ "$player" ]] && prin "Music Player" "$player"
     info "Local IP" local_ip
    # info "Public IP" public_ip
     info "Users" users
    # info "Locale" locale  # This only works on glibc systems.

    info cols
}

# Title


# Hide/Show Fully qualified domain name.
#
# Default:  'off'
# Values:   'on', 'off'
# Flag:     --title_fqdn
title_fqdn="off"


# Kernel


# Shorten the output of the kernel function.
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --kernel_shorthand
# Supports: Everything except *BSDs (except PacBSD and PC-BSD)
#
# Example:
# on:  '4.8.9-1-ARCH'
# off: 'Linux 4.8.9-1-ARCH'
kernel_shorthand="on"


# Distro


# Shorten the output of the distro function
#
# Default:  'off'
# Values:   'on', 'tiny', 'off'
# Flag:     --distro_shorthand
# Supports: Everything except Windows and Haiku
distro_shorthand="off"

# Show/Hide OS Architecture.
# Show 'x86_64', 'x86' and etc in 'Distro:' output.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --os_arch
#
# Example:
# on:  'Arch Linux x86_64'
# off: 'Arch Linux'
os_arch="on"


# Uptime


# Shorten the output of the uptime function
#
# Default: 'on'
# Values:  'on', 'tiny', 'off'
# Flag:    --uptime_shorthand
#
# Example:
# on:   '2 days, 10 hours, 3 mins'
# tiny: '2d 10h 3m'
# off:  '2 days, 10 hours, 3 minutes'
uptime_shorthand="on"


# Memory


# Show memory pecentage in output.
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --memory_percent
#
# Example:
# on:   '1801MiB / 7881MiB (22%)'
# off:  '1801MiB / 7881MiB'
memory_percent="off"

# Change memory output unit.
#
# Default: 'mib'
# Values:  'kib', 'mib', 'gib'
# Flag:    --memory_unit
#
# Example:
# kib  '1020928KiB / 7117824KiB'
# mib  '1042MiB / 6951MiB'
# gib: ' 0.98GiB / 6.79GiB'
memory_unit="mib"


# Packages


# Show/Hide Package Manager names.
#
# Default: 'tiny'
# Values:  'on', 'tiny' 'off'
# Flag:    --package_managers
#
# Example:
# on:   '998 (pacman), 8 (flatpak), 4 (snap)'
# tiny: '908 (pacman, flatpak, snap)'
# off:  '908'
package_managers="on"


# Shell


# Show the path to $SHELL
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --shell_path
#
# Example:
# on:  '/bin/bash'
# off: 'bash'
shell_path="off"

# Show $SHELL version
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --shell_version
#
# Example:
# on:  'bash 4.4.5'
# off: 'bash'
shell_version="on"


# CPU


# CPU speed type
#
# Default: 'bios_limit'
# Values: 'scaling_cur_freq', 'scaling_min_freq', 'scaling_max_freq', 'bios_limit'.
# Flag:    --speed_type
# Supports: Linux with 'cpufreq'
# NOTE: Any file in '/sys/devices/system/cpu/cpu0/cpufreq' can be used as a value.
speed_type="bios_limit"

# CPU speed shorthand
#
# Default: 'off'
# Values: 'on', 'off'.
# Flag:    --speed_shorthand
# NOTE: This flag is not supported in systems with CPU speed less than 1 GHz
#
# Example:
# on:    'i7-6500U (4) @ 3.1GHz'
# off:   'i7-6500U (4) @ 3.100GHz'
speed_shorthand="off"

# Enable/Disable CPU brand in output.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --cpu_brand
#
# Example:
# on:   'Intel i7-6500U'
# off:  'i7-6500U (4)'
cpu_brand="on"

# CPU Speed
# Hide/Show CPU speed.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --cpu_speed
#
# Example:
# on:  'Intel i7-6500U (4) @ 3.1GHz'
# off: 'Intel i7-6500U (4)'
cpu_speed="on"

# CPU Cores
# Display CPU cores in output
#
# Default: 'logical'
# Values:  'logical', 'physical', 'off'
# Flag:    --cpu_cores
# Support: 'physical' doesn't work on BSD.
#
# Example:
# logical:  'Intel i7-6500U (4) @ 3.1GHz' (All virtual cores)
# physical: 'Intel i7-6500U (2) @ 3.1GHz' (All physical cores)
# off:      'Intel i7-6500U @ 3.1GHz'
cpu_cores="logical"

#
# Example:
# C:   'Intel i7-6500U (4) @ 3.1GHz [27.2°C]'
# F:   'Intel i7-6500U (4) @ 3.1GHz [82.0°F]'
# off: 'Intel i7-6500U (4) @ 3.1GHz'
cpu_temp="off"


# GPU


# Enable/Disable GPU Brand
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --gpu_brand
#
# Example:
# on:  'AMD HD 7950'
# off: 'HD 7950'
gpu_brand="on"

# Which GPU to display
#
# Default: 'all'
# Values:  'all', 'dedicated', 'integrated'
# Flag:    --gpu_type
# Supports: Linux
#
# Example:
# all:
#   GPU1: AMD HD 7950
#   GPU2: Intel Integrated Graphics
#
# dedicated:
#   GPU1: AMD HD 7950
#
# integrated:
#   GPU1: Intel Integrated Graphics
gpu_type="all"


# Resolution


# Display refresh rate next to each monitor
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --refresh_rate
# Supports: Doesn't work on Windows.
#
# Example:
# on:  '1920x1080 @ 60Hz'
# off: '1920x1080'
refresh_rate="off"


# Gtk Theme / Icons / Font


# Shorten output of GTK Theme / Icons / Font
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --gtk_shorthand
#
# Example:
# on:  'Numix, Adwaita'
# off: 'Numix [GTK2], Adwaita [GTK3]'
gtk_shorthand="off"


# Enable/Disable gtk2 Theme / Icons / Font
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --gtk2
#
# Example:
# on:  'Numix [GTK2], Adwaita [GTK3]'
# off: 'Adwaita [GTK3]'
gtk2="on"

# Enable/Disable gtk3 Theme / Icons / Font
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --gtk3
#
# Example:
# on:  'Numix [GTK2], Adwaita [GTK3]'
# off: 'Numix [GTK2]'
gtk3="on"


# IP Address


# Website to ping for the public IP
#
# Default: 'http://ident.me'
# Values:  'url'
# Flag:    --ip_host
public_ip_host="http://ident.me"

# Public IP timeout.
#
# Default: '2'
# Values:  'int'
# Flag:    --ip_timeout
public_ip_timeout=2


# Desktop Environment


# Show Desktop Environment version
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --de_version
de_version="on"


disk_subtitle="mount"

# Disk percent.
# Show/Hide disk percent.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --disk_percent
#
# Example:
# on:  'Disk (/): 74G / 118G (66%)'
# off: 'Disk (/): 74G / 118G'
disk_percent="on"



music_player="auto"

# Format to display song information.
#
# Default: '%artist% - %album% - %title%'
# Values:  '%artist%', '%album%', '%title%'
# Flag:    --song_format
#
# Example:
# default: 'Song: Jet - Get Born - Sgt Major'
song_format="%artist% - %album% - %title%"

# Print the Artist, Album and Title on separate lines
#
# Default: 'off'
# Values:  'on', 'off'
# Flag:    --song_shorthand
#
# Example:
# on:  'Artist: The Fratellis'
#      'Album: Costello Music'
#      'Song: Chelsea Dagger'
#
# off: 'Song: The Fratellis - Costello Music - Chelsea Dagger'
song_shorthand="off"

# 'mpc' arguments (specify a host, password etc).
#
# Default:  ''
# Example: mpc_args=(-h HOST -P PASSWORD)
mpc_args=()


# Text Colors


# Text Colors
#
# Default:  'distro'
# Values:   'distro', 'num' 'num' 'num' 'num' 'num' 'num'
# Flag:     --colors
#
# Each number represents a different part of the text in
# this order: 'title', '@', 'underline', 'subtitle', 'colon', 'info'
#
# Example:
# colors=(distro)      - Text is colored based on Distro colors.
# colors=(4 6 1 8 8 6) - Text is colored in the order above.
colors=(distro)


# Text Options


# Toggle bold text
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --bold
bold="on"

# Enable/Disable Underline
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --underline
underline_enabled="on"

# Underline character
#
# Default:  '-'
# Values:   'string'
# Flag:     --underline_char
underline_char="-"


# Info Separator
# Replace the default separator with the specified string.
#
# Default:  ':'
# Flag:     --separator
#
# Example:
# separator="->":   'Shell-> bash'
# separator=" =":   'WM = dwm'
separator=":"


# Color Blocks


# Color block range
# The range of colors to print.
#
# Default:  '0', '15'
# Values:   'num'
# Flag:     --block_range
#
# Example:
#
# Display colors 0-7 in the blocks.  (8 colors)
# neofetch --block_range 0 7
#
# Display colors 0-15 in the blocks. (16 colors)
# neofetch --block_range 0 15
block_range=(0 15)

# Toggle color blocks
#
# Default:  'on'
# Values:   'on', 'off'
# Flag:     --color_blocks
color_blocks="on"

# Color block width in spaces
#
# Default:  '3'
# Values:   'num'
# Flag:     --block_width
block_width=3

# Color block height in lines
#
# Default:  '1'
# Values:   'num'
# Flag:     --block_height
block_height=1


# col_offset=7      - Leave 7 spaces then print the colors
col_offset="auto"

# Progress Bars



bar_char_elapsed="-"
bar_char_total="="


bar_border="on"

# Progress bar length in spaces
# Number of chars long to make the progress bars.
#
# Default:  '15'
# Values:   'num'
# Flag:     --bar_length
bar_length=15

bar_color_elapsed="distro"
bar_color_total="distro"



cpu_display="off"
memory_display="off"
battery_display="off"
disk_display="off"


# Backend Settings



image_backend="ascii"

# Image Source
#
# Which image or ascii file to display.
#
# Default:  'auto'
# Values:   'auto', 'ascii', 'wallpaper', '/path/to/img', '/path/to/ascii', '/path/to/dir/'

# Flag:     --source
#
# NOTE: 'auto' will pick the best image source for whatever image backend is used.
#       In ascii mode, distro ascii art will be used and in an image mode, your
#       wallpaper will be used.
image_source="auto"


# Ascii Options



ascii_distro="auto"


ascii_colors=(distro)

# Bold ascii logo
# Whether or not to bold the ascii logo.
#
# Default: 'on'
# Values:  'on', 'off'
# Flag:    --ascii_bold
ascii_bold="on"


# Image Options


# Image loop
# Setting this to on will make neofetch redraw the image constantly until
# Ctrl+C is pressed. This fixes display issues in some terminal emulators.
#
# Default:  'off'
# Values:   'on', 'off'
# Flag:     --loop
image_loop="off"

# Thumbnail directory
#
# Default: '~/.cache/thumbnails/neofetch'
# Values:  'dir'
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"

# Crop mode
#
# Default:  'normal'
# Values:   'normal', 'fit', 'fill'
# Flag:     --crop_mode
#
# See this wiki page to learn about the fit and fill options.
# https://github.com/dylanaraps/neofetch/wiki/What-is-Waifu-Crop%3F
crop_mode="normal"

# Crop offset
# Note: Only affects 'normal' crop mode.
#
# Default:  'center'
# Values:   'northwest', 'north', 'northeast', 'west', 'center'
#           'east', 'southwest', 'south', 'southeast'
# Flag:     --crop_offset
crop_offset="center"

# Image size
# The image is half the terminal width by default.
#
# Default: 'auto'
# Values:  'auto', '00px', '00%', 'none'
# Flags:   --image_size
#          --size
image_size="auto"

# Gap between image and text
#
# Default: '3'
# Values:  'num', '-num'
# Flag:    --gap
gap=3

# Image offsets
# Only works with the w3m backend.
#
# Default: '0'
# Values:  'px'
# Flags:   --xoffset
#          --yoffset
yoffset=0
xoffset=0

# Image background color
# Only works with the w3m backend.
#
# Default: ''
# Values:  'color', 'blue'
# Flag:    --bg_color
background_color=


# Misc Options

# Stdout mode
# Turn off all colors and disables image backend (ASCII/Image).
# Useful for piping into another command.
# Default: 'off'
# Values: 'on', 'off'
stdout="off"

EOL

sudo cat <<EOL > /home/iago/.config/picom/picom.conf

# Opacity
active-opacity = 1;
inactive-opacity = 1;
frame-opacity = 1;
inactive-opacity-override = false;
blur-background = true;

blur-method = "dual_kawase";
blur-strength = 6;

# Fading
fading = true;
fade-delta = 4;
no-fading-openclose = false;

fade-exclude = [ ];

# Window type settings
wintypes:
{
		dock = {
				shadow = false;
		};
};

opacity-rule = [
    "90:class_g = 'Alacritty'",
    "100:class_g = 'rofi'"
];

xrender-sync-fence = true;
EOL
sudo cat <<EOL > /home/iago/.bashrc

PS1=' \[\033[1;33m\]\w\[\033[0m\]> '

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

EOL
sudo touch /home/iago/.config/polybar/config.ini
sudo chmod 777 /home/iago/.config/polybar/config.ini


nuevo_contenido=$(cat <<EOL 
[colors]
base = #1e1e2e
mantle = #181825
crust = #cc11111b

text = #cdd6f4
subtext0 = #a6adc8
subtext1 = #bac2de

surface0 = #313244
surface1 = #45475a
surface2 = #585b70

overlay0 = #6c7086
overlay1 = #7f849c
overlay2 = #9399b2


blue = #89b4fa
lavender = #b4befe
sapphire = #74c7ec
sky = #89dceb
teal = #94e2d5
green = #a6e3a1
yellow = #f9e2af
peach = #fab387
maroon = #eba0ac
red = #f38ba8
mauve = #cba6f7
pink = #f5c2e7
flamingo = #f2cdcd
rosewater = #f5e0dc

transparent = #FF00000

[bar/main]
width = 100%
height = 30
offset-y = 0
top = true
fixed-center = true

wm-restack = bspwm

override-redirect = false

scroll-up = next
scroll-down = prev

enable-ipc = true

background = ${colors.crust}
foreground = ${colors.text}

font-0 = "JetBrainsMono Nerd Font:style=Regular:size=10;2"
font-1 = "JetBrainsMono Nerd Font:style=Bold:size=10;2"
font-2 = "JetBrainsMono Nerd Font:size=19;5"
font-3 = "Material Icons Outlined:9;4"
font-4 = "Material Icons Round:9;4"
font-5 = "Source Han Sans CN:size=9;2"

modules-left = date nowplaying
modules-center = bspwm
modules-right = pulseaudio wlan eth battery ram cpu

tray-position = right

cursor-click = pointer


[settings]
screenchange-reload = true
format-padding = 1

[module/nowplaying]
type = custom/script
tail = true
interval = 1
format =  <label>
exec = playerctl metadata --format "{{ artist }} - {{ title }}"

[module/battery]
type = internal/battery
battery = BAT0
adapter = ADP1
full-at = 98
low-at = 30
format-full-prefix = 
format-full = <label-charging>
format-full-prefix-foreground = ${colors.sky}
format-charging-prefix = 
format-charging = <label-charging>
label-charging = %percentage:2%%
label-charging-padding = 1
format-charging-prefix-foreground = ${colors.sky}
format-discharging = <ramp-capacity><label-discharging>
label-discharging = %percentage%%
label-discharging-padding = 1
ramp-capacity-0 = ""
ramp-capacity-0-foreground = ${colors.red}
ramp-capacity-1 = ""
ramp-capacity-1-foreground = ${colors.sky}
ramp-capacity-2 = ""
ramp-capacity-2-foreground = ${colors.sky}
ramp-capacity-3 = ""
ramp-capacity-3-foreground = ${colors.sky}
ramp-capacity-4 = ""
ramp-capacity-4-foreground = ${colors.sky}
ramp-capacity-5 = ""
ramp-capacity-5-weight = 2
ramp-capacity-5-foreground = ${colors.sky}
format-low = <ramp-capacity><label-low>
label-low-padding = 1
label-low-foreground = ${colors.red}
poll-interval = 5

[module/bspwm]
type = internal/bspwm

format = <label-state> <label-mode>

label-focused = %index%
label-focused-foreground = ${colors.text}
label-focused-padding = 2

label-occupied = %index%
label-occupied-foreground = ${colors.overlay0}
label-occupied-padding = 2

label-urgent = %index%
label-urgent-foreground = ${colors.red}
label-urgent-padding = 2

label-empty = %index%
label-empty-foreground = ${colors.surface0}
label-empty-padding = 2

[module/date]
type = internal/date
interval = 1

time = "%d %b %H:%M"

format = <label>
format-padding = 1
format-prefix = %{T5}%{T-}
format-prefix-foreground = ${colors.green}
label = %{T1}%time%%{T-}
label-padding = 1

[module/session]
type = custom/text

click-left = powermenu
content = %{T4}%{T-}
content-background = ${colors.surface1}
content-foreground = ${colors.text}
content-padding = 1


[network-base]
type = internal/network
interval = 5
format-connected = <label-connected>
format-disconnected = <label-disconnected>
label-disconnected = %{F#F0C674}%ifname%%{F#707880} disconnected

[module/wlan]
inherit = network-base
interface-type = wireless
label-connected = %{F#F0C674}%ifname%%{F-} %essid% %local_ip%

[module/eth]
inherit = network-base
interface-type = wired
label-connected = %{F#90c1ff}  %{F#ffffff}%ifname% %{F#ffffff}%local_ip%

[module/updates]
type = custom/script
exec = dnf check-update | grep -v "^$"
interval = 7200

[module/cpu]
type = internal/cpu
interval = 2
format = %{F#F0C674}CPU: <label>

[module/ram]
type = internal/memory
interval = 2
format-prefix = "%{F#F08873}RAM: "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/pulseaudio]
type = internal/pulseaudio

format-volume-prefix = "VOL "
format-volume-prefix-foreground = ${colors.primary}
format-volume = <label-volume>

label-volume = %percentage%%

label-muted = muted
label-muted-foreground = ${colors.disabled}

EOL
)

echo "$nuevo_contenido" > /home/iago/.config/polybar/config.ini

# Dar permisos de ejecución a los archivos de configuración
sudo chmod +x /home/iago/.config/bspwm/bspwmrc
sudo chmod +x /home/iago/.config/sxhkd/sxhkdrc

# Dar permisos de escritura a los archivos de configuración de Rofi y Alacritty
sudo chmod 644 /home/iago/.config/rofi/config.rasi
sudo chmod 644 /home/iago/.config/alacritty/alacritty.yml

echo "BSPWM, SXHKD, feh, Rofi y Alacritty han sido instalados y configurados con tus preferencias. Reinicia tu sistema o inicia una nueva sesión para aplicar los cambios."
