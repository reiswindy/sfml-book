require "./component"

module SfmlBook::Chapter6
  module GUI
    class Label < Component
      def initialize(text : String, fonts : FontHolder)
        super()
        @text = SF::Text.new(text, fonts.fetch(Fonts::Main), 16)
      end

      def text=(text : String)
        @text.string = text
      end

      def selectable?
        false
      end

      def handle_event(event : SF::Event)
      end

      def draw(target : SF::RenderTarget, states : SF::RenderStates)
        states.transform = states.transform * transform
        target.draw(@text, states)
      end
    end
  end
end
