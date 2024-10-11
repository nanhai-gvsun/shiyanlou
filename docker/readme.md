## docker制作
```bash
platform="arm" && \
version="v1.0" && \
pythonVersion="2.7.18" && \
file="docker/code-python-$pythonVersion" && \
imagename="code-python-$pythonVersion-$platform:$version" && \
docker build -t $imagename . -f &file
```
说明：
- platform:平台，目前有两个选项，arm和x86，分别在树莓派和x86服务器上进行。
- version:镜像的版本，根据实际调整
- pythonVersion:安装的python版本，不同的版本对应的Dockerfile不同
- file:Dockerfile文件，根据实际调整

## 启动docker
```bash
password="gengshang" && username="guards" && \
dockername="code-server-python-2.7.18:v1.0" && \
name="my-code-python-ide" &&\
&& docker run -d \
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
    -e DEFAULT_WORKSPACE=/home/gengshang/$username
    --restart always \
    $dockername 
```
说明：
- 这个命令主要是用在树莓派环境下，使用了特权模式，挂载了硬件模块
- ${password}：分配的临时密码，默认为gengshang
- ${username}：使用者工号对应的项目分支号在本地的克隆地址，便于分隔管理各学生的实验成果
- ${dockername}：code-server-python2:2.7.18

## 停止和删除容器
``` bash
# 停止运行容器
dockername="code-server-python-2.7.18:v1.0" && docker ps -a | grep "${dockername}"| awk '{print $1}' |xargs docker stop
# 删除容器
dockername="code-server-python-2.7.18:v1.0" && docker ps -a | grep "${dockername}"| awk '{print $1}' |xargs docker rm
```
说明：
- 运行的容器需要先停止再删除
- ${dockername}：code-server-python2:2.7.18

## 完整命令
```bash
password="gengshang" && username="guards" && dockername="code-server-python-2.7.18-arm:v1.0" && name="my-code-python-ide"&& docker ps -a | grep "$dockername"| awk '{print $1}' |xargs docker stop && docker ps -a | grep "$dockername"| awk '{print $1}' |xargs docker rm && docker run -d --name $name --privileged --device /dev/ttyAMA0 --device /dev/ttyUSB0 --device /dev/ttyUSB1 --device /dev/spidev0.0 --device /dev/spidev0.1 --device /dev/gpiomem -p 8443:8443 -v /home/gengshang:/home/gengshang -v /etc/network:/host/network -v /sys:/host/sys -v /etc/resolv.conf:/host/resolv.conf -e PASSWORD=$password -e DEFAULT_WORKSPACE=/home/gengshang/$username --restart always $dockername
```
改进命令就可以编写一个带参数的脚本，直接启动或停止重新部署
```bash
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
cmd="${5:-}"  # 如果有第五个参数，则赋值给cmd，否则cmd为空
version="$1"
pythonVersion="$2"
username="$3"
password="$4"

dockername="code-server-python-$pythonVersion:$version"
name="my-code-python-ide"

# 创建 Docker 镜像
create_image() {
    echo "创建 Docker 镜像: $dockername"
    echo "docker build -t $dockername -f code-python-$pythonVersion ."
    docker build -t $dockername -f code-python-$pythonVersion .
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
# 检查命令参数
if [ "$#" -gt 0 ]; then
     case $cmd in
        create)
            create_image
            exit 0
            ;;
        start)
            start_container
            exit 0
            ;;
        stop)
            stop_container
            exit 0
            ;;
        remove)
            remove_container
            exit 0
            ;;
    esac
fi

# 主菜单
while true; do
    echo "平台: $platform"
    echo "python版本：$pythonVersion"
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
```

### 说明：
- **自动判断平台**: 脚本使用 `uname -m` 命令来获取系统架构。如果返回值以 `arm` 开头，则设置平台为 `arm`，否则设置为 `x86`。
- **参数**: 脚本现在接受四个参数：
  - `<version>`: 镜像版本
  - `<pythonVersion>`: Python 版本
  - `<username>`: 用户名
  - `<password>`: 密码
  - `<cmd>`:指令(可选)，取值create、start、stop、remove
- **用法**: 运行脚本时，您可以使用以下命令：
  ```bash
  # 使用命令菜单
  bash manage_docker.sh v1.0 2.7.18 guards gengshang

  # 使用指定命令
  bash manage_docker.sh v1.0 2.7.18 guards gengshang create
  ```
