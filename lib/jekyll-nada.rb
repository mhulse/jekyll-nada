require "jekyll-nada/version"
require "jekyll-nada/nada"

# Register liquid tag with Jekyll:
Liquid::Template.register_tag('nada', Jekyll::Nada::NadaTag)