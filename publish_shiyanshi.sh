#!/bin/bash

# 检查参数是否提供
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <directory> <branch1,branch2,...>"
  exit 1
fi

# 获取目录参数
DIR="$1"

# 获取分支名列表
IFS=',' read -r -a BRANCHES <<< "$2"

# 检查并创建主目录
if [ ! -d "$DIR" ]; then
  mkdir -p "$DIR" || { echo "Failed to create directory '$DIR'."; exit 1; }
fi

# 切换到主目录
cd "$DIR" || exit 1

# 遍历分支名列表
for BRANCH in "${BRANCHES[@]}"; do
  # 检查分支目录是否存在
  if [ -d "$BRANCH" ]; then
    echo "Directory '$BRANCH' already exists."
  else
    # 克隆分支并重命名目录
    git clone --branch "$BRANCH" --single-branch http://lipinyong:lipinyong@192.168.1.139/lipinyong/shiyanlou "$BRANCH"
    if [ $? -eq 0 ]; then
      echo "Branch '$BRANCH' cloned successfully."
    else
      echo "Failed to clone branch '$BRANCH'."
    fi
  fi
done

# 创建符号链接的函数
create_symlink() {
  local target="$1"
  local link_name="$2"
  ln -sf "$target" "$link_name" && echo "Symbolic link created: $link_name -> $target" || echo "Failed to create symbolic link: $link_name"
}

# 如果分支 'web' 已克隆，则创建符号链接
if [ -d "$DIR/web" ]; then
<<<<<<< HEAD
  create_symlink "$DIR/web" /etc/nginx/html
=======
  if [ -d "/data/data/com.termux/files/usr" ]; then
    ln -sf "$DIR/web" /data/data/com.termux/files/usr/etc/nginx/html
  else
    ln -sf "$DIR/web" /etc/nginx/html
  fi
  if [ $? -eq 0 ]; then
    echo "Symbolic link created: /etc/nginx/html -> $DIR/web"
  else
    echo "Failed to create symbolic link."
  fi
>>>>>>> e3e49c76ceba44a087b319f39e0ae5c3efb35af7
fi

if [ -d "$DIR/doc" ]; then
  create_symlink "$DIR/doc" "$DIR/sse-server/doc"
fi

if [ -d "$DIR/gsiot" ]; then
  create_symlink "$DIR/gsiot" "$DIR/sse-server/gsiot"
fi

<<<<<<< HEAD
if [ -d "$DIR/sse-server" ]; then
  create_symlink "$DIR/sse-server/etc" /etc/sse-server
  create_symlink "$DIR/sse-server/etc/nginx/nginx.conf" /etc/nginx/nginx.conf
  create_symlink "$DIR/sse-server/etc/nginx/cakey.pem" /etc/nginx/cakey.pem
  create_symlink "$DIR/sse-server/etc/nginx/cacerts.pem" /etc/nginx/cacerts.pem
=======
# 检查是否在 Termux 环境中运行
if [ -d "/data/data/com.termux/files/usr" ]; then
  USR="/data/data/com.termux/files/usr"
  if [ -d "$DIR/sse-server" ]; then
    ln -sf "$DIR/sse-server/etc/nginx/nginx.conf" "$USR/etc/nginx/nginx.conf"
    ln -sf "$DIR/sse-server/etc/nginx/cakey.pem" "$USR/etc/nginx/cakey.pem"
    ln -sf "$DIR/sse-server/etc/nginx/cacerts.pem" "$USR/etc/nginx/cacerts.pem"
    if [ $? -eq 0 ]; then
      echo "Symbolic links created for Termux environment."
    else
      echo "Failed to create symbolic links for Termux environment."
    fi
  fi
else
  if [ -d "$DIR/sse-server" ]; then
    ln -sf "$DIR/sse-server/etc/nginx/nginx.conf" /etc/nginx/nginx.conf
    ln -sf "$DIR/sse-server/etc/nginx/cakey.pem" /etc/nginx/cakey.pem
    ln -sf "$DIR/sse-server/etc/nginx/cacerts.pem" /etc/nginx/cacerts.pem
    if [ $? -eq 0 ]; then
      echo "Symbolic links created for standard environment."
    else
      echo "Failed to create symbolic links for standard environment."
    fi
  fi
>>>>>>> e3e49c76ceba44a087b319f39e0ae5c3efb35af7
fi