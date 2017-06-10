# 这里 require 的内容, 是 Opal 自己的 LOAD_PATH 之下可以查找到的 Ruby 库.
# 这些库将来会被编译成 js.

require 'opal'
require 'opal-jquery'
require 'ostruct'

class Coordinates < OpenStruct
end

class Grid
  attr_reader :height, :width, :canvas, :context, :max_x, :max_y

  CELL_HEIGHT = 15
  CELL_WIDTH  = 15

  def initialize
    @height  = `$(window).height()` # 得到浏览器的高度
    @width   = `$(window).width()`  # 得到浏览器的宽度
    @canvas  = `document.getElementById(#{canvas_id})` # 获取 canvas 元素, 这个元素在页面被定义.
    @context = `#{canvas}.getContext('2d')` # 每一个 canvas 有一个 context, 我们只能在 context 之上画图.
    @max_x   = (height / CELL_HEIGHT).floor # 决定网格的大小, CELL_HIGHT 数值代表像素的宽度.
    @max_y   = (width / CELL_WIDTH).floor
  end

  def draw_canvas
    `#{canvas}.width  = #{width}`
    `#{canvas}.height = #{height}`

    x = 0.5
    until x >= width do
      `#{context}.moveTo(#{x}, 0)`
      `#{context}.lineTo(#{x}, #{height})`
      x += CELL_WIDTH
    end

    y = 0.5
    until y >= height do
      `#{context}.moveTo(0, #{y})`
      `#{context}.lineTo(#{width}, #{y})`
      y += CELL_HEIGHT
    end

    `#{context}.strokeStyle = "#eee"`
    `#{context}.stroke()`
  end

  def canvas_id
    'conwayCanvas'
  end

  def fill_cell(x, y)
    x *= CELL_WIDTH;
    y *= CELL_HEIGHT;
    `#{context}.fillStyle = "#000"`
    `#{context}.fillRect(#{x.floor+1}, #{y.floor+1}, #{CELL_WIDTH-1}, #{CELL_HEIGHT-1})`
  end

  def unfill_cell(x, y)
    x *= CELL_WIDTH;
    y *= CELL_HEIGHT;
    `#{context}.clearRect(#{x.floor+1}, #{y.floor+1}, #{CELL_WIDTH-1}, #{CELL_HEIGHT-1})`
  end

  def get_cursor_position(event)
    # 这里的 if/else 是为了兼容不同浏览器设置.
    if (event.page_x && event.page_y)
      x = event.page_x;
      y = event.page_y;
    else
      doc = Opal.Document[0]
      x = event[:clientX] + doc.scrollLeft +
        doc.documentElement.scrollLeft;
      y = event[:clientY] + doc.body.scrollTop +
        doc.documentElement.scrollTop;
    end

    x -= `#{canvas}.offsetLeft`
    y -= `#{canvas}.offsetTop`

    x = (x / CELL_WIDTH).floor
    y = (y / CELL_HEIGHT).floor

    Coordinates.new(x: x, y: y)
  end

  def add_mouse_event_listener
    Element.find("##{canvas_id}").on :click do |event|
      coords = get_cursor_position(event)
      x, y   = coords.x, coords.y
      fill_cell(x, y)
    end

    Element.find("##{canvas_id}").on :dblclick do |event|
      coords = get_cursor_position(event)
      x, y   = coords.x, coords.y
      unfill_cell(x, y)
    end
  end
end

grid = Grid.new
grid.draw_canvas
grid.add_mouse_event_listener
