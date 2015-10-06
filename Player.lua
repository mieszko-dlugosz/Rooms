Player = Class{
  init = function(self, x, y)
    self.x = tonumber(x)
    self.y = tonumber(y)
    self.display_x = x
    self.display_y = y
  end;
  
  draw = function(self)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.circle("fill", margin/2+tile_size*(self.x-1)+tile_size/2, margin/2+tile_size*(self.y-1)+tile_size/2, tile_size/4*2, 14)
    love.graphics.setColor(255, 255, 255, 255)
  end;
  
  dig_tile = function(self)
    if map[self.y][self.x] == 0 then
      map.canvas_uptodate = false
      map[self.y][self.x] = 15
    end
  end;
  
  move = function(self, dir)
    local new_x = self.x + dx[dir]
    local new_y = self.y + dy[dir]
    if map:penetrable(new_y, new_x) then
      self.x = new_x
      self.y = new_y
    end
    self:dig_tile()
  end;
}