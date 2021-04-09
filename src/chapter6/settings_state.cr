module SfmlBook::Chapter6
  class SettingsState < State
    def initialize(@stack : StateStack , @context : State::Context)
      super

      texture = @context.textures.fetch(Textures::TitleScreen)
      @background = SF::Sprite.new(texture)

      @binding_buttons = {} of Player::Action => GUI::Button
      @binding_labels = {} of Player::Action => GUI::Label

      @container = GUI::Container.new

      add_buton_label(Player::Action::MoveLeft, 150, "Move Left")
      add_buton_label(Player::Action::MoveRight, 200, "Move Right")
      add_buton_label(Player::Action::MoveUp, 250, "Move Up")
      add_buton_label(Player::Action::MoveDown, 300, "Move Down")

      update_labels

      button_back = GUI::Button.new(@context.fonts, @context.textures)
      button_back.position = {80, 375}
      button_back.text = "Back"
      button_back.callback = ->(){
        request_stack_pop
        nil
      }

      @container.pack(button_back)
    end

    def add_buton_label(action : Player::Action, pos_y, text)
      button = GUI::Button

      @binding_buttons[action] = GUI::Button.new(@context.fonts, @context.textures)
      @binding_buttons[action].position = {80, pos_y}
      @binding_buttons[action].toggle = true
      @binding_buttons[action].text = text

      @binding_labels[action] = GUI::Label.new("", @context.fonts)
      @binding_labels[action].position = {300, pos_y + 15}

      @container.pack(@binding_buttons[action])
      @container.pack(@binding_labels[action])
    end

    def update(delta : SF::Time)
      return true
    end

    def update_labels
      @binding_labels.each do |action, label|
        label.text = @context.player.assigned_key(action).to_s
      end
    end

    def handle_event(event : SF::Event)
      key_binding = false

      @binding_buttons.each do |action, button|
        if button.active?
          key_binding = true
          if event.is_a?(SF::Event::KeyReleased)
            @context.player.assign_key(action, event.code)
            button.deactivate
          end
          break
        end
      end

      if key_binding
        update_labels
      else
        @container.handle_event(event)
      end

      return false
    end

    def draw
      window = @context.window
      window.draw(@background)
      window.draw(@container)
    end

    def destroy
      @container.destroy
    end
  end
end
