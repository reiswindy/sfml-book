require "crsfml"
require "./scene_node"

module SfmlBook::Chapter4

  class Entity < SceneNode
    getter velocity = SF::Vector2f.new

    def velocity=(velocity : SF::Vector2|Tuple)
      @velocity.x = velocity[0].to_f32
      @velocity.y = velocity[1].to_f32
    end

    def accelerate(velocity : SF::Vector2|Tuple)
      @velocity.x += velocity[0].to_f32
      @velocity.y += velocity[1].to_f32
    end

    def update_current(delta : SF::Time)
      move(@velocity * delta.as_seconds)
    end
  end
end
