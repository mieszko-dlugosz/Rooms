
function send_shader_vars()
  if network_identity == "server" then
    light_effect:send("light_pos", {(gamepicture.player_server.y-1+0.5)*tile_size+margin/2, (gamepicture.player_server.x-1+0.5)*tile_size+margin/2})
  else
    light_effect:send("light_pos", {(gamepicture.player_client.y-1+0.5)*tile_size+margin/2, (gamepicture.player_client.x-1+0.5)*tile_size+margin/2})
  end
  light_effect:send("iScreenSize", {window_width, window_height} )
end

light_effect = love.graphics.newShader [[
        extern vec2 light_pos;
        extern vec2 iScreenSize;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
         pixel_coords.y = iScreenSize.y-pixel_coords.y;
          float dist = sqrt(pow(pixel_coords.y-light_pos.x, 2.0)+pow(pixel_coords.x-light_pos.y, 2.0))/20.0;
          vec4 texturecolor = Texel(texture, texture_coords);
          if(texturecolor.x+texturecolor.y+texturecolor.z<0.1)
            return texturecolor;
          return texturecolor * 2.0/(pow(dist, 1.0)/2.0+2.5);
        }
    ]]
    
