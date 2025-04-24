#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Cập nhật và cài gói cần thiết..."
pkg update -y
pkg install -y x11-repo
pkg install -y tigervnc lxqt novnc firefox python

echo "[+] Tạo thư mục ~/.vnc và cấu hình khởi động LXQt..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/data/data/com.termux/files/usr/bin/bash
startlxqt &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Khởi động VNC lần đầu để tạo cấu hình..."
vncserver :1
sleep 2
vncserver -kill :1

echo "[+] Tạo icon Firefox trên desktop LXQt..."
mkdir -p ~/.config/autostart ~/.local/share/applications ~/Desktop

cat > ~/.local/share/applications/firefox.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Firefox
Comment=Trình duyệt web
Exec=firefox
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF

cp ~/.local/share/applications/firefox.desktop ~/Desktop/
chmod +x ~/Desktop/firefox.desktop

echo "[+] Khởi động lại VNC..."
vncserver :1

echo "[+] Mở noVNC..."
DISPLAY=:1 websockify --web=/data/data/com.termux/files/usr/share/novnc 6080 localhost:5901 &

echo
echo "[✓] Xong! Mở trình duyệt vào:"
echo "    http://localhost:6080/vnc.html"
echo
echo "[!] Để tắt:"
echo "    vncserver -kill :1 && pkill websockify"
