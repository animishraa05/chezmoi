-- lua/manga/init.lua
local api = require("manga.api")
local util = require("manga.util")
local reader = require("manga.reader")
local fn = vim.fn
local ui = vim.ui

local M = {}

-- Search command entry
function M.search_and_open()
  -- Hardcoded for testing
  local test_manga_id = "a96676e5-8ae2-425e-b549-7f15dd34a6d8"
  M.select_chapter_for_manga(test_manga_id)
end

function M.select_chapter_for_manga(manga_id)
  local chs, err = api.get_chapters_for_manga(manga_id, 500)
  if err then vim.api.nvim_err_writeln("Failed to get chapters: "..err); return end
  if #chs == 0 then vim.notify("No chapters found") return end
  local labels = {}
  for i,c in ipairs(chs) do labels[i] = c.label end
  ui.select(labels, {prompt = "Pick chapter"}, function(choice, idx)
    if not choice then return end
    local chosen = chs[idx]
    M.download_and_open_chapter(chosen.id)
  end)
end

function M.download_and_open_chapter(chapter_id)
  -- get chapter meta and at-home server
  vim.notify("Fetching chapter info...")
  local chap, err = api.get_chapter(chapter_id)
  if err or not chap then vim.api.nvim_err_writeln("Failed to fetch chapter: "..(err or "no data")); return end
  local at, aerr = api.get_at_home(chapter_id)
  if aerr or not at then vim.api.nvim_err_writeln("Failed to fetch at-home server: "..(aerr or "no data")); return end

  -- determine file list (prefer attr.data then dataSaver)
  local img_list = {}
  local attr = chap.attributes or {}
  if attr.data and #attr.data > 0 then img_list = attr.data
  elseif attr.dataSaver and #attr.dataSaver > 0 then img_list = attr.dataSaver
  elseif attr.data and #attr.data == 0 and attr.dataSaver and #attr.dataSaver == 0 then
    vim.api.nvim_err_writeln("No image entries found in chapter attributes")
    return
  end

  local baseUrl = at.baseUrl or at.baseUrl -- at.data maybe depending on response
  if not baseUrl and at.baseUrl == nil then
    -- some responses nest baseUrl under at.baseUrl (compat)
    baseUrl = at.baseUrl
  end
  -- generate URLs: {base}/{mode}/{hash}/{filename} where mode is data or data-saver
  local chapter_hash = attr.hash
  if not chapter_hash then vim.api.nvim_err_writeln("Chapter hash missing"); return end

  local tempdir = util.make_temp_dir("nvim_manga_")
  vim.notify("Downloading chapter to "..tempdir)
  local files = {}
  for i, fname in ipairs(img_list) do
    -- try full quality first (data), else data-saver
    local mode = (attr.data and #attr.data>0) and "data" or "data-saver"
    local url = string.format("%s/%s/%s/%s", baseUrl, mode, chapter_hash, fname)
    local outname = string.format("%03d_%s", i, fname)
    local dest = tempdir .. "/" .. outname
    local ok, derr = util.download_file(url, dest)
    if not ok then
      vim.api.nvim_err_writeln("Failed to download: "..url.." ("..tostring(derr)..")")
    else
      table.insert(files, dest)
      -- small progress notification
      if i % 5 == 0 then vim.notify(string.format("Downloaded %d/%d", i, #img_list)) end
    end
  end

  if #files == 0 then vim.api.nvim_err_writeln("No images downloaded") return end

  reader.open(files)
end

-- expose commands
function M.setup_commands()
  vim.cmd([[ command! MangaSearch lua require('manga').search_and_open() ]])
  vim.cmd([[ command! -nargs=1 MangaOpenLocal lua require('manga').open_local(<f-args>) ]])
  vim.cmd([[ command! MangaNext lua require('manga.reader').next() ]])
  vim.cmd([[ command! MangaPrev lua require('manga.reader').prev() ]])
  vim.cmd([[ command! MangaQuit lua require('manga.reader').quit() ]])
  vim.cmd([[ command! MangaStatus lua require('manga.reader').status() ]])
end

-- convenience: open a local directory (chapter) of images
function M.open_local(dir)
  if fn.isdirectory(dir) == 0 then vim.api.nvim_err_writeln("Not a directory: "..dir); return end
  local p = io.popen('ls -1 "'..dir:gsub('"','\\"')..'"')
  local files = {}
  for f in p:lines() do
    if f:lower():match("%.jpg$") or f:lower():match("%.jpeg$") or f:lower():match("%.png$") or f:lower():match("%.webp$") then
      table.insert(files, dir.."/"..f)
    end
  end
  p:close()
  table.sort(files)
  reader.open(files)
end

-- init
M.setup_commands()

return M
