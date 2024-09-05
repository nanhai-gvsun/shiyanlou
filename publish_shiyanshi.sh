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
  mkdir -p "$DIR"
  if [ $? -ne 0 ]; then
    echo "Failed to create directory '$DIR'."
    exit 1
  fi
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

# 如果分支 'web' 已克隆，则创建符号链接
if [ -d "$DIR/web" ]; then
  ln -sf "$DIR/web" /etc/nginx/html
  if [ $? -eq 0 ]; then
    echo "Symbolic link created: /etc/nginx/html -> $DIR/web"
  else
    echo "Failed to create symbolic link."
  fi
fi

if [ -d "$DIR/sse-server" ]; then
  ln -sf "$DIR/sse-server/etc/nginx/nginx.conf" /etc/nginx/nginx.conf
  if [ $? -eq 0 ]; then
    echo "Symbolic link created: /etc/nginx/nginx.conf -> $DIR/sse-server/etc/nginx/nginx.conf"
  else
    echo "Failed to create symbolic link."
  fi
fi