return {
    -- TODO: add to the global statusline
    -- TODO: interact with reactive? -- yes
    {
        'chrisgrieser/nvim-recorder',
        keys = {
            { 'gQ', desc = '󰑋 Start/stop macro recording' },
            { 'hQ', desc = '󰑋 Switch macro slot' },
            { 'Q', desc = '󰑋 Play macro' },
        },
        opts = {
            slots = { 'a', 'b', 'c', 'd', 'e' },
            mapping = {
                startStopRecording = 'gQ',
                switchSlot = 'hQ',
                playMacro = 'Q',
            },
            performanceOpts = {
                noSystemClipboard = false,
            },
        },
    },
}
