local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end

ts_config.setup {
   indent = {
     enable = false
   },
   ensure_installed = {
      "lua",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
}
