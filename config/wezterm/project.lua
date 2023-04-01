local file_exists = function(name)
    local file = io.open(name, "r")
    if file ~= nil then
        io.close(file)
        return true
    else
        return false
    end
end

local startup = function(env_var, base_path, wezterm)
    local project = os.getenv(env_var)

    if project == nil then return end

    local project_path = base_path .. "/" .. project
    if not file_exists(project_path) then
        wezterm.log_error("Project file does not exist: " .. project_path)
        return
    end

    local project_config = dofile(project_path)
    local project_startup = project_config.startup

    if project_startup == nil or type(project_startup) ~= "function" then
        wezterm.log_error("Project " ..
            project .. " has no exported 'startup' function (type is " .. type(project_startup) .. ")")
        return
    end

    project_startup(wezterm)
end

return {
    startup = startup
}
