FROM ubuntu:22.04

# Cài đặt phần mềm cần thiết
RUN apt update && apt install -y \
    xfce4 xfce4-goodies tightvncserver novnc websockify curl python3 python3-pip \
    && apt clean

# Cài đặt Flask
RUN pip install flask

# Tạo thư mục làm việc
WORKDIR /workspace
