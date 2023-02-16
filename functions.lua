local funcs = {}

function already_merged(paired_tiles, target_tile)
    -- checks whatever the target tile is already merged with another tile or not (in current row)
    for _, pair in ipairs(paired_tiles) do
        if table.concat(pair) == table.concat(target_tile) then return true end
    end
    return false
end

function merge(i1, j1, i2, j2)
    -- merges two tiles
    tiles[i1][j1].value = tiles[i1][j1].value + tiles[i2][j2].value
    tiles[i2][j2].value = 0
end

function funcs.set_game_tiles(values)
    for i=1, 4 do
        tiles[i] = {}
        local y = funcs.calc_position(i, side, spacing)
        for j=1, 4 do
            local x = funcs.calc_position(j, side, spacing)
            tiles[i][j] = {value=values[i][j], x=x, y=y, width=side-8, height=side-8}
        end
    end
end


function funcs.generate_new_tile()
    empty_tiles = {}
    for i, row in ipairs(tiles) do
        for j, tile in ipairs(row) do 
            if tile.value == 0 then table.insert(empty_tiles, {i, j}) end
        end
    end

    -- if no empty tile left
    if #empty_tiles == 0 then return false end

    math.randomseed(os.time())
    local pos = empty_tiles[math.random(#empty_tiles)]

    if math.random(1, 10) == 2 then
        tiles[pos[1]][pos[2]].value = 4
    else
        tiles[pos[1]][pos[2]].value = 2
    end 

    current_score = current_score + tiles[pos[1]][pos[2]].value

    return true
end


function funcs.calc_position(n, side, spacing)
    -- calculates position of the tile
    return (n - 1) * side + spacing
end


function funcs.start_new_game() 
    funcs.set_game_tiles(BASE_VALUES)
    current_score = 0
    funcs.generate_new_tile()
    funcs.generate_new_tile()
end


function funcs.move_left()
    local paired_tiles = {}
    local moves = 0

    for i, row in ipairs(tiles) do
        for j, tile in ipairs(row) do
            if tile.value ~= 0 then
                local destination = j
                local paired = false

                while destination - 1 > 0 do
                    if row[destination - 1].value == 0 then
                        destination = destination - 1 
                    elseif row[destination - 1].value == tile.value and not paired then
                        if already_merged(paired_tiles, {i, destination - 1}) then break end

                        merge(i, j, i, destination - 1)
                        paired = true
                        destination = destination - 1 
                    else
                        break
                    end
                end
                if destination ~= j then 
                    tiles[i][j].value, tiles[i][destination].value = tiles[i][destination].value, tiles[i][j].value
                    moves = moves + 1
                end
                if paired then table.insert(paired_tiles, {i, destination}) end
            end
        end
    end

    return moves
end

function funcs.move_right()
    local paired_tiles = {}
    local moves = 0 

    for i=#tiles, 1, -1 do
        local row = tiles[i]
        for j=#row, 1, -1 do
            local tile = row[j]
            if tile.value ~= 0 then
                local destination = j
                local paired = false
                while destination + 1 <= #row do 
                    if row[destination + 1].value == 0 then
                        destination = destination + 1 
                    elseif row[destination + 1].value == tile.value and not paired then
                        if already_merged(paired_tiles, {i, destination + 1}) then break end

                        merge(i, j, i, destination + 1)
                        paired = true
                        destination = destination + 1 
                    else
                        break
                    end
                end
                if destination ~= j then 
                    tiles[i][j].value, tiles[i][destination].value = tiles[i][destination].value, tiles[i][j].value
                    moves = moves + 1
                end
                if paired then table.insert(paired_tiles, {i, destination}) end
            end
        end
    end

    return moves
end

function funcs.move_up()
    local paired_tiles = {}
    local moves = 0

    for i, row in ipairs(tiles) do
        for j, tile in ipairs(row) do
            if tile.value ~= 0 then
                local destination = i
                local paired = false
                while destination - 1 > 0 do 
                    if tiles[destination - 1][j].value == 0 then
                        destination = destination - 1 
                    elseif tiles[destination - 1][j].value == tile.value and not paired then
                        if already_merged(paired_tiles, {destination - 1, j}) then break end

                        merge(i, j, destination - 1, j)
                        paired = true
                        destination = destination - 1 
                    else
                        break
                    end 
                end
                if destination ~= i then 
                    tiles[i][j].value, tiles[destination][j].value = tiles[destination][j].value, tiles[i][j].value
                    moves = moves + 1
                end
                if paired then table.insert(paired_tiles, {destination, j}) end
            end
        end
    end

    return moves
end

function funcs.move_down()
    local paired_tiles = {}
    local moves = 0

    for i=#tiles, 1, -1 do
        local row = tiles[i]
        for j=#row, 1, -1 do
            local tile = row[j]
            if tile.value ~= 0 then
                local destination = i
                local paired  = false
                while destination + 1 <= #tiles do
                    if tiles[destination + 1][j].value == 0 then
                        destination = destination + 1 
                    elseif tiles[destination + 1][j].value == tile.value and not paired then
                        if already_merged(paired_tiles, {destination + 1, j}) then break end

                        merge(i, j, destination + 1, j)
                        paired = true
                        destination = destination + 1 
                    else
                        break
                    end 
                end
                if destination ~= i then 
                    tiles[i][j].value, tiles[destination][j].value = tiles[destination][j].value, tiles[i][j].value
                    moves = moves + 1
                end
                if paired then table.insert(paired_tiles, {destination, j}) end
            end
        end
    end

    return moves
end

return funcs