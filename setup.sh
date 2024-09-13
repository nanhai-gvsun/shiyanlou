#!/bin/bash
# 获取脚本的绝对路径
SCRIPT_PATH=$(readlink -f "$0")

# 获取脚本的目录
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

# 获取脚本的父目录
PARENT_DIR=$(dirname "$SCRIPT_DIR")

# 安装pip组件
pip install -r $SCRIPT_DIR/requirements.txt --break-system-packages
# 配置软链接
ln -sf $SCRIPT_DIR/start.sh /usr/bin/sse-server
ln -sf $SCRIPT_DIR/etc/nginx/nginx.conf /etc/nginx/nginx.conf
ln -sf $SCRIPT_DIR/etc/nginx/cakey.pem /etc/nginx/cakey.pem
ln -sf $SCRIPT_DIR/etc/nginx/cacerts.pem /etc/nginx/cacerts.pem

# 配置nginx的html
ln -sf $PARENT_DIR/web /etc/nginx/html
