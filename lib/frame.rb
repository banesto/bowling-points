class Frame
  attr_accessor :balls, :score, :is_open_score

  def initialize
    self.balls = []
    self.is_open_score = false
    self.score = 0
  end

  def ball(pins)
    return unless (0..10).cover?(pins)
    return if finished?
    return if pins + balls.sum > 10

    self.balls << pins
    self.score += pins
    self.is_open_score = true if balls.sum == 10
  end

  def strike?
    balls.size == 1 && balls.sum == 10
  end

  def spare?
    balls.size == 2 && balls.sum == 10
  end

  def finished?
    balls.sum == 10 || balls.size == 2
  end
end
