require "color_pair/version"

# Works with linear (0-1) RGB colors.
module ColorPair
  class RGB < Struct.new(:r, :g, :b)
    def self.random
      rgb = Array.new(3) { rand.round(2) }
      new(*rgb)
    end

    def luminance
      # From http://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
      (0.299 * r + 0.587 * g + 0.114 * b)
    end

    def to_a
      [r, g, b]
    end

    def to_rgb_255
      [r, g, b].map {|x| (255 * x).round(0) }
    end

    def to_css
      "rgb(" + to_rgb_255.join(', ') + ")"
    end
  end

  def self.color_difference(a, b)
    a = a.to_a.map(&:to_f)
    b = b.to_a.map(&:to_f)

    a.zip(b).map{|l, r| [l, r].max - [l, r].min}.reduce(:+)
  end

  # I couldn't figure out the appropriate value from http://www.w3.org/TR/WCAG20/#contrast-ratiodef
  # So I went with 1.0 because it resulted in pretty colors.
  def self.good_pair?(a, b)
    diff = color_difference(a, b)

    puts "#{diff.round(2)} #{[a, b].inspect}"

    diff >= 4.5
  end

  # FIXME: Potentially-infinite loop.
  def self.random_for(base)
    r, g, b = base.to_a
    rgb = r + g + b
    if rgb > 0.5
      r -= 0.5
      g -= 0.5
      b -= 0.5
    else
      r += 0.5
      g += 0.5
      b += 0.5
    end
    r, g, b = [r, g, b].map{|x| x = 1 if x > 1; x = 0 if x < 0; x}

    return RGB.new(r, g, b)
    #return RGB.new(*base.to_a.map{|x| x > 0.5 ? x + 0.5 : x - 0.5 })

    rgb = nil

    loop do
      rgb = RGB.random
      break if good_pair?(base, rgb)
    end

    rgb
  end

  def self.random_pair
    a = RGB.random
    b = random_for(a)

    [a, b]
  end
end
