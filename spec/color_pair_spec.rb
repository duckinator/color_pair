require 'spec_helper'

describe ColorPair do
  # ...
end

describe ColorPair::RGB do
  describe '.values' do
    it 'are all between 0.0 and 1.0' do
      expect(ColorPair::RGB.values.all? { |v| v >= 0.0 && v <= 1.0 }).to be(true)
    end
  end

  describe '.parse/.to_css' do
    it 'parses an rgb(...) color correctly' do
      expect(
        ColorPair::RGB.parse('rgb(0, 128, 255)').to_rgb_255
      ).to eq([0, 128, 255])
    end
  end
end
