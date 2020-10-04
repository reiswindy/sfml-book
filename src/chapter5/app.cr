require "crsfml"
require "./player"
require "./resource_holder"
require "./resource_identifiers"
require "./state_stack"
require "./state_identifiers"
require "./title_state"
require "./menu_state"
require "./game_state"
require "./pause_state"

module SfmlBook::Chapter5
  class Application
    TIME_PER_FRAME = SF.seconds(1/60)

    def initialize
      mode = SF::VideoMode.new(640, 480)
      @window = SF::RenderWindow.new(mode, "SFML Application - Chapter 5")
      @window.key_repeat_enabled = false

      @textures = TextureHolder.new
      @fonts = FontHolder.new

      @player = Player.new

      context = State::Context.new(@window, @textures, @fonts, @player)
      @state_stack = StateStack.new(context)

      @fonts.load(Fonts::Main, "media/sansation.ttf")
      @textures.load(Textures::TitleScreen , "media/textures/titlescreen.png")

      @statistics = SF::Text.new
      @statistics.font = @fonts.fetch(Fonts::Main)
      @statistics.character_size = 10
      @statistics.position = {5.0, 5.0}

      @statistics_num_frames = 0
      @statistics_time_since_last_update = SF::Time.new

      register_states
      @state_stack.push(States::Title)
    end

    def register_states
      @state_stack.register(TitleState, States::Title)
      @state_stack.register(MenuState, States::Menu)
      @state_stack.register(GameState, States::Game)
      @state_stack.register(PauseState, States::Pause)
    end

    def process_events
      while event = @window.poll_event
        @state_stack.handle_event(event)

        case event
        when SF::Event::Closed then @window.close
        end

      end
    end

    def update(delta : SF::Time)
      @state_stack.update(delta)
    end

    def render
      @window.clear
      @state_stack.draw
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

          @window.close if @state_stack.empty?
        end

        update_statistics(elapsed_time)
        render
      end
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

  end
end

app = SfmlBook::Chapter5::Application.new
app.run
