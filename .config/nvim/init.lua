require("options")      -- настройки редактора (vim.opt)
require("autocmds")     -- автокоманды (темы, spell, диагностика, отступы)
require("keymaps")      -- биндинги клавиш
require("whichkey")     -- описания биндингов для which-key
require("lazy_setup")   -- плагины
require("theme_manager").load_saved() -- загружаем последнюю выбранную тему
require("ui_toggles").load()          -- восстанавливаем состояние UI toggles
