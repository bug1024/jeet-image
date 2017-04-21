
local width = ngx.var.width
local height = ngx.var.height
local ext = ngx.var.ext
local input_file = ngx.var.file
local output_file = input_file .. "_" .. width .. "x" .. height  .. "." .. ext

-- 切图
local gm = require 'lua.gm'
gm.convert{
    input = input_file,
    output = output_file,
    size = width .. "x" .. height
}

local util = require "lua.util"

if util.is_file(output_file) then
    ngx.exec(ngx.var.request_uri);
else
    ngx.exit(404)
end

