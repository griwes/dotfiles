local function render_markdown(method)
    return function()
        require('render-markdown')[method]()
    end
end

local function table_edit(method)
    return function()
        require('table-nvim.edit')[method]()
    end
end

local function obsidian_action(method)
    return function()
        require('obsidian.actions')[method]()
    end
end

local table_keymaps = {
    { 'hmtl', table_edit('insert_row_up'), '󰹹 Insert Markdown table row above' },
    { 'hmtk', table_edit('insert_row_down'), '󰹹 Insert Markdown table row below' },
    { 'hmtL', table_edit('move_row_up'), '󰹹 Move Markdown table row up' },
    { 'hmtK', table_edit('move_row_down'), '󰹹 Move Markdown table row down' },
    { 'hmtj', table_edit('insert_column_left'), '󰓫 Insert Markdown table column left' },
    { 'hmt;', table_edit('insert_column_right'), '󰓫 Insert Markdown table column right' },
    { 'hmtJ', table_edit('move_column_left'), '󰓫 Move Markdown table column left' },
    { 'hmt:', table_edit('move_column_right'), '󰓫 Move Markdown table column right' },
    { 'hmtn', table_edit('insert_table'), '󰓫 Insert Markdown table' },
    { 'hmtan', table_edit('insert_table_alt'), '󰓫 Insert Markdown table without outline' },
    { 'hmtd', table_edit('delete_current_column'), '󰆴 Delete Markdown table column' },
}

local function setup_table_keymaps(bufnr)
    for _, map in ipairs(table_keymaps) do
        vim.keymap.set('n', map[1], map[2], {
            buffer = bufnr,
            desc = map[3],
        })
    end
end

return {
    {
        'MeanderingProgrammer/render-markdown.nvim',
        cmd = 'RenderMarkdown',
        ft = { 'markdown' },
        keys = {
            { 'hmr', render_markdown('buf_toggle'), desc = '󰍔 Toggle Markdown rendering' },
            { 'hmR', render_markdown('preview'), desc = '󰍔 Preview rendered Markdown' },
            { 'hm+', render_markdown('expand'), desc = '󰍔 Expand Markdown anti-conceal' },
            { 'hm-', render_markdown('contract'), desc = '󰍔 Contract Markdown anti-conceal' },
        },
        opts = {
            code = {
                style = 'normal',
                position = 'right',
                disable_background = true,
            },
            file_types = { 'markdown' },
            overrides = {
                filetype = {},
            },
        },
    },
    {
        'SCJangra/table-nvim',
        ft = 'markdown',
        opts = {
            mappings = false,
        },
        config = function(_, opts)
            require('table-nvim').setup(opts)

            local group = vim.api.nvim_create_augroup('dotfiles.markdown_tables', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                group = group,
                pattern = 'markdown',
                callback = function(event)
                    setup_table_keymaps(event.buf)
                end,
            })

            if vim.bo.filetype == 'markdown' then
                setup_table_keymaps(0)
            end
        end,
    },
    {
        'obsidian-nvim/obsidian.nvim',
        version = '*', -- recommended, use latest release instead of latest commit
        lazy = true,
        cmd = 'Obsidian',
        event = {
            'BufReadPre ' .. vim.fn.expand('~') .. '/vaults/*.md',
            'BufNewFile ' .. vim.fn.expand('~') .. '/vaults/*.md',
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { 'hmO', '<cmd>Obsidian new<cr>', desc = '󰎔 New Obsidian note' },
            { 'hmd', '<cmd>Obsidian today<cr>', desc = '󱃰 Open Obsidian daily note' },
            { 'hmD', '<cmd>Obsidian dailies<cr>', desc = '󱃰 Pick Obsidian daily note' },
            { 'hmo', '<cmd>Obsidian quick_switch<cr>', desc = '󰱼 Pick Obsidian note' },
            { 'hms', '<cmd>Obsidian search<cr>', desc = '󰊄 Search Obsidian vault' },
            { 'hmb', '<cmd>Obsidian backlinks<cr>', desc = '󰌹 Pick Obsidian backlinks' },
            { 'hml', '<cmd>Obsidian links<cr>', desc = '󰌹 Pick Obsidian links' },
            { 'hmT', '<cmd>Obsidian template<cr>', desc = '󰏢 Insert Obsidian template' },
            { 'hmc', '<cmd>Obsidian toggle_checkbox<cr>', desc = '󰄬 Toggle Obsidian checkbox' },
            { 'hml', obsidian_action('link'), mode = 'x', desc = '󰌹 Link selection to Obsidian note' },
            { 'hmn', obsidian_action('link_new'), mode = 'x', desc = '󰎔 Link selection to new Obsidian note' },
            { 'hme', obsidian_action('extract_note'), mode = 'x', desc = '󰎔 Extract selection to Obsidian note' },
        },

        ---@module 'obsidian'
        ---@type obsidian.config
        opts = {
            legacy_commands = false,

            workspaces = {
                {
                    name = 'personal',
                    path = '~/vaults/personal',
                },
                {
                    name = 'work',
                    path = '~/vaults/work',
                },
            },

            notes_subdir = 'notes',
            daily_notes = {
                folder = 'dailies',
                date_format = '%Y-%m-%d',
                default_tags = 'daily-notes',
                -- template = 'templates/daily.md',
            },
            preferred_link_style = 'markdown',

            ---@param title string|?
            ---@return string
            note_id_func = function(title)
                -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                -- In this case a note with the title 'My new note' will be given an ID that looks
                -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
                local suffix = ''
                if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
                else
                    -- If title is nil, just add 4 random uppercase letters to the suffix.
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.time()) .. '-' .. suffix
            end,

            completion = {
                nvim_cmp = false,
                blink = true,
                min_chars = 2,
            },
        },
    },
    {
        'HakonHarnes/img-clip.nvim',
        cmd = {
            'PasteImage',
            'ImgClipDebug',
            'ImgClipConfig',
        },
        ft = { 'markdown', 'quarto', 'rmd', 'typst', 'tex', 'plaintex' },
        keys = {
            {
                'hmi',
                function()
                    require('img-clip').paste_image()
                end,
                desc = '󰥶 Paste image from clipboard',
            },
            {
                'hmI',
                function()
                    require('img-clip.config').print_config()
                end,
                desc = '󰥶 Show image paste config',
            },
        },
        opts = {
            default = {
                dir_path = 'assets',
                embed_image_as_base64 = false,
                relative_to_current_file = true,
                relative_template_path = true,
                prompt_for_file_name = false,
                drag_and_drop = {
                    enabled = true,
                    insert_mode = true,
                },
                use_absolute_path = false,
            },
            filetypes = {
                markdown = {
                    download_images = false,
                    template = '![$CURSOR]($FILE_PATH)',
                    url_encode_path = true,
                },
                quarto = {
                    download_images = false,
                    template = '![$CURSOR]($FILE_PATH)',
                    url_encode_path = true,
                },
                rmd = {
                    download_images = false,
                    template = '![$CURSOR]($FILE_PATH)',
                    url_encode_path = true,
                },
                typst = {
                    dir_path = 'assets',
                    use_absolute_path = false,
                },
                tex = {
                    dir_path = 'figures',
                    relative_template_path = false,
                    use_absolute_path = false,
                },
                plaintex = {
                    dir_path = 'figures',
                    relative_template_path = false,
                    use_absolute_path = false,
                },
            },
        },
    },
}
