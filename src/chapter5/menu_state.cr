module SfmlBook::Chapter5
  class MenuState < State

    enum Options
      Play
      Exit
    end

    def initialize(@stack : StateStack , @context : State::Context)
      super
      texture = @context.textures.fetch(Textures::TitleScreen)
      font = @context.fonts.fetch(Fonts::Main)

      @background = SF::Sprite.new(texture)

      option_play = SF::Text.new("Play", font)
      option_play.origin = Utils.center_element_origin(option_play)
      option_play.position = @context.window.view.size / 2

      option_exit = SF::Text.new("Exit", font)
      option_exit.origin = Utils.center_element_origin(option_exit)
      option_exit.position = option_play.position + SF.vector2f(0, 30)

      @options = [] of SF::Text
      @options << option_play
      @options << option_exit

      @option_selected = 0
      update_option
    end

    def handle_event(event : SF::Event)
      case event
      when SF::Event::KeyPressed
        case event.code
        when SF::Keyboard::Key::Up
          @option_selected = (@option_selected + @options.size - 1) % @options.size
          update_option
        when SF::Keyboard::Key::Down
          @option_selected = (@option_selected + @options.size + 1) % @options.size
          update_option
        when SF::Keyboard::Key::Return
          case Options.new(@option_selected)
          when Options::Play
            request_stack_pop
            request_stack_push(States::Game)
          when Options::Exit
            request_stack_pop
          end
        end
      end
      return true
    end

    def update(delta : SF::Time)
      return true
    end

    def update_option
      @options.each do |text|
        text.color = SF::Color::White
      end
      @options[@option_selected].color = SF::Color::Red
    end

    def draw
      window = @context.window
      window.view = window.default_view
      window.draw(@background)
      @options.each do |text|
        window.draw(text)
      end
    end
  end
end
