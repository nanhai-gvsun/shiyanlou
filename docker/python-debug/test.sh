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

echo "命令:$cmd"
echo "平台:$platform"
echo "镜像版本: $version"
echo "python版本: $pythonVersion"
echo "分支: $username"
echo "密码: $password"