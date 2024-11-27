alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

if [ -x /root/bin/cwd ]; then
        alias cwd='. /root/bin/cwd'
fi;

export VISUAL="vim"
export EDITOR="vim"

alias ls='ls --color=auto -a'

export HISTFILESIZE=-1
export HISTSIZE=-1

doplay ()
{
        awk -F= '$1 ~ /File/ { system(" mplayer " $2 " 2>&1")}' ${1} | grep -iPo --color "(?<=Streamtitle=')[^']+"
}

# Plus shiny bits to remotely display hostname on title bar
if [[ "${TERM}" != "linux" ]]; then
        export PS1='\[\033]2;\t ${STY##*.} \u@\h:\w\007\][\t ${STY##*.} \u@\h:\w]$ '
else
        export PS1='[\t ${STY##*.} \u@\h:\w]$ '
fi;
# Because we stuff pip and such in a local user installation.
# And we need our local stuff to override system stuff, basically always
export PATH=${HOME}/.local/bin:${HOME}/.local/games:${PATH}

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [[ "$(id -u)" -eq "0" ]]; then
  // TODO: Only on slackware
        removeoldpkg()
        {
                grep -i removed <(curl https://mirrors.slackware.com/slackware/slackware64-current/ChangeLog.txt) | sed -rn '/:/s|[^/]+/([^:]+).*|\1|p' | while read pkgname; do if [ -e /var/log/packages/${pkgname%%.t?z} ]; then echo removepkg ${pkgname}; else echo "${pkgname%%.t?z} not present on system"; fi; done;
        }
fi;

ictv_encode()
{
        nice -n 19 ffmpeg -i "$1" -i "${2}" -map 0 -map 1 -c:v libx264 -vf pullup -c:a libvorbis -q:a 6 -c:s copy -crf ${3:-23} -f matroska -tune ${4:-film} -preset veryslow -max_muxing_queue_size 9999 -aq-mode 3 ../converted/"$1";
}

encode()
{
        nice -n 19 ffmpeg -i "$1" -map 0 -c:v libx264 -c:a libvorbis -q:a 6 -c:s copy -crf ${2:-23} -f matroska -tune ${3:-film} -preset veryslow -max_muxing_queue_size 9999 -aq-mode 3 ${@:4} ../converted/"$1";
}

sub_encode()
{
        nice -n 19 ffmpeg -i "$1" -i "${2}" -map 0 -map 1 -c:v libx264  -c:a libvorbis -q:a 6 -c:s copy -crf ${3:-23} -f matroska -tune ${4:-film} -preset veryslow -max_muxing_queue_size 9999 -aq-mode 3 ${@:5} ../converted/"$1";
}

dvd_letterbox_crop_encode()
{
        nice -n 19 ffmpeg -i "$1" -map 0 -c:v libx264 -filter:v "crop=720:360:0:60"  -c:a libvorbis -q:a 6 -c:s copy -crf ${2:-23} -f matroska -tune ${3:-film} -preset veryslow -max_muxing_queue_size 9999 -aq-mode 3  ${@:3} ../converted/"$1";
}

readbook ()
{
        while [ $(udisks --show-info /dev/cdrom | grep -Po "has media:[ \t]+[0-9]" | grep -Po "[0-9]") -eq 0 ]; do sleep 1; done;
        cdparanoia "1-" "${1}-cd${2}.wav";
        eject /dev/sr0
}


if [[ -f ${HOME}/.cargo/env ]]; then
  . "${HOME}/.cargo/env"
fi;
