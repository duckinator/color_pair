$: << './lib'
require 'sinatra'
require 'color_pair'

get '/' do
  raw_fg, raw_bg = ColorPair.random_pair
  fg, bg = [raw_fg, raw_bg].map(&:to_css)

<<-EOF
<style>
body {
  color: #{fg};
  background: #{bg};
/*  color: rgb(46, 224, 224);
  background: rgb(237, 69, 28);*/
}
</style>
<p>hello, world!</p>
<p>diff: #{ColorPair.color_difference(raw_fg, raw_bg)}</p>
<p>#{raw_fg.to_a}</p>
<p>#{raw_bg.to_a}</p>
<p>fg: #{fg}</p>
<p>bg: #{bg}</p>
EOF
end
