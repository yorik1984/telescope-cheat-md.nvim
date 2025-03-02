local finders       = require("telescope.finders")
local pickers       = require("telescope.pickers")
local conf          = require("telescope.config").values
local previewers    = require("telescope.previewers")
local putils        = require("telescope.previewers.utils")
local actions       = require("telescope.actions")
local entry_display = require("telescope.pickers.entry_display")

local cheat_fd      = function(opts)
    opts = opts or {}

    if not opts.data or #opts.data == 0 then
        return
    end

    local concat_entry_name = function(entry)
        return entry.value.ns .. "/" .. entry.value.keyword
    end

    local entry_maker = function(entry)
        local displayer = entry_display.create {
            separator = " ",
            hl_chars = { ["|"] = "Delimiter" },
            items = {
                { width = 30 },
                { remaining = true },
            },
        }

        local make_display = function(entry)
            return displayer {
                { entry.value.keyword, "Directory" },
                { entry.value.ns,      "Type" },
            }
        end

        return {
            value = entry,
            ordinal = entry.keyword .. " " .. entry.ns,
            display = make_display,
        }
    end

    pickers.new(opts, {
        prompt_title    = "Cheats",
        finder          = finders.new_table {
            results     = opts.data,
            entry_maker = entry_maker,
        },
        sorter          = conf.generic_sorter(opts),
        previewer       = previewers.new_buffer_previewer {
            keep_last_buf      = true,
            get_buffer_by_name = function(_, entry) return concat_entry_name(entry) end,
            define_preview     = function(self, entry)
                if concat_entry_name(entry) ~= self.state.bufname then
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.value.content, "\n"))
                    putils.highlighter(self.state.bufnr, entry.value.ft)
                end
            end,
        },

        attach_mappings = function()
            local function openBuffer(cmd, prompt_bufnr)
                actions.close(prompt_bufnr)
                local last_bufnr = require("telescope.state").get_global_key("last_preview_bufnr")
                vim.cmd(cmd .. " " .. last_bufnr)
            end
            actions.select_default:replace(function(prompt_bufnr)
                openBuffer("buffer", prompt_bufnr)
            end)
            actions.select_horizontal:replace(function(prompt_bufnr)
                openBuffer("sbuffer", prompt_bufnr)
            end)
            actions.select_vertical:replace(function(prompt_bufnr)
                openBuffer("vert sbuffer", prompt_bufnr)
            end)
            actions.select_tab:replace(function(prompt_bufnr)
                openBuffer("tab sb", prompt_bufnr)
            end)

            return true
        end,
    }):find()
end

return require("telescope").register_extension {
    exports = {
        fd = function(opts)
            local data = require("telescope._extensions.cheat_md.db")
            opts.data = data:get()
            return data:ensure(function()
                return cheat_fd(opts)
            end)
        end,
        recache = function(_)
            require("telescope._extensions.cheat_md.db"):recache()
        end,
    },
}
