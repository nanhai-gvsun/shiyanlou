## docker制作
```bash
platform="arm" && \
version="v1.0" && \
pythonVersion="2.7.18" && \
file="docker/code-python-$pythonVersion" && \
imagename="code-python-$platform:$version" && \
docker build -t $imagename . -f &file
```
说明：
- platform:平台，目前有两个选项，arm和x86，分别在树莓派和x86服务器上进行。
- version:镜像的版本，根据实际调整
- pythonVersion:安装的python版本，不同的版本对应的Dockerfile不同
- file:Dockerfile文件，根据实际调整

## 启动docker
```bash
password="gengshang" && username="" && dockername="code-server-python2:2.7.18" && \
name="my-python2-container" \
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
- ${username}：使用者工号，便于分隔管理各学生的实验成果
- ${dockername}：code-server-python2:2.7.18

## 停止和删除容器
``` bash
# 停止运行容器
docker ps -a | grep "${dockername}"| awk '{print $1}' |xargs docker stop
# 删除容器
docker ps -a | grep "${dockername}"| awk '{print $1}' |xargs docker rm
```
说明：
- 运行的容器需要先停止再删除
- ${dockername}：code-server-python2:2.7.18

## 完整命令
```bash
password="gengshang" && username="guards" && dockername="code-server-python2:2.7.18" && docker ps -a | grep "$dockername"| awk '{print $1}' |xargs docker stop && docker ps -a | grep "$dockername"| awk '{print $1}' |xargs docker rm && docker run -d --name my-python2-container --privileged --device /dev/ttyAMA0 --device /dev/ttyUSB0 --device /dev/ttyUSB1 --device /dev/spidev0.0 --device /dev/spidev0.1 --device /dev/gpiomem -p 8443:8443 -v /home/gengshang:/home/gengshang -v /etc/network:/host/network -v /sys:/host/sys -v /etc/resolv.conf:/host/resolv.conf -e PASSWORD=$password -e DEFAULT_WORKSPACE=/home/gengshang/$username --restart always $dockername
```


