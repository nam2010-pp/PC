#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Cập nhật gói và cài XFCE + VNC..."
pkg update -y && pkg upgrade -y
pkg install -y x11-repo tigervnc xfce4 xterm dbus x11-repo root-repo

echo "[+] Tạo file xstartup..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/data/data/com.termux/files/usr/bin/bash
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Tạo mật khẩu VNC: 123456..."
mkdir -p ~/.vnc
echo -e "123456\n123456\nn" | vncpasswd

echo "[+] Khởi động VNC server..."
vncserver :1

echo "[✓] Xong rồi! Mở app VNC Viewer, kết nối tới: 127.0.0.1:5901"
