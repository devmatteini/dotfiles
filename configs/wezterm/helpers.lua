local tables = {}

--- @param first table
--- @param second table
--- @return table
function tables.concat(first, second)
    local new_table = {}
    for _, x in ipairs(first) do
        table.insert(new_table, x)
    end
    for _, x in ipairs(second) do
        table.insert(new_table, x)
    end
    return new_table
end

return {
    tables = tables
}
