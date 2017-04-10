-- 文件上传

local upload = require "resty.upload"
local cjson = require "cjson"

local chunk_size = 4096

local form, err = upload:new(chunk_size)
if not form then
    ngx.log(ngx.ERR, "failed to new upload: ", err)
    ngx.exit(500)
end

form:set_timeout(1000)

while true do
    local typ, res, err = form:read()
    if not typ then
        ngx.say("failed to read: ", err)
        return
    end

    ngx.say("read: ", cjson.encode({typ, res}))

    if typ == "eof" then
        break
    end
end

local typ, res, err = form:read()
ngx.say("read: ", cjson.encode({typ, res}))
