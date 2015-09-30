require "Player"

Gamepicture = Class{
  init = function(self)
    self.player_server = Player(300, 500)
    self.player_client = Player(500, 300)
  end;
  
  update_picture = function(self, serialized_picture)
    self.player_server.x, self.player_server.y, self.player_client.x, self.player_client.y = serialized_picture:match("(%S*) (%S*) (%S*) (%S*)")
  end;
  
  serialize_picture = function(self)
    return string.format("%d %d %d %d", self.player_server.x, self.player_server.y, self.player_client.x, self.player_client.y)    
  end;
  
  draw = function(self)
    love.graphics.print("playerClient", self.player_server.x, self.player_server.y)
    love.graphics.print("playerServer", self.player_client.x, self.player_client.y)
  end;
}