-- 入口文件

local gm = require 'lua.graphics_magick'

gm.convert{
    input = '/Users/Bug1024/Desktop/xing.jpeg',
    output = '/Users/Bug1024/Desktop/xing-300x300.jpeg',
    size = '300x300',
    quality = 95,
    verbose = true
}

