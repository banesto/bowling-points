class Frame
  @@score = 0
  attr_accessor :balls, :score, :is_open_score, :bonus_pins, :is_last_frame

  def initialize(is_last_frame = false)
    self.balls = []
    self.bonus_pins = []
    self.is_open_score = false
    self.score = 0
    self.is_last_frame = is_last_frame
  end

  def ball(pins)
    return unless (0..10).cover?(pins)
    return if finished?
    return if pins + balls.sum > 10 && !is_last_frame

    self.balls << pins
    self.score += pins
    self.is_open_score = true if balls.sum == 10
    true
  end

  def add_bonus_pins(pins)
    return unless is_open_score

    self.bonus_pins << pins

    if (bonus_pins.size == 1 && spare?) || (bonus_pins.size == 2 && strike?)
      calculate_score
    end
  end

  def strike?
    balls.size == 1 && balls.sum == 10
  end

  def spare?
    balls.size == 2 && balls.sum == 10
  end

  def finished?
    if is_last_frame
      (balls.size == 2 && balls.sum < 10) || balls.size == 3
    else
      balls.sum == 10 || balls.size == 2
    end
  end

  def to_s
    "balls: #{balls} | score: #{score unless is_open_score}"
  end

  def simple_score
    return unless balls.sum < 10

    self.score += @@score
    @@score = score
  end

  def calculate_score
    self.score = @@score + balls.sum + bonus_pins.sum
    @@score = score
    self.is_open_score = false
  end

  def self.reset_score
    @@score = 0
  end
end
