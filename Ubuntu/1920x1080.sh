#  Description:
#    Set 1920 x 1080 display for ubuntu desktop.
#  Author:
#    serveryang@qq.com

sudo cvt 1920 1080 60
sudo xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
sudo xrandr --addmode VBOX0 1920x1080_60.00
