#!/bin/bash

# 检查参数是否提供
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <directory> <commit message>"
  exit 1
fi

# 获取目录参数
DIR="$1"
commit_message="$2"

# 检查目录是否存在
if [ ! -d "$DIR" ]; then
  echo "Directory '$DIR' does not exist."
  exit 1
fi

# 遍历目录下的所有子目录
for SUBDIR in "$DIR"/*/; do
  # 检查子目录中是否存在 push.sh 文件
  if [ -f "$SUBDIR/push.sh" ]; then
    echo "Executing push.sh in $SUBDIR"
    # 执行 push.sh 文件
    (cd "$SUBDIR" && ./push.sh $commit_message)
  fi
done