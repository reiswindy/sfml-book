module SfmlBook::Chapter5
  class LoadingState < State

    def initialize(@stack : StateStack, @context : State::Context)
      font = @context.fonts.fetch(Fonts::Main)
      view_size = @context.window.view.size

      @text = SF::Text.new("Loading resources", font)
      @text.origin = Utils.center_element_origin(element)
      @text.position = {view_size.x / 2, view_size.y / 2 + 50}

      @progress_background = SF::RectangleShape.new
      @progress_background.size = SF.vector2f(view_size.x - 20, 10)
      @progress_background.position = {10, @text.position.y + 40}
      @progress_background.fill_color = SF::Color::White

      @progress = SF::RectangleShape.new
      @progress.position = @progress_background.position
      @progress.fill_color = SF::Color.new(100,100,100)

      update_completion(0)

      @parallel_task = ParallelTask.new
      @parallel_task.execute
    end

    def handle_event(event : SF::Event)
    end

    def update(delta : SF::Time)
      if @parallel_task.finished?
        request_stack_pop
        request_stack_push(States::Game)
      else
        update_completion(@parallel_task.completion)
      end
      return true
    end

    def draw
      @context.window.draw(@text)
      @context.window.draw(@progress_background)
      @context.window.draw(@progress)
    end

    private def update_completion(percent)
      factor = Math.min(1, percent).to_f
      @progress.size = SF.vector2f(@progress_background.size.x * factor, @progress_background.size.y)
    end
  end
end
