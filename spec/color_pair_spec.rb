require 'spec_helper'

describe ColorPair do
  # ...
end

describe ColorPair::RGB do
  describe '.parse/.to_css' do
    it 'parses an rgb(...) color correctly' do
      expect(
        ColorPair::RGB.parse('rgb(0, 128, 255)').to_rgb_255
      ).to eq([0, 128, 255])
    end
  end
end
