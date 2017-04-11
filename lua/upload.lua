-- 文件上传
-- curl -F "file=@xing.jpeg"   http://127.0.0.1:55555/upload/

local upload = require "resty.upload"
local string = require "resty.string"
local md5 = require "resty.md5"
local util = require "lua.util"
local cjson = require "cjson"

local chunk_size = 4096
local form, err = upload:new(chunk_size)
if not form then
    ngx.log(ngx.ERR, "failed to new upload: ", err)
    ngx.exit(500)
end
local file

while true do
    local typ, res, err = form:read()
    if not typ then
        ngx.log(ngx.ERR, "failed to read form: ", err)
        ngx.exit(500)
    end

    ngx.say("read: ", cjson.encode({typ, res}))

    if typ == "header" then
        if res[1] ~= "Content-Type" then
            -- TODO unique file name
            local filename = util.get_filename(res[2])
            local extension = util.get_extension(filename)
            local file_name = "/Users/bug1024/Desktop/" .. os.time() .. filename
            if file_name then
                file = io.open(file_name, "w+")
                if not file then
                    ngx.log(ngx.ERR, "failed to open file: ", err)
                    ngx.exit(500)
                end
            end
        end
     elseif typ == "body" then
        if file then
            file:write(res)
        end
    elseif typ == "part_end" then
        file:close()
        file = nil
    elseif typ == "eof" then
        break
    else
        -- do nothing
    end
end

local typ, res, err = form:read()
ngx.say("read: ", cjson.encode({typ, res}))

ngx.say("upload success :)")
