#!/data/data/com.termux/files/usr/bin/bash

echo "[+] Cập nhật và cài gói cần thiết..."
pkg update -y
pkg install -y x11-repo
pkg install -y tigervnc git python wget lxqt
pip install websockify

echo "[+] Clone noVNC..."
git clone https://github.com/novnc/noVNC.git
cd noVNC
git submodule update --init --recursive
cd ..

echo "[+] Cấu hình VNC (LXQt)..."
mkdir -p ~/.vnc
cat > ~/.vnc/xstartup <<EOF
#!/data/data/com.termux/files/usr/bin/bash
startlxqt &
EOF
chmod +x ~/.vnc/xstartup

echo "[+] Khởi động VNC server..."
vncserver :1
sleep 2
vncserver -kill :1

echo "[+] Bắt đầu lại VNC server..."
vncserver :1

echo "[+] Khởi động noVNC qua websockify..."
DISPLAY=:1 websockify --web=~/noVNC 6080 localhost:5901 &

echo
echo "[✓] Thành công! Mở trình duyệt vào link này:"
echo "    http://localhost:6080/vnc.html"
echo
echo "[!] Để tắt:"
echo "    - Dừng VNC: vncserver -kill :1"
echo "    - Dừng websockify: pkill websockify"
