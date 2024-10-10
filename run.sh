#!/bin/bash
# 启动nginx
service nginx start
# 启动中间件
python /home/gengshang/shiyanlou/sse-server/app.py &
