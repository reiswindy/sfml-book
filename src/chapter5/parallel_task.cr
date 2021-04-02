module SfmlBook::Chapter5
  class ParallelTask

    def initialize
      @thread = SF::Thread.new(->run_task)
      @finished = false
      @clock = SF::Clock.new
      @mutex = SF::Mutex
    end

    def finished?
      @mutex.lock
      @finished
    end

    def completion
      @mutex.lock
      @clock.elapsed_time.as_seconds / 10.0
    end

    def execute
      @finished = false
      @clock.restart
      @thread.launch
    end

    def run_task
      done = false
      while !done
        @mutex.lock
        done = true if @clock.elapsed_time.as_seconds > 10
      end
      @mutex.lock
      @finished = true
    end
  end
end
