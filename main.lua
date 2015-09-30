Gamestate = require "hump.gamestate"
Class = require "hump.class"
local socket = require "socket"
require "Gamepicture"

local menu = {} -- previously: Gamestate.new()
local game = {}
local network_identity
local address, port
local gamepicture

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
  if network_identity == "client" then
    local message=udp:receive()
    if message then
      gamepicture:update_picture(message)
    end
  elseif network_identity == "server" then
    local data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then
      if address == nil then
        address, port = msg_or_ip, port_or_nil
      else
        udp:sendto(gamepicture:serialize_picture(), address, port)
      end
      
      if data == 'up' then 	gamepicture.player_client.y = gamepicture.player_client.y-10 end
      if data == 'down' then gamepicture.player_client.y = gamepicture.player_client.y+10 end
      if data == 'left' then 	gamepicture.player_client.x = gamepicture.player_client.x-10 end
      if data == 'right' then 	gamepicture.player_client.x = gamepicture.player_client.x+10 end
        
    elseif msg_or_ip ~= "timeout" then
      error("unknown network error")
    end
  end
end

function game:draw()
  gamepicture:draw()
end

function game:keyreleased(key, code)
  if key == 'escape' then
    love.event.quit()
  end
  
  local dir
  if network_identity == "server" then
    if key == 'up' then 	gamepicture.player_server.y = gamepicture.player_server.y-10 end
    if key == 'down' then gamepicture.player_server.y = gamepicture.player_server.y+10 end
    if key == 'left' then 	gamepicture.player_server.x = gamepicture.player_server.x-10 end
    if key == 'right' then 	gamepicture.player_server.x = gamepicture.player_server.x+10 end
  elseif network_identity == "client" then
    udp:send(key)
  end
end

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end