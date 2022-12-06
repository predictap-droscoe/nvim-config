-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Clone packer repo if not present
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

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

    use "towolf/vim-helm"

    use "andreshazard/vim-freemarker"

    -- Nerdtree
    use {
      "scrooloose/nerdtree",
      config = function()
        vim.g["NERDTreeWinSize"] = 60
      end
    }
    use "jistr/vim-nerdtree-tabs"
    use "Xuyuanp/nerdtree-git-plugin"
    use "PhilRunninger/nerdtree-visual-selection"

    -- QOL stuff
    use "tpope/vim-commentary"
    use "tpope/vim-sleuth"
    use "tpope/vim-surround"
    use {
      "tpope/vim-fugitive",
      requires = {"tpope/vim-rhubarb"},
      config = function()
        map("n", "<leader>gb", ":Git blame<CR>")
        map("n", "<leader>go", ":GBrowse<CR>")
        map("n", "<leader>gl", "v:GBrowse<CR>")
        map("v", "<leader>go", ":GBrowse<CR>")
      end
    }
    use "jiangmiao/auto-pairs"
    use {
      "alvan/vim-closetag",
      config = function()
        vim.g["closetag_filenames"] = "*.html,*.xhtml,*.phtml,*.php,*.jsx,*.tsx"
      end
    }
    use "airblade/vim-gitgutter"
    use {
      "rrethy/vim-hexokinase",
      run = "make hexokinase",
      config = function()
        map("n", "<leader>ct", ":HexokinaseToggle<cr>")
      end
    }

    -- fuzzy finding
    use {
      "junegunn/fzf.vim",
      requires = "junegunn/fzf",
      config = function()
        map("n", "<leader>ag", ":Ag<cr>")
      end
    }

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
            ensure_installed = "all",
            auto_install = true,
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
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        "nvim-lua/plenary.nvim"
      },
      config = function()
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        map("n", "gK", "<cmd>lua vim.lsp.buf.hover()<CR>")
        map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
        map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
        map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
        map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
        map("n", "<leader>e", "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>")
        map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
        map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
        map("n", "<leader>lr", "<cmd>LspRestart<CR>")

        local lspconfig = require("lspconfig")
        local servers = {"pyright", "rust_analyzer", "tflint", "dockerls"}
        local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup {
            capabilities = capabilities,
            flags = {
              debounce_text_changes = 150
            }
          }
        end

        lspconfig.eslint.setup {
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 150,
            settings = {
              packageManager = "yarn",
              workingDirectory = {
                mode = "auto"
              }
            }
          },
          on_attach = function()
            vim.cmd([[
            autocmd BufWritePre <buffer> :EslintFixAll
            ]])
          end
        }

        lspconfig.tsserver.setup {
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 150
          },
          on_attach = function(client, bufnr)
            client.resolved_capabilities.document_formatting = false
            client.resolved_capabilities.document_range_formatting = false
            local ts_utils = require("nvim-lsp-ts-utils")
            ts_utils.setup(
              {
                debug = true,
                eslint_bin = "eslint_d",
                eslint_enable_diagnostics = false,
                eslint_enable_code_actions = false,
                update_imports_on_move = true,
                require_confirmation_on_move = true,
                enable_formatting = true,
                formatter = "eslint_d",
                formatter_args = {
                  "--fix-to-stdout",
                  "--stdin",
                  "--stdin-filename",
                  "$FILENAME"
                },
                format_on_save = true
              }
            )
            ts_utils.setup_client(client)
            map("n", "<leader>ia", "<cmd>TSLspImportAll<cr>")
            map("n", "<leader>ic", "<cmd>TSLspImportCurrent<cr>")
          end,
          root_dir = lspconfig.util.root_pattern("package.json")
        }

        lspconfig.denols.setup {
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
          init_options = {
            lint = true,
            config = "./deno.json"
          }
        }
        vim.g.markdown_fenced_languages = {
          "ts=typescript"
        }

        lspconfig.html.setup {
          capabilities = capabilities
        }
      end
    }

    use {
      "hrsh7th/nvim-cmp",
      requires = {"L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "hrsh7th/cmp-buffer"},
      config = function()
        -- Set completeopt to have a better completion experience
        vim.o.completeopt = "menu,menuone,preview"
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
                select = false
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
        require("formatter").setup(
          {
            filetype = {
              python = {
                -- Configuration for psf/black
                function()
                  return {
                    exe = "black", -- this should be available on your $PATH
                    args = {"-"},
                    stdin = true
                  }
                end
              },
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
              }
            }
          }
        )
        map("n", "<leader>f", ":Format<CR>")
        vim.api.nvim_exec(
          [[
          augroup FormatAutogroup
            autocmd!
            autocmd BufWritePost *.py,*.sh,*.rs,*.lua FormatWrite
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
        map("n", "<leader>sw", ":HopWord<CR>")
        map("n", "<leader>sl", ":HopLine<CR>")

        map("n", "<leader>hc", ":HopChar1<CR>")
        map("n", "<leader>hb", ":HopChar2<CR>")
      end
    }

    use {
      "vim-test/vim-test",
      config = function()
        map("n", "<leader>tf", ":TestFile<cr>")
        map("n", "<leader>tc", ":TestNearest<cr>")
        map("n", "<leader>tl", ":TestLast<cr>")
        map("n", "<leader>tv", ":TestVisit<cr>")
        vim.api.nvim_exec([[
          let test#strategy = "neovim"
        ]], true)
      end
    }

    if packer_bootstrap then
      require("packer").sync()
    end
  end
)
