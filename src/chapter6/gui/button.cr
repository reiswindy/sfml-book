require "./component"

module SfmlBook::Chapter6
  module GUI
    class Button < Component
      property? toggle : Bool = false
      property? callback : Proc(Nil)?

      def initialize(fonts : FontHolder, textures : TextureHolder)
        super()
        @normal_texture = textures.fetch(Textures::ButtonNormal).as(SF::Texture)
        @pressed_texture = textures.fetch(Textures::ButtonPressed).as(SF::Texture)
        @selected_texture = textures.fetch(Textures::ButtonSelected).as(SF::Texture)

        @sprite = SF::Sprite.new(@normal_texture)
        @text = SF::Text.new("", fonts.fetch(Fonts::Main), 16)
        @text.position = {@sprite.local_bounds.width / 2.0, @sprite.local_bounds.height / 2.0}
      end

      def text=(text : String)
        @text.string = text
        @text.origin = Utils.center_element_origin(@text)
      end

      def select
        super
        @sprite.texture = @selected_texture
      end

      def deselect
        super
        @sprite.texture = @normal_texture
      end

      def activate
        super
        @sprite.texture = @pressed_texture if toggle?
        callback?.try(&.call)
        deactivate if !toggle?
      end

      def deactivate
        super
        if toggle?
          if selected?
            @sprite.texture = @selected_texture
          else
            @sprite.texture = @normal_texture
          end
        end
      end

      def selectable?
        true
      end

      def handle_event(event : SF::Event)
      end

      def draw(target : SF::RenderTarget, states : SF::RenderStates)
        states.transform = states.transform * transform
        target.draw(@sprite, states)
        target.draw(@text, states)
      end
    end
  end
end
