-- 入口文件

local img_original_path = ngx.var.img_original_path
local img_thumbnail_path = ngx.var.img_thumbnail_path
local width = ngx.var.width
local height = ngx.var.height
local ext = ngx.var.ext

ngx.log(ngx.INFO, img_thumbnail_path)

-- 切图
local gm = require 'lua.gm'
gm.convert{
    input = img_original_path,
    output = img_thumbnail_path,
    size = width .. 'x' .. height
}

-- 重新请求
ngx.exec(ngx.var.request_uri);

