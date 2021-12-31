local M = {}

M.config = function()
   -- load default config
   require("plugins.configs.others").luasnip()

   local present, luasnip = pcall(require, "luasnip")

   if present then
      luasnip.filetype_extend("heex", {"eelixir", "html"})
   else
      print("luasnip not present")
   end
end

return M;