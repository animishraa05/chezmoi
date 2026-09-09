-- lua/manga/api.lua
-- Minimal MangaDex v5 API helper (uses curl via vim.fn.system)

local M = {}
local fn = vim.fn

local API_BASE = "https://api.mangadex.org"

local function http_get(url)
  -- simple synchronous GET using curl (follows redirects)
  local cmd = {"curl", "-sS", "-f", "-L", vim.fn.shellescape(url)}
  local res = fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil, ("HTTP error when GET %s"):format(url)
  end
  return res, nil
end

-- Search manga by title (limit results)
function M.search_manga(title, limit)
  limit = limit or 12
  if not title or title == "" then return nil, "empty title" end
  local url = string.format("%s/manga?title=%s&limit=%d", API_BASE, fn.escape(title, " "), limit)
  local body, err = http_get(url)
  if not body then return nil, err end
  local ok, json = pcall(fn.json_decode, body)
  if not ok then return nil, "failed to parse JSON from search" end
  -- each result entry has .data (manga object)
  local items = {}
  if json and json.data then
    for _, v in ipairs(json.data) do
      local id = v.id
      local title_en = "Unknown"
      if v.attributes and v.attributes.title then
        if v.attributes.title.en then
          title_en = v.attributes.title.en
        else
          local first_lang = next(v.attributes.title)
          if first_lang then
            title_en = v.attributes.title[first_lang]
          end
        end
      end
      table.insert(items, {id = id, title = title_en, raw = v})
    end
  end
  return items, nil
end

-- Get chapter list (manga feed) - fetch many with limit
function M.get_chapters_for_manga(manga_id, limit)
  limit = limit or 500
  local url = string.format("%s/manga/%s/feed?translatedLanguage[]=en&order[chapter]=asc&limit=%d", API_BASE, manga_id, limit)
  local body, err = http_get(url)
  if not body then return nil, err end
  local ok, json = pcall(fn.json_decode, body)
  if not ok then return nil, "failed to parse JSON from feed" end
  local out = {}
  if json and json.data then
    for _, ch in ipairs(json.data) do
      local attr = ch.attributes or {}
      local chapnum = tostring(attr.chapter or "") -- some chapters omit number
      local title = (attr.title and attr.title ~= "") and (" - " .. attr.title) or ""
      local label = string.format("%s%s (id:%s)", chapnum, title, ch.id)
      table.insert(out, {id = ch.id, label = label, raw = ch})
    end
  end
  -- sort by chapter number-ish (best-effort, numeric)
  table.sort(out, function(a,b)
    return a.label < b.label
  end)
  return out, nil
end

-- Get chapter details (attributes include hash and data/dataSaver)
function M.get_chapter(chapter_id)
  local url = string.format("%s/chapter/%s", API_BASE, chapter_id)
  local body, err = http_get(url)
  if not body then return nil, err end
  local ok, json = pcall(fn.json_decode, body)
  if not ok then return nil, "failed to parse JSON from chapter" end
  return json and json.data and json.data or nil, nil
end

-- Get at-home server baseUrl for a chapter
function M.get_at_home(chapter_id)
  local url = string.format("%s/at-home/server/%s", API_BASE, chapter_id)
  local body, err = http_get(url)
  if not body then return nil, err end
  local ok, json = pcall(fn.json_decode, body)
  if not ok then return nil, "failed to parse JSON from at-home" end
  return json and json.data and json.data or nil, nil
end

return M
