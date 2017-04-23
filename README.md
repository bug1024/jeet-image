# jeet-image
一个基于OpenResty + GraphicsMagick实现的图片服务

## 环境
 - 系统环境：MacOS 10.12
 - OpenResty版本：1.11.2.2
 - GraphicsMagick版本：1.3.25
 - FastDFS版本：5.10

## 功能
 - 图片上传
 - 文字水印
 - 动态生成指定尺寸图片
 - FastDFS存储

## 原理
 - 原图上传到FastDFS
 - 请求指定尺寸图片时，先从FastDFS获取原图并进行gm convert处理
 - 返回新生成的图片

## FastDFS 命令
```shell
    fdfs_trackerd /Users/bug1024/Github/fastdfs/conf/tracker.conf [start|stop|restart]
    fdfs_storaged /Users/bug1024/Github/fastdfs/conf/storage.conf [start|stop|restart]
    fdfs_monitor /Users/bug1024/Github/fastdfs/conf/client.conf
    fdfs_test /Users/bug1024/Github/fastdfs/conf/client.conf upload /Users/bug1024/Pictures/xing.jpeg
    fdfs_test /Users/bug1024/Github/fastdfs/conf/client.conf download group1 xxxx.jpeg
```

## 问题
 - 添加水印失败：Postscript delegate failed，因为GraphicsMagick依赖FreeType和ghostscript，折腾了挺久最后还是用brew安装解决了问题
 - 首次访问无法返回图片，因为此时图片尚未生成，可在切图之后加上ngx.exec(ngx.var.request_uri)重新请求实现二次访问的效果
 - Mac下安装FastDFS折腾了挺久
    * 需要依赖libfastcommon，安装时提示无权限，是因为Mac下某些路径加sudo也是无法创建文件的，所以只能改Makefile文件，将原本默认安装到/usr/lib等之类的路径改为/usr/local/lib
    * 启动storage时，使用了相对路径的配置文件报错，改为使用绝对路径后即可
    * 需要修改tracker.conf，client.conf，storage.conf文件，设置base_path等信息
    * storage报错tracker server ip can't be 127.0.0.1，改为192.x.x.x即可
 - 待解决：获取原图可以通过fdfs下载，是否也可以将fdfs和切图服务器部署在一起然后从本地直接获取?
 - 待解决：缩略图是否也需要上传到fdfs?

## 参考
 - [OpenResty最佳实践](https://moonbingbing.gitbooks.io/openresty-best-practices/content/lua/brief.html)
 - [A simple Lua wrapper to GraphicsMagick](https://github.com/clementfarabet/graphicsmagick)
 - [分布式文件系统FastDFS实践](https://t.hao0.me/storage/2016/05/10/fastdfs-practice.html)
