Colors = require('colors')
Funcs = require('functions')
Data = require('db/data')


BASE_VALUES = {
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0},
    {0, 0, 0, 0}
}

function love.load()
    width = 450
    height = 600
    spacing = 4
    side = width / 4
    current_score = 0
    best_score = 0

    tiles = {}

    local data = Data.load_data()
    if data then 
        Funcs.set_game_tiles(data.tiles)
        current_score = data.current_score
        total_score = data.total_score
    else 
        Funcs.start_new_game(BASE_VALUES) 
        Data.save_data(tiles, current_score, best_score)
    end

    current_score_label = {
        text = 'Current Score',
        width = (width / 2) - 12,
        height = 62,
        y = Funcs.calc_position(#tiles + 0.4, 120, 62),
        x = 8
    }
    best_score_label = {
        text = 'Best Score',
        width = (width / 2) - 12,
        height = 62,
        y = Funcs.calc_position(#tiles + 0.4, 120, 62),
        x =  current_score_label.x * 2 + (width / 2) - 12,
    }

    buttons = {
        reset_btn = {
            text = 'Reset',
            width = width - 16,
            height = 42,
            bg_color = Colors.blue,
            fg_color = Colors.primary,
            y = Funcs.calc_position(#tiles + 1, 120, 62),
            x = 8,
            click_event = Funcs.start_new_game
        }
    }

    love.graphics.setBackgroundColor(Colors.primary)
    love.window.setMode(width, height, {resizable=false})
    love.window.setTitle('2048')

    font = love.graphics.newFont(28)
    font_sm = love.graphics.newFont(12)
end

function love.keypressed(key, _, _)
    local action
    if key == 'up' or key == 'w' then action = Funcs.move_up
    elseif key == 'left' or key == 'a' then action = Funcs.move_left
    elseif key == 'down' or key == 's' then action = Funcs.move_down
    elseif key == 'right' or key == 'd' then action = Funcs.move_right
    end

    if action and action() > 0 then 
        Funcs.generate_new_tile() 
        if (current_score > best_score) then best_score = current_score end
        Data.save_data(tiles, current_score, best_score)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    for _, btn in pairs(buttons) do
        if x > btn.x and x < btn.x + btn.width and y > btn.y and y < btn.y + btn.height then 
            btn.click_event()
        end
    end
end

function love.draw()
    love.graphics.setFont(font)

    for i, row in ipairs(tiles) do
        local y = Funcs.calc_position(i, side, spacing)
        for j, tile in ipairs(row) do
            local x = Funcs.calc_position(j, side, spacing)
            if tile.value ~= 0 then
                local color = Colors[tile.value]
                if color == nil then
                    color = Colors[0]
                end

                love.graphics.setColor(color)
                love.graphics.rectangle("fill", tile.x, tile.y, tile.width, tile.height, 8, 8)
                love.graphics.setColor(Colors.primary)
                love.graphics.printf(tile.value, tile.x, tile.y + (side * 0.3), tile.width, 'center')
            else
                love.graphics.setColor(Colors.secondary)
                love.graphics.rectangle("fill", x, y, tile.width, tile.height, 8, 8)
            end
        end
    end

    love.graphics.setColor(Colors.secondary)
    love.graphics.rectangle("fill", current_score_label.x, current_score_label.y, current_score_label.width, current_score_label.height, 4, 4)

    love.graphics.setFont(font_sm)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.printf(current_score_label.text, current_score_label.x + 4, current_score_label.y + 4, current_score_label.width, 'left')

    love.graphics.setFont(font)
    love.graphics.setColor(Colors.white)
    love.graphics.printf(current_score, current_score_label.x + 8, current_score_label.y + (current_score_label.width * 0.1), current_score_label.width, 'left')


    love.graphics.setColor(Colors.secondary)
    love.graphics.rectangle("fill", best_score_label.x, best_score_label.y, best_score_label.width, best_score_label.height, 4, 4)

    love.graphics.setFont(font_sm)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.printf(best_score_label.text, best_score_label.x + 4, best_score_label.y + 4, best_score_label.width, 'left')

    love.graphics.setFont(font)
    love.graphics.setColor(Colors.gold)
    love.graphics.printf(best_score, best_score_label.x + 8, best_score_label.y + (best_score_label.width * 0.1), best_score_label.width, 'left')

    for _, btn in pairs(buttons) do
        love.graphics.setColor(btn.bg_color)
        love.graphics.rectangle("fill", btn.x, btn.y, btn.width, btn.height, 4, 4)
        love.graphics.setFont(font)
        love.graphics.setColor(btn.fg_color)
        love.graphics.printf(btn.text, btn.x, btn.y + 4, btn.width, 'center')
    end
end