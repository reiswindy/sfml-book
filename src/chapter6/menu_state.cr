module SfmlBook::Chapter6
  class MenuState < State
    enum Options
      Play
      Settings
      Exit
    end

    def initialize(@stack : StateStack , @context : State::Context)
      super

      texture = @context.textures.fetch(Textures::TitleScreen)
      @background = SF::Sprite.new(texture)

      @container = GUI::Container.new

      button_play = GUI::Button.new(@context.fonts, @context.textures)
      button_play.position = {100, 250}
      button_play.text = "Play"

      button_settings = GUI::Button.new(@context.fonts, @context.textures)
      button_settings.position = {100, 300}
      button_settings.text = "Settings"

      button_exit = GUI::Button.new(@context.fonts, @context.textures)
      button_exit.position = {100, 350}
      button_exit.text = "Exit"

      button_play.callback = ->(){
        request_stack_pop
        request_stack_push(States::Game)
        nil
      }

      button_settings.callback = ->(){
        request_stack_push(States::Settings)
        nil
      }

      button_exit.callback = ->(){
        request_stack_pop
        nil
      }

      @container.pack(button_play)
      @container.pack(button_settings)
      @container.pack(button_exit)
    end

    def handle_event(event : SF::Event)
      @container.handle_event(event)
      return true
    end

    def update(delta : SF::Time)
      return true
    end

    def draw
      window = @context.window
      window.view = window.default_view
      window.draw(@background)
      window.draw(@container)
    end

    def destroy
      @container.destroy
    end
  end
end
