#!/bin/bash
set -e

# ───────────────────────────────────────────────────────────
# 1) Thiết lập biến môi trường
export DEBIAN_FRONTEND=noninteractive
export USER=root
export HOME=/root
export DISPLAY=:19
echo "[*] ENV set: DEBIAN_FRONTEND=$DEBIAN_FRONTEND, USER=$USER, HOME=$HOME, DISPLAY=$DISPLAY"

# ───────────────────────────────────────────────────────────
# 2) Cập nhật & cài gói cần thiết
echo "[*] Updating apt and installing XFCE4, VNC, noVNC, Vivaldi deps..."
apt update -y
apt install -y \
  xfce4 xfce4-goodies tightvncserver x11vnc \
  xterm novnc websockify wget curl gnupg2 supervisor locales \
  ca-certificates libgtk-3-0 libdbus-glib-1-2 libxt6

locale-gen en_US.UTF-8
# 4) Cấu hình VNC (mật khẩu 123456)
echo "[*] Configuring VNC password and xstartup..."
mkdir -p "$HOME/.vnc"
echo "123456" | vncpasswd -f > "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"

cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
sleep 5
vivaldi &
EOF
chmod +x "$HOME/.vnc/xstartup"

# ───────────────────────────────────────────────────────────
# 5) Khởi tạo & restart VNC server
echo "[*] Initializing VNC on display :1..."
vncserver :19
sleep 2
vncserver -kill :19

# ───────────────────────────────────────────────────────────
# 6) Chạy x11vnc & noVNC trên cổng 8090
echo "[*] Starting x11vnc (port 5919) and noVNC (port 8090)..."
x11vnc -display :1 -rfbport 5919 -forever -nopw -bg
websockify --web=/usr/share/novnc/ 8090 localhost:5919 &

# ───────────────────────────────────────────────────────────
# 7) Cài và chạy cloudflared
echo "[*] Downloading and running cloudflared tunnel..."
wget -q -O cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x cloudflared
nohup ./cloudflared tunnel --url http://localhost:8090 --no-autoupdate > tunnel.log 2>&1 &

# ───────────────────────────────────────────────────────────
# 8) Đợi & hiển thị link public
sleep 8
PUBLIC=$(grep -o 'https://.*trycloudflare.com' tunnel.log || true)
echo
echo "✅ Hoàn thành! Truy cập Ubuntu GUI qua noVNC tại:"
echo "   ${PUBLIC}/vnc.html"
echo
echo "🛑 Để tắt:"
echo "   vncserver -kill :19 && pkill websockify && pkill cloudflared"
