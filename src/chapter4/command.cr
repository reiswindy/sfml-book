require "crsfml"
require "./category"
require "./scene_node"

module SfmlBook::Chapter4

  struct Command
    alias Action = Proc(SceneNode, SF::Time, Nil)

    property action : Action
    property category : Category::Type

    def initialize(@action : Action, @category : Category::Type)
    end
  end
end
