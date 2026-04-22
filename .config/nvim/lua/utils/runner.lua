local M = {}

-- Конфигурация для разных языков
local runners = {
  rust = {
    compile = { "rustc", "%", "-o", "%_bin" },
    run = { "%_bin" },
    cleanup = { "rm", "-f", "%_bin" },
  },
  python = {
    compile = nil,
    run = { "python3", "%" },
    cleanup = nil,
  },
  cpp = {
    compile = { "g++", "%", "-o", "%_bin", "-std=c++17" },
    run = { "%_bin" },
    cleanup = { "rm", "-f", "%_bin" },
  },
  c = {
    compile = { "gcc", "%", "-o", "%_bin" },
    run = { "%_bin" },
    cleanup = { "rm", "-f", "%_bin" },
  },
  go = {
    compile = { "go", "build", "-o", "%_bin", "%" },
    run = { "%_bin" },
    cleanup = { "rm", "-f", "%_bin" },
  },
  java = {
    compile = { "javac", "%" },
    run = { "java", "%" },
    cleanup = nil,
  },
  js = {
    compile = nil,
    run = { "node", "%" },
    cleanup = nil,
  },
  ts = {
    compile = { "npx", "tsc", "%" },
    run = { "node", "%.js" },
    cleanup = { "rm", "-f", "%.js" },
  },
  sh = {
    compile = nil,
    run = { "bash", "%" },
    cleanup = nil,
  },
  lua = {
    compile = nil,
    run = { "lua", "%" },
    cleanup = nil,
  },
}

-- Получение языка по расширению файла
local function get_language(ext)
  local lang_map = {
    rs = "rust",
    py = "python",
    cpp = "cpp",
    cxx = "cpp",
    cc = "cpp",
    hpp = "cpp",
    h = "c",
    c = "c",
    go = "go",
    java = "java",
    js = "js",
    ts = "ts",
    sh = "sh",
    bash = "sh",
    lua = "lua",
  }
  return lang_map[ext]
end

-- Замена % на путь к файлу
local function replace_placeholder(cmd_args, filepath)
  if not cmd_args then return nil end

  local result = {}
  for _, arg in ipairs(cmd_args) do
    local processed = arg:gsub("%%", filepath)
    table.insert(result, processed)
  end

  return result
end

-- Основная функция компиляции и запуска
function M.compile_and_run()
  local filepath = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")

  if filepath == "" then
    vim.notify("Нет открытого файла", vim.log.levels.WARN)
    return
  end

  -- Сохраняем файл перед компиляцией
  vim.cmd("write")

  local lang = get_language(ext)

  if not lang then
    vim.notify("Неподдерживаемый тип файла: ." .. ext, vim.log.levels.WARN)
    return
  end

  local config = runners[lang]

  if not config then
    vim.notify("Не настроен запуск для языка: " .. lang, vim.log.levels.WARN)
    return
  end

  -- Выполняем cleanup (очистка старого бинарника)
  if config.cleanup then
    local cleanup_cmd = replace_placeholder(config.cleanup, filepath)
    if cleanup_cmd then
      local result = vim.system(cleanup_cmd, { text = true }):wait()
    end
  end

  -- Компиляция
  if config.compile then
    local compile_cmd = replace_placeholder(config.compile, filepath)
    if compile_cmd then
      local compile_result = vim.system(compile_cmd, { text = true }):wait()

      if compile_result.code ~= 0 then
        -- Ошибка компиляции
        local error_msg = "Ошибка компиляции:\n" .. (compile_result.stderr or compile_result.stdout or "Unknown error")
        vim.notify(error_msg, vim.log.levels.ERROR)
        return
      end
    end
  end

  -- Запуск
  if config.run then
    local run_cmd = replace_placeholder(config.run, filepath)
    if run_cmd then
      local run_result = vim.system(run_cmd, { text = true }):wait()

      -- Формируем вывод
      local output = ""
      if run_result.stdout and run_result.stdout ~= "" then
        output = output .. run_result.stdout
      end
      if run_result.stderr and run_result.stderr ~= "" then
        if output ~= "" then
          output = output .. "\n"
        end
        output = output .. run_result.stderr
      end

      if run_result.code ~= 0 then
        vim.notify("Программа завершилась с кодом: " .. run_result.code .. "\n" .. output, vim.log.levels.ERROR)
      else
        -- Успешный вывод
        if output and output ~= "" then
          -- Обрезаем слишком длинный вывод
          if #output > 2000 then
            output = output:sub(1, 2000) .. "\n... (вывод обрезан)"
          end
          vim.notify(output, vim.log.levels.INFO)
        else
          vim.notify("Программа выполнена успешно (без вывода)", vim.log.levels.INFO)
        end
      end
    end
  end
end

-- Регистрация команды :Comp
vim.api.nvim_create_user_command("Comp", function()
  M.compile_and_run()
end, {})

return M
