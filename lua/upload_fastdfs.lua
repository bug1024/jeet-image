-- upload file to distribute file system

local upload       = require "resty.upload"
local resty_string = require "resty.string"
local tracker      = require "resty.fastdfs.tracker"
local storage      = require "resty.fastdfs.storage"
local config       = require "lua.config"
local util         = require "lua.util"

local upload_path  = config.upload_path
local chunk_size   = config.chunk_size
local timeout      = config.timeout
local tracker_host = config.tracker_host
local tracker_port = config.tracker_port

-- get upload blob content
local function get_upload_content()
    local filename
    local content

    local form, err = upload:new(chunk_size)
    if not form then
        ngx.say("failed to new upload: ", err)
        ngx.exit(200)
    end

    while true do
        local typ, res, err = form:read()
        if not typ then
            ngx.say("failed to read form: ", err)
            ngx.exit(200)
        end

        if typ == "header" then
            if res[1] ~= "Content-Type" then
                filename = util.get_filename(res[2])
                if filename then
                    self.extname = getextension(filename)
                    -- do
                end
            end
        elseif typ == "body" then
            if filename then
                if not content then
                    content = res
                else
                    content = content .. res
                end
            end
        elseif typ == "part_end" then
            -- do nothing
        elseif typ == "eof" then
            break
        else
            -- do nothing
        end
    end

    return content
end

-- sent to fastdfs
local function send_fastdfs(blob, ext)
    local tk = tracker:new()
    tk:set_timeout(timeout)
    tk:connect({host = tracker_host, port = tracker_port})
    local res, err = tk:query_storage_store()
    if not res then
        ngx.say("query storage error:" .. err)
        ngx.exit(200)
    end

    local st = storage:new()
    st:set_timeout(recieve_timeout)
    local ok, err = st:connect(res)
    if not ok then
        ngx.say("connect storage error:" .. err)
        ngx.exit(200)
    end
    local result, err = st:upload_appender_by_buff(blob, ext)
    if not result then
        ngx.say("upload error:" .. err)
        ngx.exit(200)
    end
    local redirect_url = '/' .. result.group_name .. '/' .. result.file_name
    return redirect_url
end

local content = get_upload_content()
-- TODO get file extension
local url = send_fastdfs(content, "jpg")

ngx.say(url)

