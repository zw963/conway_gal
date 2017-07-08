require 'opal'
require 'jquery-1.12.4.min'
require 'jquery-migrate-1.4.1.min'
require 'opal-jquery'
require 'forwardable'
require 'ostruct'
require 'conway/grid'
require 'conway/interval'

class Conway
  attr_reader :grid, :seed
  extend Forwardable

  def initialize(grid)
    @grid = grid
    add_enter_event_listener
  end

  def_delegators :@grid, :state, :state=, :redraw_canvas, :seed

  def add_enter_event_listener
    Document.on :keypress do |event|
      if enter_pressed?(event)
        seed.each do |x, y|
          state[[x, y]] = 1
        end

        run
      end
    end
  end

  def enter_pressed?(event)
    event.which == 13
  end

  def run
    Interval.new do
      tick
    end
  end

  def tick
    # def_delegators at work again!
    # This call is delegate to grid.state=
    self.state = new_state
    redraw_canvas
  end

  def new_state
    new_state = {}
    state.each do |cell, _|
      new_state[cell] = get_state_at(cell[0], cell[1])
    end
    new_state
  end

  def get_state_at(x, y)
    if is_underpopulated?(x, y)
      0
    elsif is_living_happily?(x, y)
      1
    elsif is_overpopulated?(x, y)
      0
    elsif can_reproduce?(x, y)
      1
    end
  end

  def is_underpopulated?(x, y)
    is_alive?(x, y) && population_at(x, y) < 2
  end

  # Any live cell with two or three live neighbours lives
  # on to the next generation.
  def is_living_happily?(x, y)
    is_alive?(x, y) && ([2, 3].include? population_at(x, y))
  end

  # Any live cell with more than three live neighbours dies,
  # as if by overcrowding.
  def is_overpopulated?(x, y)
    is_alive?(x, y) && population_at(x, y) > 3
  end

  # Any dead cell with exactly three live neighbours becomes a live cell,
  # as if by reproduction.
  def can_reproduce?(x, y)
    is_dead?(x, y) && population_at(x, y) == 3
  end

  def population_at(x, y)
    [
      state[[x-1, y-1]],
      state[[x-1, y]],
      state[[x-1, y+1]],
      state[[x,   y-1]],
      state[[x,   y+1]],
      state[[x+1, y-1]],
      state[[x+1, y]],
      state[[x+1, y+1]]
    ].map(&:to_i).reduce(:+)
  end

  def is_alive?(x, y)
    state[[x, y]] == 1
  end

  def is_dead?(x, y)
    !is_alive?(x, y)
  end
end
