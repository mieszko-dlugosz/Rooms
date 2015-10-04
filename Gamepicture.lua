require "Player"

Gamepicture = Class{
  init = function(self)
    self.player_server = Player(10 , 3)
    self.player_client = Player(55, 34)
    map = Map("C:\\Users\\Lenovo\\Desktop\\gamedev\\Love\\Rooms\\level1.txt")

  end;
  
  update_picture = function(self, serialized_picture)
    self.player_server.x, self.player_server.y, self.player_client.x, self.player_client.y = serialized_picture:match("(%S*) (%S*) (%S*) (%S*)")
  end;
  
  serialize_picture = function(self)
    return string.format("%d %d %d %d", self.player_server.x, self.player_server.y, self.player_client.x, self.player_client.y)    
  end;
  
  draw = function(self)
    map:draw()
    self.player_server:draw()
    self.player_client:draw()
  end;
}