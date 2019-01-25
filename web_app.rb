#!/usr/bin/env ruby

$: << "./lib"
require "sinatra"
require "color_pair"

def css(fg, bg)
  <<~EOF
    body {
      padding: 1em;
      font-family: sans-serif;
      max-width: 60ch;
      margin: auto;
      font-size: 120%;
      color: #{fg};
      background: #{bg};
    }

    input, textarea {
      padding: 1em;
      color:inherit;
    }
    input[type=text], textarea {
      background: rgba(0, 0, 0, 0.2);
    }
    input[type=submit], input[type=button] {
      background: rgba(255, 255, 255, 0.2);
    }

    textarea {
      width: 100%;
    }
  EOF
end

get "/" do
  if params[:color]
    color = ColorPair::RGB.parse(params[:color])
  else
    color = ColorPair::RGB.random
  end

  raw_fg, raw_bg = ColorPair.pair_from(color)
  fg, bg = [raw_fg, raw_bg].map(&:to_css)

<<-EOF
<style>
#{css(fg, bg)}
</style>
<p>hello, world!</p>
<form>
<label>Foreground: <input name="color" type="text" value="#{fg}"></label>
<input type="submit" value="Submit">
</form>
<p>Background: #{bg}</p>
<p>Contrast ratio: #{ColorPair.contrast_ratio(raw_fg, raw_bg).round(2)}:1</p>

<!-- bullshit it and hard-code the height, since we know the number of rows -->
<textarea rows=26>
#{css(fg, bg)}
</textarea>
EOF
end
