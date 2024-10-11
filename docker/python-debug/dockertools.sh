#!/bin/bash
# 
# 自动判断平台
if [[ "$(uname -m)" == "arm"* ]]; then
    platform="arm"
else
    platform="x86"
fi

# 检查参数数量
if [ "$#" -lt 4 ]; then
    echo "用法: $0 <version> <pythonVersion> <username> <password>"
    exit 1
fi

# 从参数获取变量
version="$1"
pythonVersion="$2"
username="$3"
password="$4"

dockername="code-server-python-$pythonVersion:$version"
name="my-code-python-ide"

# 创建 Docker 镜像
create_image() {
    echo "创建 Docker 镜像: $dockername"
    docker build -t $dockername -f docker/code-python-$pythonVersion .
}

# 启动 Docker 容器
start_container() {
    echo "启动 Docker 容器: $name"
    docker run -d \
        --name $name \
        --privileged \
        --device /dev/ttyAMA0 \
        --device /dev/ttyUSB0 \
        --device /dev/ttyUSB1 \
        --device /dev/spidev0.0 \
        --device /dev/spidev0.1 \
        --device /dev/gpiomem \
        -p 8443:8443 \
        -v /home/gengshang:/home/gengshang \
        -v /etc/network:/host/network \
        -v /sys:/host/sys \
        -v /etc/resolv.conf:/host/resolv.conf \
        -e PASSWORD=$password \
        -e DEFAULT_WORKSPACE=/home/gengshang/$username \
        --restart always \
        $dockername
}

# 停止 Docker 容器
stop_container() {
    echo "停止 Docker 容器: $name"
    docker ps -a | grep "$dockername" | awk '{print $1}' | xargs docker stop
}

# 删除 Docker 容器
remove_container() {
    echo "删除 Docker 容器: $name"
    docker ps -a | grep "$dockername" | awk '{print $1}' | xargs docker rm
}

# 主菜单
while true; do
    echo "平台: $platform"
    echo "选择操作:"
    echo "1. 创建 Docker 镜像"
    echo "2. 启动 Docker 容器"
    echo "3. 停止 Docker 容器"
    echo "4. 删除 Docker 容器"
    echo "5. 批量操作 (创建 -> 启动)"
    echo "6. 退出"
    read -p "请输入选项 (1-6): " option

    case $option in
        1) create_image ;;
        2) start_container ;;
        3) stop_container ;;
        4) remove_container ;;
        5) create_image && start_container ;;
        6) echo "退出程序"; exit 0 ;;
        *) echo "无效选项" ;;
    esac
done