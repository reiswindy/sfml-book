require "crsfml"
require "./entity"
require "./resource_holder"
require "./resource_identifiers"

module SfmlBook::Chapter3

  module Textures
    def self.for_aircraft(type : Aircraft::Type)
      case type
      when Aircraft::Type::Eagle then Textures::ID::Eagle
      when Aircraft::Type::Raptor then Textures::ID::Raptor
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
  end
end
