# shiyanlou

实验楼项目，用于利用不同的开源工具和二次开发中间件实现管理远程实验的目的

# 部署
## 在本地部署
```shell
curl -sSL http://192.168.1.139/lipinyong/shiyanlou/raw/master/publish_shiyanshi.sh -o publish_shiyanlou.sh && bash publish_shiyanlou.sh web,gsiot,sse-server,client
```