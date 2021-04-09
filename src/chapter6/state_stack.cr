require "crsfml"

module SfmlBook::Chapter6

  class StateStack
    include SF::NonCopyable

    enum Action
      Push
      Pop
      Clear
    end

    struct PendingChange
      getter action
      getter id

      def initialize(@action : Action, @id : States? = nil)
      end
    end

    def initialize(@context : State::Context)
      @stack = [] of State
      @pending = [] of PendingChange
      @factories = {} of States => Proc(State)
    end

    def empty?
      @stack.empty?
    end

    def register(type : Class, id : States)
      raise "State factory already registered" if @factories[id]?
      @factories[id] = ->() { type.new(self, @context).as(State) }
    end

    def push(id : States)
      @pending.push(PendingChange.new(Action::Push, id))
    end

    def pop
      @pending.push(PendingChange.new(Action::Pop))
    end

    def clear
      @pending.push(PendingChange.new(Action::Clear))
    end

    def create(id : States)
      @factories[id].call
    end

    def apply_pending_changes
      @pending.each do |change|
        case change.action
        when Action::Push  then @stack << create(change.id.not_nil!)
        when Action::Pop   then @stack.pop.destroy
        when Action::Clear then @stack.size.times{ @stack.pop.destroy }
        else raise "Invalid #{Action}"
        end
      end
      @pending.clear
    end

    def handle_event(event : SF::Event)
      @stack.reverse_each do |state|
        break if !state.handle_event(event)
      end
      apply_pending_changes
    end

    def update(delta : SF::Time)
      @stack.reverse_each do |state|
        break if !state.update(delta)
      end
    end

    def draw
      @stack.each(&.draw)
    end
  end

  abstract class State
    struct Context
      getter window   : SF::RenderWindow
      getter textures : TextureHolder
      getter fonts    : FontHolder
      getter player   : Player

      def initialize(@window, @textures, @fonts, @player)
      end
    end

    getter context

    def initialize(@stack : StateStack, @context : Context)
    end

    abstract def handle_event(event : SF::Event)
    abstract def update(delta : SF::Time)
    abstract def draw

    def destroy
    end

    def request_stack_push(state : States)
      @stack.push(state)
    end

    def request_stack_pop
      @stack.pop
    end

    def request_stack_clear
      @stack.clear
    end
  end
end
