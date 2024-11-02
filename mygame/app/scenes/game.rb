# frozen_string_literal: true

# Main game class
class Game

  attr_gtk

  def tick
    init
    render
    input
    update

    outputs.primitives << args.gtk.framerate_diagnostics_primitives
  end

  def init
  end

  def render
    args.outputs.labels << {
      x: 640,
      y: 510,
      text: 'Game',
      size_px: 20,
      anchor_x: 0.5,
      anchor_y: 0.5
    }
  end

  def input
  end

  def update
  end
end

$gtk.reset
