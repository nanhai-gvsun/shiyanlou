# 使用基础镜像 python:2.7.18-alpine3.11
FROM python:2.7.18-alpine3.11

# 安装 nginx
RUN apk add --no-cache nginx

# 创建工作目录
WORKDIR /home/gengshang/shiyanlou

# 下载并执行脚本
RUN path="/home/gengshang/shiyanlou" \
    && shfile="publish_shiyanshi.sh" \
    && curl -sSL "http://192.168.1.139/lipinyong/shiyanlou/raw/master/$shfile" -o "$shfile" \
    && bash "$shfile" "$path" web,gsiot,sse-server,client,master,doc

# 安装 requirements.txt 中的依赖项
RUN pip install --no-cache-dir -r /home/gengshang/shiyanlou/master/requirements.txt

# 设置 /etc/sse-server 映射到宿主机
VOLUME /etc/sse-server

# 开放 80 和 443 端口
EXPOSE 80 443

# 运行命令
CMD python /home/gengshang/shiyanlou/sse-server/app.py &