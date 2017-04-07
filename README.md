# jeet-image
一个基于OpenResty + GraphicsMagick实现的图片服务

## 环境
 - 系统环境：MacOS 10.12
 - OpenResty版本：1.11.2.2
 - GraphicsMagick版本：1.3.25

## 功能
 - 图片上传
 - 文字水印
 - 动态生成指定尺寸图片
 - FastDFS存储

## 问题
 - 添加水印失败：Postscript delegate failed，因为GraphicsMagick依赖FreeType和ghostscript，折腾了挺久最后还是用brew安装解决了问题

## 参考
 - [OpenResty最佳实践](https://moonbingbing.gitbooks.io/openresty-best-practices/content/lua/brief.html)
 - [A simple Lua wrapper to GraphicsMagick](https://github.com/clementfarabet/graphicsmagick)
