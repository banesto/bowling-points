require_relative '../../lib/frame.rb'

RSpec.shared_examples 'empty frame' do
  it 'has no score' do
    expect(subject.score).to eql(0)
  end

  it 'has no balls' do
    expect(subject.balls).to be_empty
  end

  it { is_expected.not_to be_finished }

  it 'is not a strike' do
    expect(subject).not_to be_strike
  end

  it 'is not a spare' do
    expect(subject).not_to be_spare
  end

  it 'is not an open score' do
    expect(subject.is_open_score).to be false
  end
end

RSpec.describe Frame do

  context 'empty frame' do
    include_examples 'empty frame'
  end

  ['4', -1, 11].each do |bad_ball|
    context "one faulty ball #{bad_ball}" do
      subject do
        frame = described_class.new
        frame.ball(bad_ball)
        frame
      end

      include_examples 'empty frame'
    end
  end

  context 'one good ball' do
    subject do
      frame = described_class.new
      @ball = 0
      frame.ball(@ball)
      frame
    end

    it 'has score' do
      expect(subject.score).to eql(@ball)
    end

    it 'has balls' do
      expect(subject.balls).not_to be_empty
    end

    it 'has given ball' do
      expect(subject.balls).to contain_exactly(@ball)
    end

    it { is_expected.not_to be_finished }

    it 'is not an open score' do
      expect(subject.is_open_score).to be false
    end

    it 'is not a strike' do
      expect(subject).not_to be_strike
    end

    it 'is not a spare' do
      expect(subject).not_to be_spare
    end
  end

  context 'one ball = 10' do
    subject do
      frame = described_class.new
      @ball = 10
      frame.ball(@ball)
      frame
    end

    it 'has score' do
      expect(subject.score).to eql(@ball)
    end

    it 'has balls' do
      expect(subject.balls).not_to be_empty
    end

    it 'has given ball' do
      expect(subject.balls).to contain_exactly(@ball)
    end

    it { is_expected.to be_finished }

    it 'is an open score' do
      expect(subject.is_open_score).to be true
    end

    it 'is a strike' do
      expect(subject).to be_strike
    end

    it 'is not a spare' do
      expect(subject).not_to be_spare
    end
  end


  context 'two balls' do
    context 'zero score' do
      subject do
        frame = described_class.new
        @ball1 = @ball2 = 0
        frame.ball(@ball1)
        frame.ball(@ball2)
        frame
      end

      it 'has score' do
        expect(subject.score).to eql(@ball1 + @ball2)
      end

      it 'has balls' do
        expect(subject.balls).not_to be_empty
      end

      it 'has given balls' do
        expect(subject.balls).to contain_exactly(@ball1, @ball2)
      end

      it { is_expected.to be_finished }

      it 'is not an open score' do
        expect(subject.is_open_score).to be false
      end

      it 'is a strike' do
        expect(subject).not_to be_strike
      end

      it 'is not a spare' do
        expect(subject).not_to be_spare
      end
    end

    context 'score < 10' do
      subject do
        frame = described_class.new
        @ball1 = 3
        @ball2 = 4
        frame.ball(@ball1)
        frame.ball(@ball2)
        frame
      end

      it 'has score' do
        expect(subject.score).to eql(@ball1 + @ball2)
      end

      it 'has balls' do
        expect(subject.balls).not_to be_empty
      end

      it 'has given balls' do
        expect(subject.balls).to contain_exactly(@ball1, @ball2)
      end

      it { is_expected.to be_finished }

      it 'is not an open score' do
        expect(subject.is_open_score).to be false
      end

      it 'is a strike' do
        expect(subject).not_to be_strike
      end

      it 'is not a spare' do
        expect(subject).not_to be_spare
      end
    end

    context 'score = 10' do
      subject do
        frame = described_class.new
        @ball1 = 2
        @ball2 = 8
        frame.ball(@ball1)
        frame.ball(@ball2)
        frame
      end

      it 'has score' do
        expect(subject.score).to eql(@ball1 + @ball2)
      end

      it 'has balls' do
        expect(subject.balls).not_to be_empty
      end

      it 'has given balls' do
        expect(subject.balls).to contain_exactly(@ball1, @ball2)
      end

      it { is_expected.to be_finished }

      it 'is an open score' do
        expect(subject.is_open_score).to be true
      end

      it 'is a strike' do
        expect(subject).not_to be_strike
      end

      it 'is not a spare' do
        expect(subject).to be_spare
      end
    end
  end

  context 'last frame' do
    subject do
      frame = described_class.new(true)
      frame
    end

    it 'is finished if 2 balls have less than 10 sum' do
      subject.ball(1)
      subject.ball(3)
      expect(subject).to be_finished
    end

    it 'is not finished if first ball is 10' do
      subject.ball(10)
      expect(subject).not_to be_finished
    end

    it 'is not finished if first 2 ball sum is 10' do
      subject.ball(2)
      subject.ball(8)
      expect(subject).not_to be_finished
    end

    it 'is not finished if first 2 balls are 10' do
      subject.ball(10)
      subject.ball(10)
      expect(subject).not_to be_finished
    end

    it 'is finished if 3 balls start with strike' do
      subject.ball(10)
      subject.ball(1)
      subject.ball(8)
      expect(subject).to be_finished
    end

    it 'is finished if 3 balls start with spare' do
      subject.ball(2)
      subject.ball(8)
      subject.ball(8)
      expect(subject).to be_finished
    end
  end
end
