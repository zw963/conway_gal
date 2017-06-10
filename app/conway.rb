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
end

grid = Grid.new
grid.draw_canvas
