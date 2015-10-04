Player = Class{
  init = function(self, x, y)
    self.x = x
    self.y = y
    self.display_x = x
    self.display_y = y
  end;
  
  draw = function(self)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.circle("fill", margin/2+tile_size*(self.x-1)+tile_size/2, margin/2+tile_size*(self.y-1)+tile_size/2, tile_size/4*2, 14)
    love.graphics.setColor(255, 255, 255, 255)
  end;
  
  move = function(self, dir)
    local new_x = self.x + dx[dir]
    local new_y = self.y + dy[dir]
    print(new_x.. " " .. new_y)
    if map:penetrable(new_y, new_x) then
      self.x = new_x
      self.y = new_y
    end
    if map[new_y][new_x] == 0 then
      map.canvas_uptodate = false
      map[new_y][new_x] = 15
    end
  end;
}