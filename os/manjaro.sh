sudo pacman-mirrors -c China

ARCH_CN=`cat /etc/pacman.conf | grep archlinuxcn|wc -l`
if [[ $ARCH_CN -eq 0 ]];then
   echo 123
   cat <<EOF  >> /etc/pacman.conf
[archlinuxcn]
SigLevel = Optional TrustedOnly
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
EOF
fi

sudo pacman -Syyu
sudo pacman -S yaourt
sudo pacman -S archlinuxcn-keyring
sudo pacman -S linux-header
sudo pacman -S broadcom-wl-dkms

sudo pacman -S deepin-terminal
sudo pacman -S vim
sudo pacman -S neovim
curl -o ~/.vimrc https://raw.githubusercontent.com/all3n/myvim/master/.vimrc.simple


# soft
sudo pacman -S simplescreenrecorder
sudo pacman -S screenkey

sudo pacman -S google-chrome
sudo pacman -S fcitx fcitx-configtool fcitx-im
sudo pacman -S fcitx-sogoupinyin


if [[ ! -f ~/.xprofile ]];then
    cat <<EOF  > ~/.xprofile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
EOF
fi



sed -i -e "s/#Color/Color/g" /etc/pacman.conf
if [[ "$SHELL" == "/usr/bin/fish" ]];then
    sudo pacman -S fish
    chsh -s `which fish`
    curl -L https://get.oh-my.fish | fish
    #fish_config
    #omf install wttr
fi


sudo pacman -S deepin.com.qq.office
sudo pacman -S electronic-wechat
sudo pacman -S screenfetch

sudo pacman -S wps-office
sudo pacman -S ttf-wps-fonts
sudo pacman -S typora
sudo pacman -S tmux
sudo pacman -S ranger

# linux photoshop
#sudo pacman -S gimp

