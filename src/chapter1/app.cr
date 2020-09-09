require "crsfml"

module SfmlBook
  module Chapter1
    class Game
      TIME_PER_FRAME = SF.seconds(1/60)
      PLAYER_SPEED = 100

      def initialize
        mode = SF::VideoMode.new(640, 480)
        @window = SF::RenderWindow.new(mode, "SFML Application - Chapter 1")

        @texture = SF::Texture.from_file("media/textures/eagle.png")

        @player = SF::Sprite.new
        @player.texture = @texture
        @player.position = {100.0, 100.0}

        @font = SF::Font.from_file("media/sansation.ttf")

        @statistics = SF::Text.new
        @statistics.font = @font
        @statistics.character_size = 10
        @statistics.position = {5.0, 5.0}

        @statistics_num_frames = 0
        @statistics_time_since_last_update = SF::Time.new

        @moving_up = false
        @moving_down = false
        @moving_left = false
        @moving_right = false
      end

      def handle_player_input(key : SF::Keyboard::Key, pressed : Bool)
        case key
        when SF::Keyboard::W then @moving_up = pressed
        when SF::Keyboard::S then @moving_down = pressed
        when SF::Keyboard::A then @moving_left = pressed
        when SF::Keyboard::D then @moving_right = pressed
        end
      end

      def process_events
        while event = @window.poll_event
          case event
          when SF::Event::Closed then @window.close
          when SF::Event::KeyPressed then handle_player_input(event.code, true)
          when SF::Event::KeyReleased then handle_player_input(event.code, false)
          else
          end
        end
      end

      def update(delta : SF::Time)
        movement = SF.vector2f(0,0)
        movement.y -= PLAYER_SPEED if @moving_up
        movement.y += PLAYER_SPEED if @moving_down
        movement.x -= PLAYER_SPEED if @moving_left
        movement.x += PLAYER_SPEED if @moving_right
        @player.move(movement * delta.as_seconds)
      end

      def update_statistics(elapsed : SF::Time)
        @statistics_time_since_last_update += elapsed
        @statistics_num_frames += 1

        if @statistics_time_since_last_update >= SF.seconds(1)
          us = @statistics_time_since_last_update.as_microseconds / @statistics_num_frames
          @statistics.string = String.build do |str|
            str << "Frames / Second = #{@statistics_num_frames}"
            str << "\n"
            str << "Time / Update = #{us} us"
          end
          @statistics_time_since_last_update -= SF.seconds(1)
          @statistics_num_frames = 0
        end
      end

      def render
        @window.clear
        @window.draw(@player)
        @window.draw(@statistics)
        @window.display
      end

      def run
        clock = SF::Clock.new
        time_since_last_update = SF::Time::Zero
        while @window.open?
          elapsed_time = clock.restart
          time_since_last_update += elapsed_time
          while time_since_last_update > TIME_PER_FRAME
            time_since_last_update -= TIME_PER_FRAME
            process_events
            update(TIME_PER_FRAME)
          end
          update_statistics(elapsed_time)
          render
        end
      end
    end
  end
end

app = SfmlBook::Chapter1::Game.new
app.run
