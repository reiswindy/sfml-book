require "crsfml"

module SfmlBook::Chapter5

  class SceneNode < SF::Transformable
    include SF::NonCopyable
    include SF::Drawable

    property parent : Pointer(SceneNode)

    def initialize
      super()
      @parent = Pointer(SceneNode).null
      @children = [] of SceneNode
    end

    def attach(node : SceneNode)
      aux = self.as(SceneNode)
      node.parent = pointerof(aux)
      @children.push(node)
    end

    def detach(node : SceneNode)
      node.parent = Pointer(SceneNode).null
      @children.delete(node)
    end

    def update(delta : SF::Time)
      update_current(delta)
      update_children(delta)
    end

    def update_current(delta : SF::Time)
    end

    def update_children(delta : SF::Time)
      @children.each(&.update(delta))
    end

    def draw(target : SF::RenderTarget, states : SF::RenderStates)
      states.transform *= transform
      draw_current(target, states)
      draw_children(target, states)
    end

    def draw_current(target : SF::RenderTarget, states : SF::RenderStates)
    end

    def draw_children(target : SF::RenderTarget, states : SF::RenderStates)
      @children.each(&.draw(target, states))
    end

    def world_transform
      world = transform
      node = @parent
      while node
        world = node.value.transform * world
        node = node.parent
      end
      world
    end

    def category
      Category::Type::Scene
    end

    def on_command(command : Command, delta : SF::Time)
      command.action.call(self, delta) if command.category.includes?(category)
      @children.each(&.on_command(command, delta))
    end
  end
end
