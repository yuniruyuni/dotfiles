-- Language servers, using the LSP client built into Neovim. nvim-lspconfig
-- only supplies the per-server definitions (command, filetypes, root markers).
--
-- Built-in mappings worth knowing: K (hover), grn (rename), gra (code action),
-- grr (references), gri (implementation), grt (type definition),
-- gO (document symbols), <C-]> (definition), ]d / [d (next/previous diagnostic).

-- server name (as in nvim-lspconfig) = the executable it runs
local servers = {
  bashls = "bash-language-server",
  gopls = "gopls",
  jsonls = "vscode-json-language-server",
  lua_ls = "lua-language-server",
  pyright = "pyright-langserver",
  ruff = "ruff",
  rust_analyzer = "rust-analyzer",
  terraformls = "terraform-ls",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
}

-- Enable only the servers that are installed on this machine, so a missing
-- one stays silent instead of raising an error whenever its filetype opens.
for name, executable in pairs(servers) do
  if vim.fn.executable(executable) == 1 then
    vim.lsp.enable(name)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("dotfiles_lsp", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method("textDocument/completion") then
      -- lets <C-y> apply what the server attaches to an item: snippets,
      -- automatic imports and other additional edits.
      vim.lsp.completion.enable(true, client.id, ev.buf)
    end
  end,
})

vim.diagnostic.config({
  virtual_text = true, -- show the message at the end of the line
  severity_sort = true,
})
