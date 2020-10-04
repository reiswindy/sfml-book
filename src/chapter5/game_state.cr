require "crsfml"
require "./world"
require "./player"
require "./command"
require "./state_stack"

module SfmlBook::Chapter5
  class GameState < State

    def initialize(@stack : StateStack, @context : State::Context)
      super
      @world = World.new(@context.window)
      @player = @context.player.as(Player)
    end

    def handle_event(event : SF::Event)
      queue = @world.command_queue
      @player.handle_event(event, queue)

      case event
      when SF::Event::KeyPressed
        case event.code
        when SF::Keyboard::Key::Escape
          request_stack_push(States::Pause)
        end
      end

      return true
    end

    def update(delta : SF::Time)
      @world.update(delta)

      queue = @world.command_queue
      @player.handle_realtime_input(queue)

      return true
    end

    def draw
      @world.draw
    end
  end
end
