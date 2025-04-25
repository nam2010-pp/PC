#!/bin/bash

echo "[+] Cài gói cần thiết..."
apt update -y && apt install -y \
  xfce4 xfce4-goodies tightvncserver x11vnc \
  firefox novnc websockify wget curl -y

echo "[+] Cài Cloudflared..."
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
dpkg -i cloudflared-linux-amd64.deb || apt --fix-broken install -y

echo "[+] Cấu hình XFCE4 cho VNC..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Tạo shortcut Firefox..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/firefox.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Firefox
Exec=firefox %u
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
EOF
chmod +x ~/.local/share/applications/firefox.desktop

echo "[+] Khởi tạo VNC session..."
vncserver :19 && vncserver -kill :19

echo "[+] Khởi động x11vnc và websockify..."
x11vnc -display :19 -forever -nopw -bg
websockify --web=/usr/share/novnc/ 6080 localhost:5919 &

echo "[+] Mở Cloudflare Tunnel..."
cloudflared tunnel --url http://localhost:6080 --no-autoupdate > log.txt 2>&1 &

echo "[✓] Đợi tạo link công khai..."
sleep 10
cat log.txt | grep -o 'https://[a-zA-Z0-9.-]*trycloudflare.com'
echo "[✓] Truy cập VNC qua noVNC tại link trên: /vnc.html"
