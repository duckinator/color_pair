require "color_pair/version"

# Works with linear (0-1) RGB colors.
module ColorPair
  class RGB < Struct.new(:r, :g, :b)
    def self.parse(str)
      str = str.strip
      if str.start_with?("rgb(") && str.end_with?(")")
        r, g, b = str
          .split("rgb(")[1].split(")")[0]
          .split(",")
          .map(&:strip)
          .map(&method(:Integer))
          .map { |i| i.to_f / 255.0 }

        RGB.new(r, g, b)
      else
        raise "Don't know how to parse #{str}"
      end
    end

    def self.values
      # Arbitrary attempt to get a decent spread of colors, but still
      # place a specific upper bound on the number of items.
      ((0..10).map { |i| i.to_f / 10 } +
       (0..9).map { |i| (i.to_f / 10) + 0.5 }
      ).sort
    end

    def self.random
      rgb = Array.new(3) { self.values.sample }
      new(*rgb)
    end

    def luminance
      # From http://stackoverflow.com/questions/596216/formula-to-determine-brightness-of-rgb-color
      # Different luminance algorithm: https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
      # (0.299 * r + 0.587 * g + 0.114 * b)

      if r <= 0.03928 then r2 = r/12.92 else r2 = ((r+0.055)/1.055) ** 2.4 end
      if g <= 0.03928 then g2 = g/12.92 else g2 = ((g+0.055)/1.055) ** 2.4 end
      if b <= 0.03928 then b2 = b/12.92 else b2 = ((b+0.055)/1.055) ** 2.4 end

      0.2126 * r2 + 0.7152 * g2 + 0.0722 * b2
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

  def self.contrast_ratio(a, b)
    al = RGB.new(*a.to_a).luminance
    bl = RGB.new(*b.to_a).luminance

    return contrast_ratio(b, a) if bl > al

    (al + 0.05) / (bl + 0.05)
  end

  # "Contrast (Minimum): The visual presentation of text and images of text has
  # a contrast ratio of at least 4.5:1 [...] (Level AA)"
  # https://www.w3.org/TR/WCAG/#visual-audio-contrast
  def self.good_pair?(a, b)
    diff = contrast_ratio(a, b)

    #puts "#{diff.round(4)} #{[a, b].inspect}"

    diff >= 4.5
  end

  def self.pair_from(base)
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

    possible = []
    RGB.values.map { |r|
      RGB.values.map { |g|
        RGB.values.map { |b|
          rgb = RGB.new(*[r, g, b])
          possible << rgb if self.good_pair?(rgb, base)
        }
      }
    }

#    return nil if possible.empty?

#    p possible

    [base, possible.sample]
  end

  def self.random_pair
    pair_from(RGB.random)
  end
end
