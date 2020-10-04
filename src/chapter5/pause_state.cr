require "crsfml"

module SfmlBook::Chapter5
  class PauseState < State

    def initialize(@stack : StateStack , @context : State::Context)
      super
      font = @context.fonts.fetch(Fonts::Main)

      @background = SF::RectangleShape.new(@context.window.size)
      @background.fill_color = SF::Color.new(0, 0, 0, 150)

      view_size = @context.window.view.size

      @paused_text = SF::Text.new("Game Paused", font)
      @paused_text.character_size = 70
      @paused_text.origin = center_element_origin(@paused_text)
      @paused_text.position = {0.5 * view_size.x, 0.4 * view_size.y}

      @instructions_text = SF::Text.new("Press Backspace to return to the main menu", font)
      @instructions_text.origin = center_element_origin(@instructions_text)
      @instructions_text.position = {0.5 * view_size.x, 0.6 * view_size.y}
    end

    def handle_event(event : SF::Event)
      case event
      when SF::Event::KeyPressed
        case event.code
        when SF::Keyboard::Key::Escape
          request_stack_pop
        when SF::Keyboard::Key::Backspace
          request_stack_clear
          request_stack_push(States::Menu)
        end
      end
      return false
    end

    def update(delta : SF::Time)
      return false
    end

    def draw
      window = @context.window
      window.view = window.default_view
      window.draw(@background)
      window.draw(@paused_text)
      window.draw(@instructions_text)
    end

    private def center_element_origin(element)
      bounds = element.local_bounds
      x = bounds.left + bounds.width / 2
      y = bounds.top + bounds.height / 2
      {x.floor.to_i, y.floor.to_i}
    end
  end
end
