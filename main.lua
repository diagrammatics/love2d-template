lurker = require "/lib/lurker/lurker"
draggable = require "/lib/draggable/draggable"

require "/setup"

function love.load()
  love.graphics.setBackgroundColor(unpack(bg.color))
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    love.event.quit()
  end
  if key == 'tab' then
    love.event.quit("restart")
  end
  if key == 'ralt' then -- right alt
    love.window.setMode(ww, wh, {borderless=false})
  end
---  


---
end

function love.draw()
---

---
end

function love.update(dt)  
---

---
  require("/lib/lurker/lurker").update()
end
