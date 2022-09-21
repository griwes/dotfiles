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

highlight default LspSemanticClassScopeMethod ctermfg=LightBlue guifg=LightBlue
highlight default LspSemanticClassScopeVariable ctermfg=LightBlue guifg=LightBlue
highlight default LspSemanticClassScopeProperty ctermfg=LightBlue guifg=LightBlue
highlight default link LspSemanticClassScopeDeclarationProperty LspSemanticClassScopeProperty
highlight default LspSemanticEnumMember ctermfg=LightGreen guifg=LightGreen
highlight default LspSemanticNamespace ctermfg=Yellow guifg=Yellow
highlight default LspSemanticVariable ctermfg=Grey guifg=Grey
highlight default LspSemanticParameter ctermfg=Grey guifg=Grey
highlight default link LspSemanticMacro Macro
highlight default link LspSemanticConcept LspSemanticClass
highlight default link LspSemanticClass Type

let g:lsp_semantic_enabled = 1

autocmd User lsp_setup call lsp#register_server({
    \   'name': 'clangd',
    \   'cmd': ['clangd', '--background-index', '--clang-tidy', '--completion-style=bundled', '--header-insertion=never'],
    \   'allowlist': ['c', 'cpp']
    \ })

" auto-format C++
" don't format Vapor files
" don't format files with no filetype, because that blocks the LC forever
" should probably invest in its own filetype one day
autocmd BufRead * if empty(matchstr(@%, '*.vpr')) && !empty(&filetype) && !exists('b:formatting_autocmd_set')
    \ | execute 'autocmd BufWritePre <buffer> LspDocumentFormatSync'
    \ | let b:formatting_autocmd_set = 1
    \ | endif

" quick fix
nmap <F9> :LspCodeAction quickfix<CR>

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
