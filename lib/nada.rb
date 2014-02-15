require "nada/version"
require "nada/nada"

# Register liquid tag with Jekyll:
Liquid::Template.register_tag('nada', Jekyll::Tags::Nada)