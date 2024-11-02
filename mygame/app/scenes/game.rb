# frozen_string_literal: true

# Main game class
class Game
  attr_gtk

  def lowrez
    args.lowrez
  end

  def g
    state.game
  end

  def tick
    init
    render
    input
    update

    # outputs.primitives << gtk.framerate_diagnostics_primitives
  end

  def init
    g.paddle ||= { x: 116, y: 10, w: 24, h: 6 }
    g.ball ||= { x: 126, y: 18, w: 4, h: 4 }
  end

  def render
    lowrez.background_color = [0.5, 0.5, 0.5]
    render_debug
    args.outputs.labels << {
      x: 640,
      y: 510,
      text: 'Game',
      size_px: 20,
      anchor_x: 0.5,
      anchor_y: 0.5
    }
    lowrez.primitives << { **g.paddle, primitive_marker: :solid, **hex_to_rgba(0xffffff) }
    lowrez.primitives << { **g.ball, primitive_marker: :solid, **hex_to_rgba(0xffffff) }
  end

  def input
    dx = 0
    dx -= 1 if inputs.keyboard.left
    dx += 1 if inputs.keyboard.right
    new_x = g.paddle.x + dx
    g.paddle.x = new_x if new_x < LOWREZ_SIZE_W - g.paddle.w && new_x.positive?
  end

  def update; end

  def render_debug
    unless state.grid_rendered
      # vertical lines
      (LOWREZ_SIZE_H + 1).map_with_index do |i|
        outputs.static_debug << {
          x: LOWREZ_X_OFFSET,
          y: LOWREZ_Y_OFFSET + (i * LOWREZ_ZOOM),
          x2: LOWREZ_X_OFFSET + LOWREZ_SIZE_W * LOWREZ_ZOOM,
          y2: LOWREZ_Y_OFFSET + (i * LOWREZ_ZOOM),
          r: 128,
          g: 128,
          b: 128,
          a: 80
        }.line!
      end

      # horizontal lines
      (LOWREZ_SIZE_W + 1).map_with_index do |i|
        outputs.static_debug << {
          x: LOWREZ_X_OFFSET + (i * LOWREZ_ZOOM),
          y: LOWREZ_Y_OFFSET,
          x2: LOWREZ_X_OFFSET + (i * LOWREZ_ZOOM),
          y2: LOWREZ_Y_OFFSET + LOWREZ_SIZE_H * LOWREZ_ZOOM,
          r: 128,
          g: 128,
          b: 128,
          a: 80
        }.line!
      end
    end

    state.grid_rendered = true

    state.last_click ||= 0
    state.last_up    ||= 0
    state.last_click   = Kernel.tick_count if lowrez.mouse_down # you can also use args.lowrez.click
    state.last_up      = Kernel.tick_count if lowrez.mouse_up
    state.label_style  = { size_enum: -1.5 }

    state.watch_list = [
      "Kernel.tick_count is:           #{Kernel.tick_count}",
      "args.lowrez.mouse_position is:  #{lowrez.mouse_position.x}, #{lowrez.mouse_position.y}",
      "args.lowrez.mouse_down tick:    #{state.last_click || 'never'}",
      "args.lowrez.mouse_up tick:      #{state.last_up || 'false'}"
    ]

    outputs.debug << state
      .watch_list
      .map_with_index do |text, i|
        {
          x: 5,
          y: 620 - (i * 20),
          text: text,
          size_enum: -1.5,
          r: 255,
          g: 255,
          b: 255,
          a: 255
        }.label!
      end

    outputs.debug << {
      x: 640,
      y: 25,
      text: 'INFO: dev mode is currently enabled. Comment out the invocation of ~render_debug~ within the ~tick~ method to hide the debug layer.',
      size_enum: -0.5,
      alignment_enum: 1,
      r: 255,
      g: 255,
      b: 255,
      a: 255
    }.label!
  end
end

$gtk.reset
