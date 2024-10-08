# 使用基础镜像 python:3.11-slim
FROM python:3.11-slim

# 更新和安装软件
RUN apt update && \
    apt install -y nginx curl bash git ffmpeg

# 创建工作目录
WORKDIR /home/gengshang/shiyanlou

# 下载并执行脚本
RUN curl -sSL -o publish_shiyanshi.sh "http://192.168.1.139/lipinyong/shiyanlou/raw/master/publish_shiyanshi.sh"
RUN bash publish_shiyanshi.sh /home/gengshang/shiyanlou web,gsiot,sse-server,client,master,doc

# 安装 requirements.txt 中的依赖项
RUN curl -sSL -o requirements.txt "http://192.168.1.139/lipinyong/shiyanlou/raw/master/requirements.txt"
RUN pip install -r requirements.txt

# 设置 /etc/sse-server 映射到宿主机
VOLUME /etc/sse-server

# 开放 80 和 443 端口
EXPOSE 80 443

# 运行命令
CMD python /home/gengshang/shiyanlou/sse-server/app.py &