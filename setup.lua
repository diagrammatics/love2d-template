-- ------ config

window = {
  width = 640,
  height = 480,
  open_x = 200,
  open_y = 200
}

love.keyboard.setKeyRepeat(true)
love.window.setMode(window.width, window.height,
 {borderless=true, highdpi=true})
ww, wh = love.graphics.getDimensions()
wx, wy = love.window.getPosition()

fg = {color = {0, 0, 0}}
bg = {
  enabled = true,
  color = {1, 1, 1},
  border = {
    enabled = true,
    color = {0,0,0},
    width = 2}}
    
--[[
    
console.FONT_SIZE = 22
typeface = love.graphics.newFont("/resources/Blex Mono.ttf", fontsize)
Fira = love.graphics.newFont("/resources/Fira Code.ttf", console.FONT_SIZE)
Iosevka = love.graphics.newFont("/resources/Iosevka.ttf", console.FONT_SIZE)
Blex = love.graphics.newFont("/resources/Blex Mono.ttf", console.FONT_SIZE)

console.FONT = Fira

]]--

-- Set up pixel perfection
love.graphics.setDefaultFilter("nearest", "nearest", 1)
love.graphics.setLineStyle("rough")
love.graphics.setLineWidth(1)

-- ------ window dragging

handle = {
  height = 20,
  width = 20,
  x = ww - 20,
  y = 0,
  r = 0.5,
  g = 0.5,
  b = 0.5,
  a = 0.4,
  hover = false
}

local cursor = love.mouse.getSystemCursor('sizeall')

local function inside_handle(x, y)
  return x > handle.x and x < handle.x + handle.width
    and y > handle.y and y < handle.y + handle.height
end

function love.mousemoved(x, y, dx, dy)
  if draggable.dragging() or inside_handle(x, y) then
    handle.hover = true
    love.mouse.setCursor(cursor)
  else
    handle.hover = false
    love.mouse.setCursor()
  end

  draggable.move(dx, dy)
end

function love.mousepressed(x, y, button)
  if inside_handle(x, y) then
    draggable.start()
  end
end

function love.mousereleased(x, y, button)
  draggable.stop()
end

draw_border = function(...)
  love.graphics.setColor(unpack(bg.border.color))
  love.graphics.rectangle("fill", 0, 0, ww, wh)
  love.graphics.setColor(unpack(bg.color))
  love.graphics.rectangle("fill", bg.border.width, bg.border.width, ww - bg.border.width*2, wh - bg.border.width*2, bg.border.radius, bg.border.segments)
end

draw_handle = function(...)
  love.graphics.setColor(handle.r, handle.g, handle.b, handle.a)
  love.graphics.polygon("fill", handle.x, handle.y, handle.x + handle.width, handle.y, handle.x+handle.width, handle.y + handle.height)
end