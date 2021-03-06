require_relative 'frame.rb'

class Game
  FRAME_COUNT = 10.freeze
  @@frame = 1
  attr_accessor :frames, :verbose

  def initialize(verbose = true)
    self.frames = []
    self.verbose = verbose
  end

  def play
    return if finished?

    puts "FRAME: #{@@frame}" if verbose
    frame = process_frame
    puts frame if verbose
    puts() if verbose

    frames << frame
    @@frame += 1
    finished? ? close_score : play
  end

  def process_frame
    frame = Frame.new(frames.size == FRAME_COUNT - 1)
    while !frame.finished?
      ball = pin_input
      if frame.ball(ball)
        frames.select(&:is_open_score).each do |f|
          f.add_bonus_pins(ball)
        end
      end
    end

    frame.simple_score
    frame
  end

  def pin_input
    print "Enter pin count: "
    gets.chomp.to_i
  end

  def finished?
    FRAME_COUNT == frames.size
  end

private

  def close_score
    frames.select(&:is_open_score).each do |f|
      f.calculate_score
    end
  end
end
