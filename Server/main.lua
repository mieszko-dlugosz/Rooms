local socket = require "socket"

local running = true			--z update
local udp = socket.udp()		--z load
local playerServer = {}
local playerClient = {}

function love.load()
  playerClient.x = 300
  playerClient.y = 300
  playerServer.x = 400
  playerServer.y = 400
  udp:settimeout(0)

  udp:setsockname('*', 12345)
   

   
  local data, msg_or_ip, port_or_nil
  local entity, cmd, parms

end
-- and that the end of the udp server example.



function love.update()
  
  if love.keyboard.isDown('up') then 	playerServer.y = playerServer.y-10 end
  if love.keyboard.isDown('down') then playerServer.y = playerServer.y+10 end
  if love.keyboard.isDown('left') then 	playerServer.x = playerServer.x-10 end
  if love.keyboard.isDown('right') then 	playerServer.x = playerServer.x+10 end
  
-- the beginning of the loop proper...
print "Beginning server loop."
  data, msg_or_ip, port_or_nil = udp:receivefrom()
	if data then
		-- more of these funky match paterns!
		--entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
		--if cmd == 'move' then
			--local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
			--assert(x and y) -- validation is better, but asserts will serve.
			-- don't forget, even if you matched a "number", the result is still a string!
			-- thankfully conversion is easy in lua.
			dir = tonumber(data)
			-- and finally we stash it away
			--local ent = world[entity] or {x=0, y=0}
      if dir == 1 then
        playerClient.y = playerClient.y-10
      elseif dir == 2 then
        playerClient.x = playerClient.x+10
      elseif dir == 3 then
        playerClient.y = playerClient.y+10
      elseif dir == 4 then
        playerClient.x = playerClient.x-10
      else
        print("wrong data format")
      end
      udp:sendto(string.format("%d %d %d %d", playerClient.y, playerClient.x, playerServer.y, playerServer.x), msg_or_ip,  port_or_nil)
			--world[entity] = {x=ent.x+x, y=ent.y+y}
--		elseif cmd == 'at' then
--			local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
--			assert(x and y) -- validation is better, but asserts will serve.
--			x, y = tonumber(x), tonumber(y)
--			world[entity] = {x=x, y=y}
--		elseif cmd == 'update' then
--			for k, v in pairs(world) do
--				udp:sendto(string.format("%s %s %d %d", k, 'at', v.x, v.y), msg_or_ip,  port_or_nil)
--			end
--		elseif cmd == 'quit' then
--			running = false;
--		else
--			print("unrecognised command:", cmd)
--		end
	elseif msg_or_ip ~= 'timeout' then
		error("Unknown network error: "..tostring(msg))
	end
    
	socket.sleep(0.01)
    
print "Thank you."
end

function love.draw()
  love.graphics.print("playerClient", playerClient.x, playerClient.y)
  love.graphics.print("playerServer", playerServer.x, playerServer.y)
end