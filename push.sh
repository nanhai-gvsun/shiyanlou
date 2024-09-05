#!/bin/bash

# 获取脚本所在目录
path=$(cd "$(dirname "$0")"; pwd)

# 获取命令行参数作为提交信息，如果没有则默认为空
commit="${1:+:$1}"

# 构建git命令
cmd="cd $path && git pull && git add . && git add * && git commit -m \"$(date +%Y-%m-%d)自动提交$commit\" && git push"

# 打印命令
echo "$cmd"

# 执行命令
eval "$cmd"
