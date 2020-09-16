require "crsfml"
require "./world"
require "./player"

module SfmlBook::Chapter4

  class Game
    TIME_PER_FRAME = SF.seconds(1/60)

    def initialize
      mode = SF::VideoMode.new(640, 480)
      @window = SF::RenderWindow.new(mode, "SFML Application - Chapter 4")
      @window.key_repeat_enabled = false

      @world = World.new(@window)
      @player = Player.new

      @font = SF::Font.from_file("media/sansation.ttf")

      @statistics = SF::Text.new
      @statistics.font = @font
      @statistics.character_size = 10
      @statistics.position = {5.0, 5.0}

      @statistics_num_frames = 0
      @statistics_time_since_last_update = SF::Time.new
    end

    def process_events
      queue = @world.command_queue

      while event = @window.poll_event
        @player.handle_event(event, queue)
        case event
        when SF::Event::Closed then @window.close
        else
        end
      end
      @player.handle_realtime_input(queue)
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

app = SfmlBook::Chapter4::Game.new
app.run
