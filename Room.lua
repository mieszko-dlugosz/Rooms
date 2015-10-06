Room = Class{
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
  end;
  
  match_with_shift = function(self, pos_y, pos_x, si, sj)
    if ((pos_y-si < 1 or pos_x-sj < 1)or(pos_y-si+self.height>map.height or pos_x-sj+self.width>map.width)) then
      return false
    end
    for i=1, self.height do
      for j=1, self.width do
        if map[pos_y+i-si-1][pos_x+j-sj-1] ~= self[i][j] then
          return false
        end
      end
    end
    return true
  end;
  
  match = function(self, pos_y, pos_x)   
     for si=0, self.height-1 do
      for sj=0, self.width-1 do
        if self:match_with_shift(pos_y, pos_x, si, sj) then
          for i=1, self.height do
            for j=1, self.width do
              if map[pos_y+i-1-si][pos_x+j-1-sj] == 0 then
                map[pos_y+i-1-si][pos_x+j-1-sj] = 37
              end
            end
          end
          map.canvas_uptodate = false
          return false
        end
      end
    end
 
  end;
}