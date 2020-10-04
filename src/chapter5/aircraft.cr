require "crsfml"
require "./entity"
require "./resource_holder"
require "./resource_identifiers"

module SfmlBook::Chapter5

  enum Textures
    def self.for_aircraft(type : Aircraft::Type)
      case type
      when Aircraft::Type::Eagle then Textures::Eagle
      when Aircraft::Type::Raptor then Textures::Raptor
      else raise "Invalid aircraft type #{type}"
      end
    end
  end

  class Aircraft < Entity
    enum Type
      Eagle
      Raptor
    end

    def initialize(@type : Type, holder : TextureHolder)
      super()
      texture = holder.fetch(Textures.for_aircraft(@type))
      @sprite = SF::Sprite.new(texture)
      bounds = @sprite.local_bounds
      @sprite.origin = {bounds.width / 2, bounds.height / 2}
    end

    def draw_current(target : SF::RenderTarget, states : SF::RenderStates)
      target.draw(@sprite, states)
    end

    def category
      case type = @type
      when Type::Eagle then Category::Type::PlayerAircraft
      when Type::Raptor then Category::Type::EnemyAircraft
      else Category::Type::EnemyAircraft
      end
    end
  end
end
