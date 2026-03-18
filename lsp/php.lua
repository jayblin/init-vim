return {
    cmd = { "phpactor", "language-server" },
    filetypes = { "php" },
    root_markers = { 'composer.json', 'index.php' },
    init_options = {
        ["language_server_completion.trim_leading_dollar"] = true,
    }
}
