local startup = function(env_var, projects_module, wezterm)
    local project = os.getenv(env_var)

    if project == nil then return end

    local status, project_module = pcall(function()
        return require(projects_module .. "." .. project)
    end)
    if not status then
        wezterm.log_error("Unable to import " .. project_module)
        return
    end
    local project_startup = project_module.startup

    if project_startup == nil or type(project_startup) ~= "function" then
        wezterm.log_error("Project " ..
            project .. " has no exported 'startup' function (type is " .. type(project_startup) .. ")")
        return
    end

    project_startup(wezterm)
end

local format_window_title = function(env_var, tab, tabs)
    -- BEGIN DEFAULT IMPLEMENTATION (https://wezfurlong.org/wezterm/config/lua/window-events/format-window-title.html)
    local zoomed = ''
    if tab.active_pane.is_zoomed then
        zoomed = '[Z] '
    end

    local index = ''
    if #tabs > 1 then
        index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end
    -- END DEFAULT IMPLEMENTATION

    local project = os.getenv(env_var)
    local project_name = project and project .. ' - ' or ''

    return project_name .. zoomed .. index .. tab.active_pane.title
end

return {
    startup = startup,
    format_window_title = format_window_title
}
