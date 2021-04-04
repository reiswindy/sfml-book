require "./component"

module SfmlBook::Chapter6
  module GUI
    class Container < Component
      def initialize
        super
        @children = [] of Component
        @selected_index = -1
      end

      def select(index)
        if @children[index].selectable?
          @children[@selected_index].deselect if selection_exists?
          @children[index].select
          @selected_index = index
        end
      end

      def select_next
        if selection_exists?
          aux = @selected_index
          loop do
            aux = (aux + 1) % @children.size
            break if @selected_index == aux || @children[aux].selectable?
          end
          self.select(aux)
        end
      end

      def select_previous
        if selection_exists?
          aux = @selected_index - @children.size
          loop do
            aux = (aux - 1) % @children.size
            break if @selected_index == aux || @children[aux].selectable?
          end
          self.select(aux)
        end
      end

      def selection_exists?
        @selected_index >= 0
      end

      def pack(ptr : Component)
        @children << ptr
        @selected_index = @children.size - 1 if !selection_exists? && ptr.selectable?
      end


      def selectable?
        false
      end

      def handle_event(event : SF::Event)
        if selection_exists? && @children[@selected_index].active?
          @children[@selected_index].handle_event(event)
        elsif event.is_a?(SF::Event::KeyReleased)
          handle_event_key_released(event)
        end
      end

      def handle_event_key_released(event : SF::Event::KeyReleased)
        case event.code
        when SF::Keyboard::Key::Up then select_previous
        when SF::Keyboard::Key::Down then select_next
        when SF::Keyboard::Key::Return
          @children[@selected_index].activate if selection_exists?
        end
      end

      def draw(target : SF::RenderTarget, states : SF::RenderStates)
        states.transform = states.transform * transform
        @children.each do |c|
          target.draw(c, states)
        end
      end
    end
  end
end
