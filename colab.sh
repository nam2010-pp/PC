#!/bin/bash

set -e

echo "[+] Đang cập nhật hệ thống..."
apt update && apt install -y xfce4 xfce4-goodies tightvncserver x11vnc novnc websockify wget curl xterm supervisor

echo "[+] Cài Firefox thủ công (không dùng snap)..."
mkdir -p /opt/firefox
wget -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
tar -xjf /tmp/firefox.tar.bz2 -C /opt/firefox --strip-components=1
ln -sf /opt/firefox/firefox /usr/local/bin/firefox
rm /tmp/firefox.tar.bz2

echo "[+] Cài Cloudflared..."
wget -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared
mv cloudflared /usr/local/bin/

echo "[+] Thiết lập VNC Server..."
mkdir -p ~/.vnc
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Khởi tạo VNC lần đầu..."
vncserver :1 && vncserver -kill :1

echo "[+] Bắt đầu x11vnc + noVNC + Cloudflared..."
DISPLAY=:1 x11vnc -display :1 -rfbport 5919 -forever -nopw -bg
websockify --web=/usr/share/novnc/ 8090 localhost:5919 &

# Mở cổng 8090 ra ngoài qua Cloudflared
cloudflared tunnel --url http://localhost:8090 --no-autoupdate
