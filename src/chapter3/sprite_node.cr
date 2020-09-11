require "crsfml"
require "./scene_node"

module SfmlBook::Chapter3

  class SpriteNode < SceneNode
    def initialize(texture : SF::Texture)
      super()
      @sprite = SF::Sprite.new(texture)
    end

    def initialize(texture : SF::Texture, rect : SF::IntRect)
      super()
      @sprite = SF::Sprite.new(texture, rect)
    end

    def draw_current(target : SF::RenderTarget, states : SF::RenderStates)
      target.draw(@sprite, states)
    end
  end
end
