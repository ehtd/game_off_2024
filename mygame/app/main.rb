# frozen_string_literal: true

# utilities
require 'app/utils/random'
require 'app/utils/colors'

# scenes
require 'app/scenes/game'

def boot(_args)
  $gtk.disable_console if $gtk.production?
end

def tick(args)
  $game ||= Game.new

  args.state.current_scene ||= :game_scene
  current_scene = args.state.current_scene

  # scene tick selector
  case current_scene
  when :game_scene
    $game.args = args
    $game.tick
  end

  # make sure that the current_scene flag wasn't set mid tick
  if args.state.current_scene != current_scene
    raise 'Scene was changed incorrectly. Set args.state.next_scene to change scenes.'
  end

  # if next scene was set/requested, then transition the current scene to the next scene
  return unless args.state.next_scene

  args.state.current_scene = args.state.next_scene
  args.state.next_scene = nil
end
