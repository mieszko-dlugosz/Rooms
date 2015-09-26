-- to start with, we need to require the 'socket' lib (which is compiled
-- into love). socket provides low-level networking features.
local socket = require "socket"
 
-- the address and port of the server
--83.22.147.69
local address, port = "192.168.1.10", 12345
 
local updaterate = 0.1 -- how long to wait, in seconds, before requesting an update
 
local playerServer={}
local playerClient={}
local t
 
-- love.load, hopefully you are familiar with it from the callbacks tutorial
function love.load()
 
	-- first up, we need a udp socket, from which we'll do all
	-- out networking.
	udp = socket.udp()
 

	udp:settimeout(0)
 

	udp:setpeername(address, port)
 

	math.randomseed(os.time()) 
 

 
	entity = tostring(math.random(99999))
 
	--local dg = string.format("%s %s %d %d", entity, 'at', 320, 240)
	--udp:send(dg) -- the magic line in question.
 
	-- t is just a variable we use to help us with the update rate in love.update.
	t = 0 -- (re)set t to 0
end
 
-- love.update, hopefully you are familiar with it from the callbacks tutorial
function love.update(deltatime)
 
	t = t + deltatime -- increase t by the deltatime
 
	if t > updaterate then
    
		local dir
		if love.keyboard.isDown('up') then 	dir = 1 end
		if love.keyboard.isDown('down') then dir = 3 end
		if love.keyboard.isDown('left') then 	dir = 4 end
		if love.keyboard.isDown('right') then 	dir = 2 end
 
    if dir ~= nil then
      local dg = string.format("%d", dir)
      udp:send(dg)	
    end

   
 
		t=t-updaterate -- set t for the next round
	end
 
--	repeat
--		data, msg = udp:receive()
--		if data then 
--			ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
--			if cmd == 'at' then
--				local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
--				assert(x and y) -- validation is better, but asserts will serve.
--				x, y = tonumber(x), tonumber(y)
--				-- and finally we stash it away
--				world[ent] = {x=x, y=y}
--			else
--				print("unrecognised command:", cmd)
--			end
 
--		elseif msg ~= 'timeout' then 
--			error("Network error: "..tostring(msg))
--		end
--	until not data 
 
	--playerClient.y, playerClient.x, playerServer.y, playerServer.x = udp:receive()
  

  
  lel=udp:receive()
  print(lel)
  if lel then
    pcy, pcx, psy, psx=lel:match("(%S*) (%S*) (%S*) (%S*)")
    playerClient.y, playerClient.x, playerServer.y, playerServer.x  = tonumber(pcy), tonumber(pcx), tonumber(psy), tonumber(psx)
   end
   
end
 
-- love.draw, hopefully you are familiar with it from the callbacks tutorial
function love.draw() 
  if (playerClient.x ~= nil and playerClient.y ~= nil ) then
    love.graphics.print("playerClient", playerClient.x, playerClient.y)
  end
  if (playerServer.x ~= nil and playerServer.y ~= nil ) then
    love.graphics.print("playerServer", playerServer.x, playerServer.y) 
  end
end
 
-- And thats the end of the udp client example.
