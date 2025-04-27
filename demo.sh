#!/bin/bash

echo "[+] Cập nhật gói và cài xfce4, VNC, noVNC, Firefox..."
sudo apt update && sudo apt install -y \
  xfce4 xfce4-goodies x11vnc novnc websockify \
  tightvncserver xterm

echo "[+] Tạo file ~/.vnc/xstartup với XFCE4..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup
echo "[+] Khởi tạo VNC lần đầu và kill để reset..."
vncserver :2 && vncserver -kill :2

echo "[+] Bắt đầu x11vnc + websockify..."
x11vnc -display :2 -forever -nopw -bg
websockify --web=/usr/share/novnc/ 8090 localhost:5902 &

echo "[✓] Xong rồi! Mở trình duyệt vào: http://<IP-của-ông>:8090"
