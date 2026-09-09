local source = {}

function source.new()
  return {
    get_completions = function(_, context, callback)
      local items = vim.fn["dadbod#completion"](0, "")
      if type(items) ~= "table" then
        items = {}
      end
      local results = {}
      for _, item in ipairs(items) do
        local label = type(item) == "table" and item.word or item
        table.insert(results, {
          label = label,
          kind = vim.lsp.protocol.CompletionItemKind.Text,
        })
      end
      callback({ is_incomplete = false, items = results })
    end,
  }
end

return source
