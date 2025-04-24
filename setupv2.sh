#!/bin/bash

echo "[+] Cập nhật gói và cài xfce4, VNC, noVNC, Firefox..."
sudo apt update && sudo apt install -y \
  xfce4 xfce4-goodies x11vnc \
  tightvncserver firefox xterm git curl wget \
  python3-websockify

echo "[+] Tải noVNC chính chủ từ GitHub..."
git clone https://github.com/novnc/noVNC ~/noVNC
git clone https://github.com/novnc/websockify ~/noVNC/utils/websockify
chmod +x ~/noVNC/utils/novnc_proxy

echo "[+] Tạo file ~/.vnc/xstartup với XFCE4..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Tạo shortcut Firefox nếu chưa có..."
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/firefox.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Firefox
GenericName=Web Browser
Exec=firefox %u
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
chmod +x ~/.local/share/applications/firefox.desktop

echo "[+] Khởi tạo VNC lần đầu và kill để reset..."
vncserver :1 && vncserver -kill :1

echo "[+] Bắt đầu x11vnc + noVNC proxy..."
x11vnc -display :1 -forever -nopw -bg
DISPLAY=:1 ~/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 8080 &

echo "[✓] Xong rồi! Mở trình duyệt vào: http://localhost:8080/vnc.html"
