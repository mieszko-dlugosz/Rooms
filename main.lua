Gamestate = require "hump.gamestate"
Class = require "hump.class"
local socket = require "socket"
require "Gamepicture"
require "Map"

local menu = {} -- previously: Gamestate.new()
local game = {}
local network_identity
local address, port
local gamepicture
local connection_rate = 0.05
local connection_timer = 0
local moving_timer = 0.0
local moving_rate = 0.05
tile_size = 20
margin = 80
dx = {0, 1, 0, -1}
dy = {-1, 0, 1, 0}


function menu:enter()
  love.window.setTitle("The Rooms")
end

function menu:draw()
    love.graphics.print("Press \"h\" to host, press \"j\" to join(UDP).", 10, 10)
end

function menu:keyreleased(key, code)    
  if key == 'escape' then
    love.event.quit()
  elseif key == 'j' then
    network_identity = "client"
    Gamestate.switch(game)
  elseif key == 'h' then
    network_identity = "server"
    Gamestate.switch(game)
  end

end

function game:enter()
  io.stdout:setvbuf("no")
  
  
  udp = socket.udp()
  udp:settimeout(0)
  gamepicture = Gamepicture()
  if network_identity == "client" then
    address, port = "192.168.1.3", 12345
    udp:setpeername(address, port)
  elseif network_identity == "server" then
    udp:setsockname('*', 12345)
  end
end

function game:update(dt)
  connection_timer = connection_timer+dt
  moving_timer = moving_timer + dt
  if connection_timer > connection_rate then
    connection_timer = 0
    if network_identity == "client" then
      local message=udp:receive()
      if message then
        gamepicture:update_picture(message)
      end
      message=udp:receive()
      if message then
        gamepicture:update_picture(message)
      end
    elseif network_identity == "server" then
      local data, msg_or_ip, port_or_nil = udp:receivefrom()
      local temp1, temp2, temp3 = udp:receivefrom()
      if temp3 then
        data, msg_or_ip, port_or_nil =  temp1, temp2, temp3 
      end
      if data then
        if address == nil then
          address, port = msg_or_ip, port_or_nil
        end
        
        if data == 'up' then 	gamepicture.player_client:move(1) end
        if data == 'down' then gamepicture.player_client:move(3) end
        if data == 'left' then 	gamepicture.player_client:move(4) end
        if data == 'right' then 	gamepicture.player_client:move(2) end
          
      elseif msg_or_ip ~= "timeout" then
        error("unknown network error")
      end
      
      if address ~= nil then
        udp:sendto(gamepicture:serialize_picture(), address, port)
      end
    end
  end
end

function game:draw()
  gamepicture:draw()
end

function game:keypressed(key, code)

  if key == 'escape' then
    love.event.quit()
  end
  
  if moving_timer > moving_rate then
    moving_timer = 0
    local dir
    if network_identity == "server" then
      if key == 'up' then 	gamepicture.player_server:move(1) end
      if key == 'down' then gamepicture.player_server:move(3) end
      if key == 'left' then 	gamepicture.player_server:move(4) end
      if key == 'right' then 	gamepicture.player_server:move(2) end
    elseif network_identity == "client" then
      udp:send(key)
    end
  end
end

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end