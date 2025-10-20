return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
      },
    },
    branch = 'main',
    lazy = false,
    version = false,
    build = ':TSUpdate',
    opts = {
      install_dir = vim.fn.stdpath('data') .. '/site',
    },
    config = function(_, opts)
      -- Setup nvim-treesitter
      require('nvim-treesitter').setup(opts)

      -- Install parsers
      require('nvim-treesitter').install({
        'bash',
        'c',
        'css',
        'diff',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'php',
        'printf',
        'python',
        'query',
        'regex',
        'scss',
        'sql',
        'toml',
        'tsx',
        'tmux',
        'typescript',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      })

      -- Setup textobjects using the correct module
      require('nvim-treesitter-textobjects').setup({
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'select around function' },
            ['if'] = { query = '@function.inner', desc = 'select inner function' },
            ['ac'] = { query = '@class.outer', desc = 'select around class' },
            ['ic'] = { query = '@class.inner', desc = 'select inner part of a class region' },
            ['as'] = { query = '@local.scope', query_group = 'locals', desc = 'select language scope' },
            ['ia'] = { query = '@parameter.inner', desc = 'select inner parameter' },
            ['aa'] = { query = '@parameter.outer', desc = 'select around parameter (with commas)' },
          },
        },
      })

      -- Enable treesitter features via autocommand (only for valid filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_features', { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local ft = ev.match

          -- Skip special/internal filetypes
          if ft == '' or ft:match('^%w+_') or not vim.bo[buf].modifiable then
            return
          end

          -- Check if a parser exists for this filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          -- Try to enable highlighting
          local ok = pcall(vim.treesitter.start, buf)
          if not ok then
            return
          end

          -- Enable folding
          vim.wo[0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0].foldmethod = 'expr'

          -- Enable indentation (experimental)
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
