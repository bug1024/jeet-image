-- 工具集合

local M = {}

M.version = '1.0'

--------------------------------------------------------------------------------
-- standard argument function: used to handle named arguments, and
-- display automated help for functions
--------------------------------------------------------------------------------
function M.unpack(args, funcname, description, ...)
   -- put args in table
   local defs = {...}

   -- generate usage string as a closure:
   -- this way the function only gets called when an error occurs
   local fusage = function()
      local example
      if #defs > 1 then
     example = funcname .. '{' .. defs[2].arg .. '=' .. defs[2].type .. ', '
        .. defs[1].arg .. '=' .. defs[1].type .. '}\n'
     example = example .. funcname .. '(' .. defs[1].type .. ',' .. ' ...)'
      end
      return dok.usage(funcname, description, example, {tabled=defs})
   end
   local usage = {}
   setmetatable(usage, {__tostring=fusage})

   -- get args
   local iargs = {}
   if args.__printhelp then
      print(usage)
      error('error')
   elseif #args == 1 and type(args[1]) == 'table' and #args[1] == 0
   and not (torch and torch.typename(args[1]) ~= nil) then
      -- named args
      iargs = args[1]
   else
      -- ordered args
      for i = 1,select('#',...) do
         iargs[defs[i].arg] = args[i]
      end
   end

   -- check/set arguments
   local dargs = {}
   for i = 1,#defs do
      local def = defs[i]
      -- is value requested ?
      if def.req and iargs[def.arg] == nil then
         print(style.error .. 'missing argument: ' .. def.arg .. style.none)
         print(usage)
         error('error')
      end
      -- get value or default
      dargs[def.arg] = iargs[def.arg]
      if dargs[def.arg] == nil then
         dargs[def.arg] = def.default
      end
      if dargs[def.arg] == nil and def.defaulta then
         dargs[def.arg] = dargs[def.defaulta]
      end
      dargs[i] = dargs[def.arg]
   end

   -- return usage too
   dargs.usage = usage

   -- stupid lua bug: we return all args by hand
   if dargs[65] then
      error('<dok.unpack> oups, cant deal with more than 64 arguments :-)')
   end

   -- return modified args
   return dargs,unpack(dargs)
end

return M

