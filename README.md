🖥️ Ubuntu GUI + noVNC siêu nhẹ cho Termux/github codespaces
Repo này chứa các script tự động setup nhanh môi trường Ubuntu có giao diện đồ họa (XFCE4), truy cập từ xa qua VNC hoặc noVNC. Hỗ trợ chạy trên Termux, Github codespaces
🚀 Tính năng
Cài XFCE4 cực nhanh, tối ưu cho máy yếu.

Hỗ trợ truy cập bằng VNC Viewer hoặc trình duyệt web (noVNC).

Tích hợp cloudflared để mở cổng public free.

Tự động cài trình duyệt (Firefox).

Full auto, không cần chọn vùng hay bàn phím.
📦 Các script chính
Tên Script	Mô tả
termux.sh	Dành cho Termux Android, setup Ubuntu GUI + noVNC.
setup.sh	Setup cơ bản Ubuntu Desktop trên VPS/máy ảo bình thường.
🛠️ Cách sử dụng nhanh
Termux:
pkg update && pkg install -y wget
wget https://raw.githubusercontent.com/nam2010-pp/PC/main/termux.sh
bash termux.sh
VPS Ubuntu(github codespaces,...)
wget https://raw.githubusercontent.com/nam2010-pp/PC/main/setup.sh
bash setup.sh
🔥 Ghi chú
Mật khẩu VNC:tạo lúc vnc hỏi 

Nếu chạy trong VPS cần mở port để truy cập

Nếu noVNC bị lỗi, chỉ cần dùng app VNC Viewer kết nối IP + cổng là ok.
