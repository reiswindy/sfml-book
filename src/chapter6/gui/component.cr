module SfmlBook::Chapter6
  module GUI
    abstract class Component < SF::Transformable
      include SF::Drawable
      include SF::NonCopyable

      getter? selected = false
      getter? active = false

      def select
        @selected = true
      end

      def deselect
        @selected = false
      end

      def activate
        @active = true
      end

      def deactivate
        @active = false
      end

      abstract def selectable?

      abstract def handle_event(event : SF::Event)

      abstract def draw(target : SF::RenderTarget, states : SF::RenderStates)
    end
  end
end
