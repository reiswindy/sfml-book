require "crsfml"
require "./world"

module SfmlBook::Chapter3
  class Game
    TIME_PER_FRAME = SF.seconds(1/60)

    def initialize
      mode = SF::VideoMode.new(640, 480)
      @window = SF::RenderWindow.new(mode, "SFML Application - Chapter 3")

      @world = World.new(@window)

      @font = SF::Font.from_file("media/sansation.ttf")

      @statistics = SF::Text.new
      @statistics.font = @font
      @statistics.character_size = 10
      @statistics.position = {5.0, 5.0}

      @statistics_num_frames = 0
      @statistics_time_since_last_update = SF::Time.new
    end

    def handle_player_input(key : SF::Keyboard::Key, pressed : Bool)
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
      @world.update(delta)
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
      @world.draw
      @window.view = @window.default_view
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

app = SfmlBook::Chapter3::Game.new
app.run
