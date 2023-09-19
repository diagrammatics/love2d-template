local text = {}

text.HORIZONTAL_MARGIN = 10 -- Horizontal margin between the text and window.
text.VERTICAL_MARGIN = 10 -- Vertical margins between components.

text.MAX_LINES = 200 -- How many lines to store in the buffer.
text.HISTORY_SIZE = 100 -- How much of history to store.

-- Color configurations.

text.CURSOR_RADIUS = 3
text.CURSOR_STYLE = "fill"

require "/lib/table-utils/table-utils" 

-- Store the printed lines in a buffer.
local lines = {}

-- Print a colored text to the text. Colored text is simply represented
-- as a table of values that alternate between an {r, g, b, a} object and a
-- string value.
function text.colorprint(coloredtext) table.insert(lines, coloredtext) end

-- Wrap the print function and redirect it to store into the line buffer.
local normal_print = print
_G.print = function(...)
  normal_print(...) -- Call original print function.
  local args = {...}
  local line = table.concat(map({...}, tostring), "\t")
  push(lines, line)

  while #lines > text.MAX_LINES do
    return -- table.remove(lines, 1)
  end
end

function text.draw()

  love.graphics.setColor(unpack(fg.color))
  love.graphics.setFont(text.FONT)

  local line_start = love.graphics.getHeight() - text.VERTICAL_MARGIN*3 - text.FONT:getHeight()
  local wraplimit = love.graphics.getWidth() - text.HORIZONTAL_MARGIN*2

  for i = #lines, 1, -1 do
    local textonly = lines[i]
    if type(lines[i]) == "table" then
      textonly = table.concat(filter(lines[i], function(val)
        return type(val) == "string"
      end), "")
    end
    width, wrapped = text.FONT:getWrap(textonly, wraplimit)

    love.graphics.printf(
      lines[i], text.HORIZONTAL_MARGIN,
      line_start - #wrapped * text.FONT:getHeight(),
      wraplimit, "left")
    line_start = line_start - #wrapped * text.FONT:getHeight()
  end

  -- draw console input box?
  
  love.graphics.setColor(unpack(fg.color))

  love.graphics.printf(
    text.HORIZONTAL_MARGIN,
    love.graphics.getHeight() - text.VERTICAL_MARGIN - text.FONT:getHeight(),
    love.graphics.getWidth() - text.HORIZONTAL_MARGIN*2, "left")

  function draw_cursor()
    local cursorx = text.HORIZONTAL_MARGIN +
      text.FONT:getWidth(text.PROMPT .. command.text:sub(0, command.cursor))
    love.graphics.rectangle(text.CURSOR_STYLE,
      cursorx,
      love.graphics.getHeight() - text.VERTICAL_MARGIN - text.FONT:getHeight(),
      text.FONT:getWidth(0),
      text.FONT:getHeight(0), text.CURSOR_RADIUS, text.CURSOR_RADIUS)
  end
  
  if love.timer.getTime() % 1 > 0.5 then
    draw_cursor()
  end

function text.textinput(input)
    return
  end
  -- todo: implement inserting text
end

function text.keypressed(key, scancode, isrepeat)
  local ctrl = love.keyboard.isDown("lctrl", "lgui")
  local shift = love.keyboard.isDown("lshift")
  local alt = love.keyboard.isDown("lalt")

  if key == 'backspace' then command:delete_backward()

  elseif key == "up" then command:previous()
  elseif key == "down" then command:next()

  elseif alt and key == "left" then command:backward_word()
  elseif alt and key == "right" then command:forward_word()

  elseif ctrl and key == "left" then command:beginning_of_line()
  elseif ctrl and key == "right" then command:end_of_line()

  elseif key == "left" then command:backward_character()
  elseif key == "right" then command:forward_character()

  elseif key == "=" and shift and ctrl then
      text.FONT_SIZE = text.FONT_SIZE + 1
      text.FONT = love.graphics.newFont(text.FONT_SIZE)
  elseif key == "-" and ctrl then
      text.FONT_SIZE = math.max(text.FONT_SIZE - 1, 1)
      text.FONT = love.graphics.newFont(text.FONT_SIZE)
end


return text

end
