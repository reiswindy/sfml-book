require "crsfml"
require "./command"
require "./category"
require "./aircraft"
require "./scene_node"

module SfmlBook::Chapter4

  module AircraftMovement
    def self.create(vx : Float, vy : Float)
      velocity = SF.vector2f(vx, vy)
      ->(node : SceneNode, delta : SF::Time) do
        node.as(Aircraft).accelerate(velocity)
        nil
      end
    end
  end

  class Player
    PLAYER_SPEED = 200.0

    enum Action
      MoveUp
      MoveDown
      MoveLeft
      MoveRight
    end

    def initialize
      @key_bindings = {
        Action::MoveUp => SF::Keyboard::Key::Up,
        Action::MoveDown => SF::Keyboard::Key::Down,
        Action::MoveLeft => SF::Keyboard::Key::Left,
        Action::MoveRight => SF::Keyboard::Key::Right,
      }
      @action_bindings = {
        Action::MoveUp => Command.new(AircraftMovement.create(0.0, -PLAYER_SPEED), Category::Type::PlayerAircraft),
        Action::MoveDown => Command.new(AircraftMovement.create(0.0, PLAYER_SPEED), Category::Type::PlayerAircraft),
        Action::MoveLeft => Command.new(AircraftMovement.create(-PLAYER_SPEED, 0.0), Category::Type::PlayerAircraft),
        Action::MoveRight => Command.new(AircraftMovement.create(PLAYER_SPEED, 0.0), Category::Type::PlayerAircraft),
      }
    end

    #TODO: Raise exception for invalid action
    def assign_key(action : Action, key : SF::Keyboard::Key)
      @key_bindings[action] = key
    end

    #TODO: Raise exception for invalid action
    def assigned_key(action : Action)
      @key_bindings[action]
    end

    def handle_event(event : SF::Event, queue : Deque(Command))
      if event.is_a?(SF::Event::KeyPressed) && event.code == SF::Keyboard::Key::P
        action = ->(node : SceneNode, delta : SF::Time) do
          puts "#{node.position.x}, #{node.position.y}"
          nil
        end
        output = Command.new(action, Category::Type::PlayerAircraft)
        queue.push(output)
      end
    end

    def handle_realtime_input(queue : Deque(Command))
      @key_bindings.each do |action, key|
        if SF::Keyboard.key_pressed?(key) && realtime_action?(action)
          queue.push(@action_bindings[action])
        end
      end
    end

    def realtime_action?(action : Action)
      case action
      when Action::MoveUp,
           Action::MoveDown,
           Action::MoveLeft,
           Action::MoveRight then true
      else false
      end
    end
  end
end
