#!/bin/bash

# Thiết lập VNC server
vncserver :1
echo -e "#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup
vncserver -kill :1
vncserver :1

# Clone noVNC
git clone https://github.com/novnc/noVNC.git ~/noVNC
chmod +x ~/noVNC/utils/novnc_proxy

# Chạy noVNC
~/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &
