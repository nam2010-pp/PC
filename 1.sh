#!/bin/bash

# 1) Thiết lập môi trường để vncserver không báo lỗi USER
export USER=root
export HOME=/root
echo "[*] USER=\$USER, HOME=\$HOME"

# 2) Cài các gói cần thiết
apt update -y
DEBIAN_FRONTEND=noninteractive apt install -y \
  xfce4 xfce4-goodies tightvncserver x11vnc \
  firefox xterm wget unzip curl

# 3) Cài noVNC & websockify
mkdir -p ~/novnc && cd ~/novnc
wget -q https://github.com/novnc/noVNC/archive/refs/heads/master.zip
unzip -q master.zip && mv noVNC-master/* . && rm -rf master.zip noVNC-master
git clone https://github.com/novnc/websockify

# 4) Tạo file khởi động XFCE4 cho VNC
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

# 5) Khởi tạo VNC session trên :19 rồi kill để reset
echo "[*] Khởi tạo VNC trên display :19"
vncserver :19
sleep 2
vncserver -kill :19

# 6) Start lại VNC và noVNC
echo "[*] Bật x11vnc (port 5919) và websockify (port 8090)"
x11vnc -display :19 -rfbport 5919 -forever -nopw -bg
~/novnc/utils/novnc_proxy --vnc localhost:5919 --listen 8090 &

# 7) Tải bản binary Cloudflared (không qua dpkg)
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
chmod +x cloudflared

# 8) Mở public qua Cloudflared
echo "[*] Mở tunnel Cloudflare để public port 8090"
./cloudflared tunnel --url http://localhost:8090 --no-autoupdate > tunnel.log 2>&1 &

# 9) Đợi và hiện URL
sleep 8
echo "[✓] Link truy cập noVNC (XFCE4) với Cloudflared:"
grep -o 'https://.*trycloudflare.com' tunnel.log
echo "    Thêm '/vnc.html' vào cuối URL để mở giao diện"
