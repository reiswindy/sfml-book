module SfmlBook::Chapter5
  class TitleState < State
    BLINK_TIME = SF.seconds(0.5)

    def initialize(@stack : StateStack , @context : State::Context)
      super
      texture = @context.textures.fetch(Textures::TitleScreen)
      font = @context.fonts.fetch(Fonts::Main)

      @background = SF::Sprite.new(texture)
      @text = SF::Text.new("Press any key to start", font)

      @show_text = true
      @text_effect_time = SF::Time.new
    end

    def handle_event(event : SF::Event)
      case event
      when SF::Event::KeyPressed
        request_stack_pop
        request_stack_push(States::Menu)
      end
      return true
    end

    def update(delta : SF::Time)
      @text_effect_time += delta
      if @text_effect_time > BLINK_TIME
        @show_text = !@show_text
        @text_effect_time = SF::Time.new
      end
      return true
    end

    def draw
      window = @context.window
      window.draw(@background)
      window.draw(@text) if @show_text
    end
  end
end
