vim.filetype.add({
    filename = {
        ['buf.yaml'] = 'buf-config',
        ['buf.gen.yaml'] = 'buf-config',
        ['buf.policy.yaml'] = 'buf-config',
        ['buf.lock'] = 'buf-config',
        ['.gitlab-ci.yml'] = 'yaml.gitlab',
        ['.gitlab-ci.yaml'] = 'yaml.gitlab',
        ['docker-compose.yml'] = 'yaml.docker-compose',
        ['docker-compose.yaml'] = 'yaml.docker-compose',
        ['compose.yml'] = 'yaml.docker-compose',
        ['compose.yaml'] = 'yaml.docker-compose',
    },
    pattern = {
        ['.*/playbooks/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/roles/.*/tasks/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/roles/.*/handlers/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/roles/.*/vars/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/roles/.*/defaults/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/group_vars/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/host_vars/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/inventory/.*%.ya?ml'] = 'yaml.ansible',
        ['.*/values%.ya?ml'] = 'yaml.helm-values',
        ['.*/helm/.*/.*%.ya?ml'] = 'yaml.helm-values',
        ['.*/charts/.*/.*%.ya?ml'] = 'yaml.helm-values',
    },
})

vim.treesitter.language.register('yaml', 'buf-config')
vim.treesitter.language.register('yaml', 'yaml.ansible')
vim.treesitter.language.register('yaml', 'yaml.docker-compose')
vim.treesitter.language.register('yaml', 'yaml.gitlab')
vim.treesitter.language.register('yaml', 'yaml.helm-values')
