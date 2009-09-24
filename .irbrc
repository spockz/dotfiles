require 'rubygems'
require 'wirble'

# Wirble
begin
  # start wirble (with color)
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end