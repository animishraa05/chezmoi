-- lua/manga/reader.lua
-- Handles Kitty icat floating terminal and navigation
local M = {}
local api = vim.api
local fn = vim.fn

M.state = {
  files = {},
  idx = 1,
  buf = nil,
  win = nil,
  job = nil,
}

local function kitty_available()
  return fn.executable("kitty") == 1
end

local function open_float_term(path)
  -- create scratch buffer if needed
  if not (M.state.win and api.nvim_win_is_valid(M.state.win)) then
    local buf = api.nvim_create_buf(false, true)
    local ui = api.nvim_list_uis()[1] or {width = 80, height = 24}
    local width = math.min(ui.width - 6, 100)
    local height = math.min(ui.height - 6, 40)
    local row = math.floor((ui.height - height) / 2)
    local col = math.floor((ui.width - width) / 2)
    local opts = {
      style = "minimal",
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      border = "rounded",
    }
    M.state.buf = buf
    M.state.win = api.nvim_open_win(buf, true, opts)

    -- initial terminal
    local cmd = {"kitty", "+kitten", "icat", path}
    M.state.job = fn.termopen(cmd, {detach = 0})
    -- keymaps inside the float buffer
    local set = function(lhs, rhs)
      api.nvim_buf_set_keymap(buf, "n", lhs, rhs, {nowait=true, noremap=true, silent=true})
    end
    set("n", ":lua require('manga.reader').next()<CR>")
    set("p", ":lua require('manga.reader').prev()<CR>")
    set("q", ":lua require('manga.reader').quit()<CR>")
  else
    -- replace with new image by stopping job and starting new terminal
    if M.state.job then pcall(fn.jobstop, M.state.job) end
    local cmd = {"kitty", "+kitten", "icat", path}
    M.state.job = fn.termopen(cmd, {detach = 0})
  end
end

function M.open(files)
  if not kitty_available() then
    api.nvim_err_writeln("kitty is not in PATH. This plugin requires Kitty.")
    return
  end
  if not files or #files == 0 then
    api.nvim_err_writeln("No files to open")
    return
  end
  M.state.files = files
  M.state.idx = 1
  open_float_term(files[M.state.idx])
end

function M.next()
  if not M.state.files or #M.state.files == 0 then return end
  M.state.idx = math.min(#M.state.files, M.state.idx + 1)
  open_float_term(M.state.files[M.state.idx])
end

function M.prev()
  if not M.state.files or #M.state.files == 0 then return end
  M.state.idx = math.max(1, M.state.idx - 1)
  open_float_term(M.state.files[M.state.idx])
end

function M.quit()
  if M.state.job then pcall(fn.jobstop, M.state.job) end
  if M.state.win and api.nvim_win_is_valid(M.state.win) then pcall(api.nvim_win_close, M.state.win, true) end
  if M.state.buf and api.nvim_buf_is_loaded(M.state.buf) then pcall(api.nvim_buf_delete, M.state.buf, {force = true}) end
  M.state = {files = {}, idx = 1, buf = nil, win = nil, job = nil}
end

function M.status()
  if not M.state.files or #M.state.files == 0 then print("No reader open") return end
  print(string.format("Page %d/%d", M.state.idx, #M.state.files))
end

return M
