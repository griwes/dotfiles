" language client

" required for operations modifying multiple buffers like rename
set hidden

" remember to -xc++ in compile_flags.txt for C++ .h headers to work, eh

" teach vim about coroutine keywords
fun! TeachCoroutineKeywords()
    syn keyword Keyword co_await co_yield co_return
endfu
autocmd Filetype cpp :call TeachCoroutineKeywords()

" semantic highlight
"
highlight default LspNamespace guifg=Yellow
highlight default link LspType Type
highlight default link LspClass LspType
highlight default link LspEnum LspType
highlight default link LspInterface Type
highlight default link LspStruct Type
highlight default link LspTypeParameter Type
highlight default LspParameter guifg=aquamarine
highlight default LspVariable guifg=LightSteelBlue3
highlight default LspProperty guifg=LightBlue
highlight default LspEnumMember guifg=LightGreen
highlight default link LspFunction Function
highlight default link LspMethod LspProperty
highlight default link LspMacro Macro
highlight default link LspKeyword Keyword
" highlight default link LspModifier
highlight default link LspComment Comment
highlight default link LspString String
highlight default link LspNumber Number
highlight default link LspRegexp String
highlight default link LspOperator Operator
" highlight default link LspDecorator

highlight default LspConcept guifg=wheat

highlight default LspFunctionScope gui=italic
highlight default link LspDependentName LspProperty

" auto-format C++
" don't format Vapor files
" don't format files with no filetype, because that blocks the LC forever
" should probably invest in its own filetype one day
autocmd BufRead * if empty(matchstr(@%, '*.vpr')) && !empty(&filetype) && !exists('b:formatting_autocmd_set')
    \ | execute 'autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false })'
    \ | let b:formatting_autocmd_set = 1
    \ | endif

" lsp
lua <<EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities["textDocument"]["completion"]["completionItem"]["snippetSupport"] = false
capabilities["textDocument"]["semanticTokens"] = { requests = { range = true, full = { delta = true }}}

local function sem_token_attach(_)
  vim.lsp.buf.semantic_tokens_full()
  vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.buf.semantic_tokens_full()]]
end

require("nvim-semantic-tokens").setup {
  preset = "default",
  -- highlighters is a list of modules following the interface of nvim-semantic-tokens.table-highlighter or
  -- function with the signature: highlight_token(ctx, token, highlight) where
  --        ctx (as defined in :h lsp-handler)
  --        token  (as defined in :h vim.lsp.semantic_tokens.on_full())
  --        highlight (a helper function that you can call (also multiple times) with the determined highlight group(s) as the only parameter)
  highlighters = { require 'nvim-semantic-tokens.table-highlighter'}
}

local table_hi = require 'nvim-semantic-tokens.table-highlighter'
table_hi.token_map["concept"] = "LspConcept"
table_hi.modifiers_map["dependentName"] = "LspDependentName"
table_hi.modifiers_map["functionScope"] = "LspFunctionScope"

require("clangd_extensions").setup {
  server = {
    cmd = { "clangd", [[--clang-tidy]], [[--completion-style=detailed]], [[--header-insertion=never]] },
    capabilities = capabilities,
    on_attach = function(client)
       sem_token_attach(client)
    end,
  },
}

require("rust-tools").setup {
  server = {
    capabilities = capabilities,
    on_attach = function(client)
    end,
  },
}

require("lsp_lines").setup()
vim.diagnostic.config({
  virtual_text = false,
})

require('nvim-lightbulb').setup {
    sign = {
        enabled = false
    },
    virtual_text = {
        enabled = true
    },
    autocmd = {
        enabled = true,
        events = {"CursorHold", "CursorHoldI"}
    }
}

require('illuminate').configure {
    delay = 500,
}
EOF

autocmd TextChanged * lua require("clangd_extensions.inlay_hints").set_inlay_hints()
autocmd TextChangedI * lua require("clangd_extensions.inlay_hints").set_inlay_hints()

" autocomplete
lua <<EOF
require('lsp_signature').setup({ hint_enable = false, hi_parameter = 'IlluminatedWordText' })

local cmp = require('cmp')

cmp.setup({
  window = {
    completion = cmp.config.window.bordered {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    },
    documentation = cmp.config.window.bordered {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
    },
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.recently_used,
      require("clangd_extensions.cmp_scores"),
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})
EOF

" debugging
lua <<EOF
local dap = require('dap')

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

local dapui = require('dapui');

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = true,
  layouts = {
    {
      -- You can change the order of elements in the sidebar
      elements = {
        -- Provide as ID strings or tables with "id" and "size" keys
        {
          id = "scopes",
          size = 0.25, -- Can be float or integer > 1
        },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 00.25 },
      },
      size = 40,
      position = "left", -- Can be "left", "right", "top", "bottom"
    },
    {
      elements = { "repl" },
      size = 10,
      position = "bottom", -- Can be "left", "right", "top", "bottom"
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

function _G.run_last()
    dap.run(_G._last_run_config)
end

function _G.run_specific(path)
    dap = require('dap')
    local config = {}
    for k,v in pairs(dap.configurations.cpp[1]) do
      config[k] = v
    end
    config['program'] = path
    _G._last_run_config = config
    dap.run(config)
end

function _G.run_specific_qemu(path)
    dap = require('dap')
    local config = {}
    for k,v in pairs(dap.configurations.cpp[1]) do
      config[k] = v
    end
    config['name'] = 'Remote attach'
    config['request'] = 'custom'
    config['program'] = ''
    config['targetCreateCommands'] = {}
    config['processCreateCommands'] = {}
    dap.run(config)
end
EOF

command -nargs=1 RunSpecific call v:lua.run_specific(<f-args>)
command -nargs=0 DebugQemu call v:lua.run_specific_qemu()
command -nargs=0 DebugFzf call fzf#run(fzf#wrap({'source': 'find . -type f -executable', 'sink': 'RunSpecific'}))
command -nargs=0 DebugLast call v:lua.run_last()
command -nargs=0 DebugClose lua require'dap'.terminate()
