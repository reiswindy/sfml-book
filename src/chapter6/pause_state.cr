require "crsfml"

module SfmlBook::Chapter6
  class PauseState < State

    def initialize(@stack : StateStack , @context : State::Context)
      super

      window_size = @context.window.size
      view_size = @context.window.view.size

      @background = SF::RectangleShape.new(view_size)
      @background.fill_color = SF::Color.new(0, 0, 0, 150)

      font = @context.fonts.fetch(Fonts::Main)

      @paused_text = SF::Text.new("Game Paused", font)
      @paused_text.character_size = 70
      @paused_text.origin = Utils.center_element_origin(@paused_text)
      @paused_text.position = {0.5 * window_size.x, 0.4 * window_size.y}

      @container = GUI::Container.new

      button_return = GUI::Button.new(@context.fonts, @context.textures)
      button_return.position = {0.5 * window_size.x - 100, 0.4 * window_size.y + 75}
      button_return.text = "Return"

      button_menu = GUI::Button.new(@context.fonts, @context.textures)
      button_menu.position = {0.5 * window_size.x - 100, 0.4 * window_size.y + 125}
      button_menu.text = "Back to Menu"

      button_return.callback = ->(){
        request_stack_pop
        nil
      }

      button_menu.callback = ->(){
        request_stack_clear
        request_stack_push(States::Menu)
        nil
      }

      @container.pack(button_return)
      @container.pack(button_menu)
    end

    def handle_event(event : SF::Event)
      @container.handle_event(event)
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
      window.draw(@container)
    end

    def destroy
      @container.destroy
    end
  end
end
