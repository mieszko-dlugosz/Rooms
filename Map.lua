

Map = Class{
  init = function(self, filename)
    io.input(filename)
    
    local rows, cols = 0, 0
    for i=1, 13 do
      local line = io.read()
    end
    while true do
      local line = io.read()
      if line == nil or line == '' then break end
      cols = 0
      rows = rows + 1
      self[rows] = {}
      for i in string.gmatch(line, "(%d+)") do
        cols = cols + 1
        self[rows][cols] = tonumber(i)
      end
    end
    self.width = cols
    self.height = rows
    window_height = self.height*tile_size+margin
    window_width = self.width*tile_size+margin
    love.window.setMode(window_width, window_height, {})
    self.canvas_uptodate = false
    self.canvas = nil
  end;
  

  
  draw = function(self)
    if not self.canvas_uptodate then
      self.canvas_uptodate = true
      local rock = love.graphics.newImage("rock1.png") --TODO: move to init phase
      self.canvas = love.graphics.newCanvas(self.width*tile_size, self.height*tile_size)
      love.graphics.setCanvas(self.canvas)
      love.graphics.draw(rock, 0, 0, 0, self.width*tile_size/rock:getWidth(), self.height*tile_size/rock:getHeight() )
      
      for i=1, self.height do
        for j=1, self.width do
          if self[i][j] == 0 then 
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.rectangle("fill", (j-1)*tile_size, (i-1)*tile_size, tile_size, tile_size)
            love.graphics.setColor(255, 255, 255, 255)
          end
          if self[i][j] == 15 then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.rectangle("fill", (j-1)*tile_size, (i-1)*tile_size, tile_size, tile_size)
            love.graphics.setColor(255, 255, 255, 255)

          end
        end
      end
      love.graphics.setCanvas()
    end
    love.graphics.draw(self.canvas, margin/2, margin/2)
  end;
  
  penetrable = function(self, y, x)
    if self[y][x] == 0 or self[y][x] == 15 then
      return true
    end
    return false
  end;
  
  serialize = function(self)
    local result = ""
    for i=1, self.height do
      for j=1, self.width do
        result = result .. " " .. self[i][j]
      end
    end
    return result
  end;
  
  deserialize = function(self, data)
    local j = 1
    local i = 1
    for s in string.gmatch(data, "%S") do
      self[i][j] = tonumber(s)
      j = j + 1
      if j > self.width then
        j = 1
        i = i + 1
      end
    end
  end;
  --TODO: set canvas_uptodate to false when map is modified
}