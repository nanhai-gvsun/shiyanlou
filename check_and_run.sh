#!/bin/bash
# 保留进程id，防止脚本没有运行完时又运行一个
# 获取当前脚本的进程ID
PID=$$

# 检查当前脚本是否已经在运行
if [ -f /tmp/check_and_run.pid ]; then
    # 获取当前脚本的进程ID
    PID=$(cat /tmp/check_and_run.pid)
    # 检查进程是否存在
    if ps -p $PID > /dev/null; then
        echo "脚本已经在运行，进程ID为 $PID"
        exit 0
    fi
else
    # 将进程ID写入文件
    echo $PID > /tmp/check_and_run.pid
fi
# 检查jq是否存在，没有则安装
if ! command -v jq &> /dev/null
then
    echo "jq 未安装，正在安装..."
    sudo apt-get install -y jq
fi
# 检查ss是否存在，没有则安装
if ! command -v ss &> /dev/null
then
    echo "ss 未安装，正在安装..."
    sudo apt-get install -y iproute2
fi

# 获取脚本所在目录
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# JSON配置文件路径
CONFIG_FILE="$SCRIPT_DIR/etc/conf/webconfig.json"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
  echo "配置文件 $CONFIG_FILE 不存在，请检查路径。"
  exit 1
fi

# 使用jq从JSON文件中读取port值
PORT=$(jq -r '.port' "$CONFIG_FILE")

# 检查PORT值是否有效
if [ -z "$PORT" ] || [ "$PORT" = "null" ]; then
  echo "无法从配置文件中读取有效的端口号，请检查配置文件。"
  exit 1
fi

# 使用ss命令检查指定端口是否打开
if ! ss -lnt | grep -q ":$PORT"; then
  # 如果端口没有打开，则运行Python脚本
  echo "$PORT 端口未打开，正在启动Python脚本..."
  # 在 "$SCRIPT_DIR/etc/log"目录下记录日志,如果目录不存在则创建
  if [ ! -d "$SCRIPT_DIR/etc/log" ]; then
    mkdir -p "$SCRIPT_DIR/etc/log"
  fi
  # 输出日志内容包含时间
  echo "$(date '+%Y-%m-%d %H:%M:%S') $PORT 端口未打开，正在启动Python脚本..." >>$SCRIPT_DIR/etc/log/app.log
  python "$SCRIPT_DIR/app.py" &
else
  echo "$PORT 端口已打开，无需启动Python脚本。"
fi
# 删除进程ID文件  
rm -f /tmp/check_and_run.pid
exit 0

