-- lua/manga/util.lua
local M = {}
local fn = vim.fn
local uv = vim.loop

-- create a temp directory for downloads
function M.make_temp_dir(prefix)
  prefix = prefix or "nvim_manga_"
  local base = fn.tempname()
  -- tempname returns a filename, convert to dir
  local dir = base .. "_" .. tostring(math.random(10000,99999))
  fn.mkdir(dir, "p")
  return dir
end

-- download a single url into dest (synchronous)
function M.download_file(url, dest)
  -- use curl -L -s -S -o dest url
  local cmd = {"curl", "-sS", "-L", "-o", dest, url}
  fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return false, "curl failed for " .. url
  end
  return true, nil
end

-- create a safe filename index like 001.jpg
function M.idx_name(idx, fname)
  local ext = fname:match("%.([^./\\]+)$") or "img"
  return string.format("%03d.%s", idx, ext)
end

-- helper: try to pick 'data' array else 'dataSaver'
function M.get_image_array_from_chapter(chapter_raw)
  if not chapter_raw or not chapter_raw.attributes then return nil end
  local attr = chapter_raw.attributes
  -- many clients expect attr.data (full) and attr.dataSaver
  if attr.data and #attr.data > 0 then
    return attr.data
  elseif attr.dataSaver and #attr.dataSaver > 0 then
    return attr.dataSaver
  end
  return nil
end

return M
