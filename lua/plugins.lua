-- This file can be loaded by calling `lua require('plugins')` from your init.vim

function map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return require("packer").startup(
  function()
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- Nerdtree
    use "scrooloose/nerdtree"
    use "jistr/vim-nerdtree-tabs"
    use "Xuyuanp/nerdtree-git-plugin"
    use "PhilRunninger/nerdtree-visual-selection"

    -- QOL stuff
    use "tpope/vim-commentary"
    use "tpope/vim-sleuth"
    use "tpope/vim-surround"
    use "tpope/vim-fugitive"
    use "tpope/vim-endwise"
    use "rstacruz/vim-closer"
    use "airblade/vim-gitgutter"

    -- fuzzy finding
    use "junegunn/fzf"
    use "junegunn/fzf.vim"

    -- colorscheme
    use "nanotech/jellybeans.vim"

    use {
      "vim-airline/vim-airline",
      requires = "vim-airline/vim-airline-themes",
      config = function()
        vim.g["airline_theme"] = "jellybeans"
        vim.g["airline#extensions#syntastic#enabled"] = 1
        vim.g["airline#extensions#branch#enabled"] = 1
        vim.g["airline#extensions#tabline#enabled"] = 1
        vim.g["airline#extensions#tagbar#enabled"] = 1
        vim.g["airline_skip_empty_sections"] = 1
        vim.g["airline#extensions#tabline#ignore_bufadd_pat"] = "!|nerd_tree|undotree"
      end
    }

    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup(
          {
            ensure_installed = "maintained",
            highlight = {
              enable = true
            },
            indent = {
              enable = true
            }
          }
        )
      end
    }

    use {
      "neovim/nvim-lspconfig",
      requires = "hrsh7th/cmp-nvim-lsp",
      config = function()
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
        map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
        map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
        map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
        map("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
        map("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
        map("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
        map("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
        map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")

        local lspconfig = require("lspconfig")
        local servers = {"pyright", "rust_analyzer", "tsserver", "tflint", "dockerls"}
        local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup {
            capabilities = capabilities,
            flags = {
              debounce_text_changes = 150
            }
          }
        end

        lspconfig.html.setup {
          capabilities = capabilities,
          on_attach = on_attach
        }
      end
    }
    use {
      "hrsh7th/nvim-cmp",
      requires = {"L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-buffer"},
      config = function()
        -- Set completeopt to have a better completion experience
        vim.o.completeopt = "menu,menuone,noselect"
        -- luasnip setup
        local luasnip = require "luasnip"

        -- nvim-cmp setup
        local cmp = require "cmp"
        cmp.setup(
          {
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end
            },
            mapping = {
              ["<C-p>"] = cmp.mapping.select_prev_item(),
              ["<C-n>"] = cmp.mapping.select_next_item(),
              ["<C-d>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.close(),
              ["<CR>"] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true
              },
              ["<Tab>"] = function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                else
                  fallback()
                end
              end,
              ["<S-Tab>"] = function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                else
                  fallback()
                end
              end
            },
            sources = {
              {name = "nvim_lsp"},
              {name = "luasnip"},
              {name = "buffer"}
            }
          }
        )
      end
    }

    use {
      "mhartington/formatter.nvim",
      config = function()
        local tsopts = {
          -- prettier
          function()
            return {
              exe = "npx prettier",
              args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
              stdin = true
            }
          end
        }
        require("formatter").setup(
          {
            filetype = {
              lua = {
                -- luafmt
                function()
                  return {
                    exe = "luafmt",
                    args = {"--indent-count", 2, "--stdin"},
                    stdin = true
                  }
                end
              },
              rust = {
                -- Rustfmt
                function()
                  return {
                    exe = "rustfmt",
                    args = {"--emit=stdout"},
                    stdin = true
                  }
                end
              },
              sh = {
                -- Shell Script Formatter
                function()
                  return {
                    exe = "shfmt",
                    args = {"-i", 2},
                    stdin = true
                  }
                end
              },
              javascript = tsopts,
              javascriptreact = tsopts,
              typescript = tsopts,
              typescriptreact = tsopts
            }
          }
        )
        map("n", "<leader>f", ":Format<CR>")
        vim.api.nvim_exec(
          [[
          augroup FormatAutogroup
            autocmd!
            autocmd BufWritePost *.ts,*.tsx,*.jsx,*.js,*.rs,*.lua FormatWrite
          augroup END
        ]],
          true
        )
      end
    }

    use {
      "phaazon/hop.nvim",
      as = "hop",
      config = function()
        require "hop".setup {keys = "etovxqpdygfblzhckisuran"}
        map("n", "<leader>hw", ":HopWord<CR>")
        map("n", "<leader>hl", ":HopLine<CR>")
        map("n", "<leader>hc", ":HopChar1<CR>")
        map("n", "<leader>hb", ":HopChar2<CR>")
      end
    }
  end
)
