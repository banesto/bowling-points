require_relative '../../lib/game.rb'

RSpec.describe Game do
  after do
    Frame.reset_score
  end

  context 'empty game' do
    it 'has no frames' do
      expect(subject.frames).to be_empty
    end

    it { is_expected.not_to be_finished }
  end

  context 'non-empty game' do
    subject do
      game = described_class.new
      frame1 = Frame.new
      frame1.ball(7)
      frame1.ball(2)
      frame1.simple_score
      frame2 = Frame.new
      frame2.ball(1)
      frame2.ball(8)
      frame2.simple_score
      game.frames += [frame1, frame2]
      game
    end

    it 'has some frames' do
      expect(subject.frames).not_to be_empty
    end

    it { is_expected.not_to be_finished }
  end

  context 'finished game' do
    subject do
      game = described_class.new
      10.times do
        frame = Frame.new
        frame.ball(7)
        frame.ball(2)
        frame.simple_score
        game.frames << frame
      end
      game
    end

    it 'has all frames' do
      expect(subject.frames.size).to eq(10)
    end

    it { is_expected.to be_finished }
  end

  context 'strike' do
    subject do
      game = described_class.new
      @frame = Frame.new
      @frame.ball(10)
      @frame.simple_score
      game.frames << @frame
      game
    end

    it 'has a score of 2 next balls added to it' do
      allow(subject).to receive(:pin_input).and_return(3)
      subject.process_frame
      expect(@frame.is_open_score).not_to be true
      expect(@frame.score).to eq(10 + 3*2)
    end

    it 'has a score after 2 frames added if first one is a strike' do
      allow(subject).to receive(:pin_input).and_return(10)
      subject.process_frame
      expect(@frame.is_open_score).to be true
      subject.process_frame
      expect(@frame.is_open_score).not_to be true
      expect(@frame.score).to eq(10 + 10*2)
    end
  end

  context 'spare' do
    subject do
      game = described_class.new
      @frame = Frame.new
      @frame.ball(2)
      @frame.ball(8)
      @frame.simple_score
      game.frames << @frame
      game
    end

    it 'has a score of 1 next ball added to it' do
      allow(subject).to receive(:pin_input).and_return(3)
      subject.process_frame
      expect(@frame.is_open_score).not_to be true
      expect(@frame.score).to eq(10 + 3)
    end

    it 'has a score of a strike added to it' do
      allow(subject).to receive(:pin_input).and_return(10)
      subject.process_frame
      expect(@frame.is_open_score).not_to be true
      expect(@frame.score).to eq(10 + 10)
    end
  end

  context 'last frame' do
    subject do
      game = described_class.new
      9.times do
        frame = Frame.new
        frame.ball(7)
        frame.ball(2)
        frame.simple_score
        game.frames << frame
      end
      game
    end

    it 'is a strike' do
      allow(subject).to receive(:pin_input).and_return(10)
      subject.play
      last_frame = subject.frames.last
      expect(subject).to be_finished
      expect(subject.frames.size).to eq(10)
      expect(last_frame.is_open_score).not_to be true
      expect(last_frame.score).to eq(9 * 9 + 10 * 3)
    end

    it 'is a spare' do
      allow(subject).to receive(:pin_input).and_return(5)
      subject.play
      last_frame = subject.frames.last
      expect(subject).to be_finished
      expect(subject.frames.size).to eq(10)
      expect(last_frame.is_open_score).not_to be true
      expect(last_frame.score).to eq(9 * 9 + 5 * 3)
    end
  end
end
