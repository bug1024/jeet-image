
-- GraphicsMagick 命令封装

local M = {}

M.version = '1.0'

local util = require 'lua.util'
--local gm_cmd = '/usr/local/GraphicsMagick/bin/gm'
local gm_cmd = '/usr/local/Cellar/GraphicsMagick/1.3.25/bin/gm'

-- gm convert [ options ... ] input_file output_file
function M.convert(...)
   -- args
   local args = util.unpack(
      {...},
      {arg='input',     type='string',   help='path to input image',    req=true},
      {arg='output',    type='string',   help='path to output image',   req=true},
      {arg='size',      type='string',   help='destination size'},
      {arg='rotate',    type='number',   help='rotation angle (degrees)'},
      {arg='vflip',     type='boolean',  help='flip image vertically'},
      {arg='hflip',     type='boolean',  help='flip image horizontally'},
      {arg='quality',   type='number',   help='quality (0 to 100)',     default=90},
      {arg='benchmark', type='boolean',  help='benchmark command',      default=false},
      {arg='text',      type='string',   help='text mask words'},
      {arg='font',      type='string',   help='text mask font'},
      {arg='fontsize',  type='number',   help='text mask font size'},
      {arg='color',     type='string',   help='text mask color'},
      {arg='verbose',   type='boolean',  help='verbose', default=false}
   )

   -- hint input size:
   local options = {}
   if args.size then
      table.insert(options, '-size ' .. args.size)
   end

   -- unpack commands:
   for cmd, val in pairs(args) do
      if cmd == 'size' then
         table.insert(options, '-resize ' .. val)
      elseif cmd == 'rotate' then
         table.insert(options, '-rotate ' .. val)
      elseif cmd == 'quality' then
         table.insert(options, '-quality ' .. val)
      elseif cmd == 'text' and val then
          -- todo
         table.insert(options, '-draw "text 100,100 ' .. val .. '"')
      elseif cmd == 'color' and val then
         table.insert(options, '-fill ' .. val)
      elseif cmd == 'font' and val then
         table.insert(options, '-font ' .. val)
      elseif cmd == 'fontsize' and val then
         table.insert(options, '-pointsize ' .. val)
      elseif cmd == 'verbose' and val then
         table.insert(options, '-verbose')
      elseif cmd == 'vflip' and val then
         table.insert(options, '-flip')
      elseif cmd == 'hflip' and val then
         table.insert(options, '-flop')
      end
   end

   -- input path:
   table.insert(options, args.input)

   -- output path:
   table.insert(options, args.output)

   -- pack command:
   local cmd
   if args.benchmark then
      cmd = gm_cmd .. ' benchmark convert '
   else
      cmd = gm_cmd .. ' convert '
   end
   cmd = cmd .. table.concat(options, ' ')
   -- exec command:
   if args.verbose then print(cmd) end
   os.execute(cmd)
end

return M

