# shiyanlou

实验楼项目，用于利用不同的开源工具和二次开发中间件实现管理远程实验的目的

# 部署
## 在本地部署
```shell
path="/home/gengshang/shiyanlou" \
&& shfile="publish_shiyanshi.sh" \
&& curl -sSL http://192.168.1.139/lipinyong/shiyanlou/raw/master/$shfile -o $shfile \
&& bash $shfile $path web,gsiot,sse-server,client,master,doc
```

## 批量提交
```shell
shfile="allpush.sh" \
&& curl -sSL http://192.168.1.139/lipinyong/shiyanlou/raw/master/$shfile -o $shfile \
&& bash $shfile /home/gengshang/shiyanlou <commit-message>
```