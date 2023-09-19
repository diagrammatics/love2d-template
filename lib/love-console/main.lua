local console = require "console"
love.keyboard.setKeyRepeat(true)

function love.init()
    love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function love.keypressed(key, scancode, isrepeat)
  console.keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
  console.textinput(text)
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  console.draw()
end
