-- Shorthands
lg = love.graphics
fs = love.filesystem
lm = love.mouse
floor = math.floor

-- Defining a few shaders
local shader = {
    -- Wavy distortion
    lg.newShader([[
        extern vec2 size;
        extern number time;
        extern number scale;
        extern number intensity;
        vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
            tc.x = tc.x + sin(tc.y * (size.y * scale) + time) * intensity;
            tc.y = tc.y + sin(tc.x * (size.x * scale) + time) * intensity;
            return Texel(tex, tc);
        }
    ]]),
    -- Inverts the colors 
    lg.newShader([[
        vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
            vec4 pixel = Texel(tex, tc);
            return vec4(1-pixel.r, 1-pixel.g, 1-pixel.b, 1.0);
        }
    ]]),
    -- Rgb split
    lg.newShader([[
        extern number time;
        vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
            number offset = distance(tc, vec2(0.5, 0.5)) * cos(time) * 0.1;
            return vec4( Texel(tex, tc + offset).r, Texel(tex, tc).g, Texel(tex, tc - offset).b, 1.0 );
        }
    ]]),
    -- Desaturation
    lg.newShader([[
    vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
        vec4 pixel = Texel(tex, tc);
        number average = (pixel.r + pixel.g + pixel.b) / 3.0;
        return vec4(average, average, average, 1.0);
    }
]])
}

function love.load()
    -- Loading pp
    multishader = require "multishader"

    -- Loading the first .jpg in the root folder.
    image = false
    for i,v in ipairs(fs.getDirectoryItems("")) do
        if v:find("%.jpg$") then
            image = lg.newImage(v)
            break
        end
    end
    -- Setting the window size to the image size
    love.window.setMode(image:getWidth(), image:getHeight())

    -- Creating a pp canvas & drawing the image to it
    canvas = pp.new()
    canvas:drawTo(function() lg.draw(image) end)

    -- This table will contain the currently active shaders
    activeShaders = {}

    -- Sending data to shaders
    shader[1]:send("size", {image:getWidth(), image:getHeight()})
    shader[1]:send("scale", 0.1)
    shader[1]:send("intensity", 0.01)

    -- Time variable used in some shaders
    time = 0
end

function love.update(dt)
    -- Calculating a normalized mouse position. 
    local normalX = lm.getX() / lg.getWidth()
    local normalY = lm.getY() / lg.getHeight()
    -- Incrementing the time
    time = time + dt

    -- Activating shaders based on mouse position.
    local activeCount = floor(#shader * normalX) + 1
    activeShaders = {}
    if normalY < 0.5 then
        for i=1, activeCount do
            activeShaders[i] = shader[i]
        end
    end

    --Sending time to shaders that use it
    shader[1]:send("time", time)
    --shader[3]:send("time", time)
end

function love.draw()
    -- Drawing the pp object and passing activeShaders to it.
    canvas:draw(unpack(activeShaders))
end

function love.keypressed(key)
    -- Exiting if escape is pressed
    if key == "escape" then love.event.push("quit") end
end