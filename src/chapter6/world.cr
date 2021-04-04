require "crsfml"
require "./scene_node"
require "./sprite_node"
require "./resource_holder"
require "./resource_identifiers"
require "./aircraft"
require "./command"

module SfmlBook::Chapter6

  class World
    include SF::NonCopyable

    enum Layer
      Background
      Air
      LayerCount
    end

    getter command_queue

    def initialize(@window : SF::RenderWindow)
      @view = SF::View.new(@window.default_view.center, @window.default_view.size)
      @bounds = SF::FloatRect.new(0, 0, @view.size.x, 2000)
      @command_queue = Deque(Command).new

      @graph = SceneNode.new
      @holder = TextureHolder.new
      @layers = Array(SceneNode).new(Layer::LayerCount.value) { SceneNode.new }

      @scroll_speed = -50.0

      @player = uninitialized Aircraft
      @spawn_position = SF.vector2f(@view.size.x / 2, @bounds.height - @view.size.y / 2)

      load_textures
      build_scene

      @view.center = @spawn_position
    end

    def load_textures
      @holder.load(Textures::Eagle, "media/textures/eagle.png")
      @holder.load(Textures::Raptor, "media/textures/raptor.png")
      @holder.load(Textures::Desert, "media/textures/desert.png")
    end

    def build_scene
      @layers.each do |layer|
        @graph.attach(layer)
      end

      desert_texture = @holder.fetch(Textures::Desert)
      desert_texture.repeated = true
      desert_rect = SF::IntRect.new(@bounds.left.to_i, @bounds.top.to_i, @bounds.width.to_i, @bounds.height.to_i)
      desert_node = SpriteNode.new(desert_texture, desert_rect)
      desert_node.position = {@bounds.left, @bounds.top}
      @layers[Layer::Background.value].attach(desert_node)

      @player = Aircraft.new(Aircraft::Type::Eagle, @holder)
      @player.position = @spawn_position
      @player.velocity = {40, @scroll_speed}
      @layers[Layer::Air.value].attach(@player)

      left_escort = Aircraft.new(Aircraft::Type::Raptor, @holder)
      left_escort.position = {-80, 50}
      @player.attach(left_escort)

      right_escort = Aircraft.new(Aircraft::Type::Raptor, @holder)
      right_escort.position = {80, 50}
      @player.attach(right_escort)
    end

    def update(delta : SF::Time)
      @view.move(0, @scroll_speed * delta.as_seconds)
      @player.velocity = {0, 0}

      while !@command_queue.empty?
        @graph.on_command(@command_queue.shift, delta)
      end
      adapt_player_velocity

      @graph.update(delta)
      adapt_player_position
    end

    def draw
      @window.view = @view
      @window.draw(@graph)
    end

    private def adapt_player_velocity
      velocity = @player.velocity
      @player.velocity = velocity / Math.sqrt(2.0) if velocity.x != 0 && velocity.y != 0
      @player.accelerate({0, @scroll_speed})
    end

    private def adapt_player_position
      view_bounds = SF::FloatRect.new(@view.center - @view.size / 2.0, @view.size)
      border_distance = 40.0

      position = @player.position
      position.y = Math.max(position.y, view_bounds.top + border_distance)
      position.x = Math.max(position.x, view_bounds.left + border_distance)
      position.y = Math.min(position.y, view_bounds.top + view_bounds.height - border_distance)
      position.x = Math.min(position.x, view_bounds.left + view_bounds.width - border_distance)
      @player.position = position
    end
  end
end
