local p = require "plenary.path"
local M = {}
local parse = function(path)
    local content = p.readlines(path)
    if content[1]:find("---", 1, true) then
        local minus_count = 0
        while minus_count < 2 do
            if content[1]:find("---", 1, true) then
                minus_count = minus_count + 1
            end
            table.remove(content, 1)
        end
    end
    while content[1] == "" do
        table.remove(content, 1)
    end

    return table.concat(content, "\n")
end

M[2] = {
    name = "learnxinyminutes",
    uri = "https://github.com/adambard/learnxinyminutes-docs",
    root = "",
    depth = 1,
    pattern = ".*%.html%.markdown",
    add_dirs = false,
    ft = "markdown",
    parse = parse,
    get_ns_keyword = function(path)
        return "lang", path:match ".*/([^./]+).*"
    end,
}

M[4] = {
    name = "rstacruz-cheatsheets",
    uri = "https://github.com/rstacruz/cheatsheets",
    root = "",
    depth = 1,
    pattern = "%.md",
    add_dirs = false,
    ft = "markdown",
    parse = parse,
    get_ns_keyword = function(path)
        return "lang", path:match ".*/([^./]+).*"
    end,
}

return M
