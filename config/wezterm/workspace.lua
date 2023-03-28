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
    local workspace = os.getenv(env_var)

    if workspace == nil then return end

    local workspace_file_path = base_path .. "/" .. workspace
    if not file_exists(workspace_file_path) then
        wezterm.log_error("Workspace file does not exist: " .. workspace_file_path)
        return
    end

    local workspace_config = dofile(workspace_file_path)
    local workspace_startup = workspace_config.startup

    if workspace_startup == nil or type(workspace_startup) ~= "function" then
        wezterm.log_error("Workspace " ..
            workspace .. " has no exported 'startup' function (type is " .. type(workspace_startup) .. ")")
        return
    end

    workspace_startup(wezterm)
end

return {
    startup = startup
}
