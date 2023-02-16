JSON = require("JSON")

local FILE = 'db/data.json'
local data = {}

function data.load_data()
    local f = io.open(FILE, 'r')
    if not f then return nil end

    local json = f:read '*a'

    f:close()

    local data = JSON:decode(json)
    return data
end

function data.save_data(tiles, current_score, best_score)
    local f = io.open(FILE, 'w')
    local values = {}

    for i, row in ipairs(tiles) do
        values[i] = {}
        for j, tile in ipairs(row) do
            values[i][j] = tile.value
        end
    end

    local json = JSON:encode({
        tiles = values,
        current_score = current_score,
        best_score = best_score
    })
    -- print(json)
    f:write(json)
    f:close()
end

return data
  