-- upload file to local file system

local upload       = require "resty.upload"
local resty_sha256 = require "resty.sha256"
local util         = require "lua.util"
local resty_string = require "resty.string"

local chunk_size = 4096
local form, err = upload:new(chunk_size)
if not form then
    ngx.say("failed to new upload: ", err)
    return
end

local sha256, err = resty_sha256:new()
if not sha256 then
    ngx.say("failed to create the sha256 object: ", err)
    return
end

-- file handle
local file
-- file name response to client
local file_name
-- upload path
local upload_path = "/Users/bug1024/Desktop/"

while true do
    local typ, res, err = form:read()
    if not typ then
        ngx.say("failed to read form: ", err)
        if file then
            file:close()
            file = nil
        end
        return
    end

    if typ == "header" then
        if res[1] ~= "Content-Type" then
            local filename = util.get_filename(res[2])
            if filename then
                file_name = upload_path .. ngx.time() .. filename
                file = io.open(file_name, "w+")
                if not file then
                    ngx.say("failed to open file: ", err)
                    return
                end
            end
        end
    elseif typ == "body" then
        if file then
            file:write(res)
            sha256:update(res)
        end
    elseif typ == "part_end" then
        if file then
            file:close()
            file = nil
            --local digest = sha256:final()
            --sha256:reset()
            --my_save_sha_sum
        end
    elseif typ == "eof" then
        break
    else
        -- do nothing
    end
end

local digest = sha256:final()
sha256:reset()

ngx.say("sha256: ", resty_string.to_hex(digest))
ngx.say("upload success: ", file_name)

