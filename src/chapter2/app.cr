require "crsfml"

module SfmlBook::Chapter2
  module Textures
    enum ID
      Landscape
      Airplane
      Missile
    end
  end

  class ResourceHolder(K, V)
    getter map = {} of K => V

    def load(id : K, filename : String)
      raise "Texture already loaded for #{id}" if map[id]?
      map[id] = V.from_file(filename)
    end

    def fetch(id : K)
      raise "Texture not found for #{id}" if !map[id]?
      map[id]
    end
  end

  class Game
    def initialize
      mode = SF::VideoMode.new(640, 480)
      @window = SF::RenderWindow.new(mode, "Resources")

      @textures = ResourceHolder(Textures::ID, SF::Texture).new
      @textures.load(Textures::ID::Landscape, "media/textures/desert.png")
      @textures.load(Textures::ID::Airplane, "media/textures/eagle.png")

      @landscape = SF::Sprite.new(@textures.fetch(Textures::ID::Landscape))
      @airplane = SF::Sprite.new(@textures.fetch(Textures::ID::Airplane))

      @airplane.position = {200, 200}
    end

    def process_events
      while event = @window.poll_event
        case event
        when SF::Event::Closed then @window.close
        when SF::Event::KeyPressed then @window.close
        end
      end
    end

    def update
    end

    def render
      @window.clear
      @window.draw(@landscape)
      @window.draw(@airplane)
      @window.display
    end

    def run
      while @window.open?
        process_events
        update
        render
      end
    end
  end
end

app = SfmlBook::Chapter2::Game.new
app.run
