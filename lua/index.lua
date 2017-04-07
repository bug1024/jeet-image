-- 入口文件

local gm = require 'lua.graphics_magick'

- test
gm.convert{
    input = '/Users/Bug1024/Desktop/xing.jpeg',
    output = '/Users/Bug1024/Desktop/xing-xing.jpeg',
    size = '900x600',
    quality = 95,
    verbose = true
}

