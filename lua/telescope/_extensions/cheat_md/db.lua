local raw     = require "telescope._extensions.cheat_md.raw"
local sqlite  = require "sqlite"

local VERSION = 0.1

local name    = "telescope-cheat-md"
local dbdir   = vim.fn.stdpath("data") .. "/databases"

---@class CheatDB:sqlite_db
---@field state sqlite_tbl
---@field cheat sqlite_tbl
local db      = sqlite {
    uri   = dbdir .. "/" .. name .. ".db",
    state = {
        id      = "number",
        version = "number",
    },
    cheat = {
        id      = {
            "integer",
            "primary",
            "key",
        },
        source  = "text",
        ns      = "text",
        keyword = "text",
        content = "text",
        ft      = "text",
    },
    opt   = {
        lazy = true,
    },

}
---@class sqlite_tbl
---@field fun string
local state   = db.state

function state:get_version()
    local version = self:where { id = 1 }
    return version and version.version or nil
end

function state:is_up_to_date()
    if not self:get_version() then
        self:insert { id = 1, version = VERSION }
    end
    return self:get_version() == VERSION
end

function state:change_version()
    return self:update {
        where = { id = 1 },
        set = { version = VERSION },
    }
end

local messages = {
    caching   = name .. ": caching databases ... ",
    recaching = name .. ": recaching databases ... ",
    success   = name .. ": databases has been successfully cached!",
}

---@class sqlite_tbl
---@field func string
local data = db.cheat

function data:seed(cb)
    print(messages.caching)
    return raw.get(function(rows)
        self:insert(rows)
        print(messages.success)
        cb()
    end)
end

function data:recache(cb)
    print(messages.recaching)
    return raw.get(function(rows)
        print(messages.success)
        self:replace(rows)
        if cb then
            return cb()
        end
    end)
end

function data:ensure(cb)
    if not vim.loop.fs_stat(dbdir) then
        vim.loop.fs_mkdir(dbdir, 493)
    end

    local up_to_date = state:is_up_to_date()
    local has_content = not self:empty()

    if up_to_date and not has_content then
        return self:seed(cb)
    elseif not up_to_date and has_content then
        state:change_version()
        return self:recache(cb)
    else
        cb()
    end
end

return data
