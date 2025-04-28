#!/bin/bash
set -e

# Đặt biến môi trường
export DEBIAN_FRONTEND=noninteractive
export USER=root
export HOME=/root
export DISPLAY=:1

echo "[+] Cập nhật hệ thống và cài gói cần thiết..."
sudo apt update && sudo apt install -y \
    xfce4 xfce4-goodies tightvncserver x11vnc \
    xterm novnc websockify wget curl gnupg2 supervisor locales

echo "[+] Tạo locale en_US.UTF-8..."
sudo locale-gen en_US.UTF-8

echo "[+] Cài Vivaldi Browser..."
sudo curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/vivaldi.gpg
echo "deb [signed-by=/usr/share/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi.list
sudo apt update && sudo apt install -y vivaldi-stable

echo "[+] Cấu hình VNC server..."
mkdir -p ~/.vnc
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat > ~/.vnc/xstartup <<EOF
#!/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
sleep 5 && vivaldi &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Khởi tạo VNC server lần đầu..."
vncserver :1 && vncserver -kill :1

echo "[+] Bắt đầu x11vnc + websockify noVNC..."
x11vnc -display :1 -forever -nopw -bg
websockify --web=/usr/share/novnc/ 8080 localhost:5901 &

echo "[✓] Hoàn tất! Truy cập giao diện qua: http://<IP>:8080"
