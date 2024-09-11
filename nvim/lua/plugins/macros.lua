return {
    -- TODO: add to the global statusline
    -- TODO: interact with reactive?
    {
        'chrisgrieser/nvim-recorder',
        opts = {
            slots = { 'a', 'b', 'c', 'd', 'e' },
            mapping = {
                startStopRecording = ',q',
                switchSlot = '<leader>Q',
                playMacro = 'Q',
            },
            performanceOpts = {
                noSystemClipboard = false,
            },
        },
    },
}
