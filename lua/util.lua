-- 工具集合

local M = {}

M.version = '1.0'

--------------------------------------------------------------------------------
-- 命令参数unpack
-- @param args 输入的参数
-- @param ... 预先指定的参数规则
--------------------------------------------------------------------------------
function M.unpack(args, ...)
    -- put args in table
    local defs = {...}
    -- get args
    local iargs = {}
    -- ordered args
    for i = 1, select('#', ...) do
        iargs[defs[i].arg] = args[i]
    end

    -- check/set arguments
    local dargs = {}
    for i = 1, #defs do
        local def = defs[i]
        -- 必填参数
        if def.req and iargs[def.arg] == nil then
           print('missing argument: ' .. def.arg)
        end
        -- 获取参数值
        dargs[def.arg] = iargs[def.arg]
        if dargs[def.arg] == nil and def.default then
             dargs[def.arg] = dargs[def.default]
        end
        dargs[i] = dargs[def.arg]
    end

    -- return modified args
    return unpack(dargs)
end

--------------------------------------------------------------------------------
-- 写入文件
-- @param filename 文件名称
-- @param info 文件流
--------------------------------------------------------------------------------
function M.write_file(filename, info)
     --写入文件(w覆盖)
    local file = io.open(filename, "w")
    file:write(info)
    file:close()
end

--获取文件名
function M.get_filename(res)
    local filename = ngx.re.match(res, '(.+)filename="(.+)"(.*)')
    if filename then
        return filename[2]
    end
end

--获取文件扩展名
function M.get_extension(str)
    return str:match(".+%.(%w+)$")
end


return M

