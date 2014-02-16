# Jekyll Nada

<p align="center">
  <a href="http://www.imdb.com/title/tt0096256/" target="_blank">
    <img width="100%" src="nada.gif" alt="I have come here to chew bubblegum and kick ass ... and I'm all out of bubblegum.">
  </a>
</p>

## About

**A glorified [Jekyll](http://jekyllrb.com/) include tag.**

I wrote this plugin to help me manage embedding of different types of media (`<img>`, `<iframe>`, HTML5 `<audio>` and `<video>`, etc.) in post pages.

The functionality of the plugin is _very_ similar to the default Jekyll `{% include %}` tag, except that I've added the ability to combine tag, front matter and `site.config` variables (where the former will trump the latter if there are duplicate variables).

Before this plugin, I had [written these](https://github.com/mhulse/jekyll-nada/issues/1) ... I **hated** that all of the HTML was mixed in with the logic.

This plugin allows me to utilize liquid tags to do all the HTML bits and the plugin handles the variable normalization and other non-HTML logic bits.

Check out the [**usage**](#usage) section below for more information.

## Installation

Add this line to your application's Gemfile:

```text
gem 'jekyll-nada', :git => 'git://github.com/mhulse/jekyll-nada.git'
```

And then execute:

```bash
$ bundle install
```

Create a new file in you `_plugins/` folder named `nada.rb` with these contents:

```ruby
# https://github.com/mhulse/jekyll-nada
require 'jekyll-nada'
```

## Usage

Starting with `_config.yml`, you can add global defaults like so:

```yml
nada:
  wrap: "scroll"
```

Next, here's an example post:

```text
---
layout: "post"
title: "My fake post"
date: "2004-05-03 21:10:04"
fig1:
  image: "foo.png"
  caption: "The quick brown fox hxy jumps over the lazy dog."
fig2:
  image: "foo2.gif"
  caption: "The quick brown fox hxy jumps over the lazy dog."
fig3:
  iframe: "http://maps.google.com/maps/ms?ie=UTF8&amp;hl=en&amp;msa=0&amp;msid=105976104673732766876.0004733e85b59d0ddcba6&amp;t=k&amp;ll=46.06983,15.325928&amp;spn=20.139199,49.63623&amp;output=embed"
  caption: "The **quick** brown _fox_ hxy jumps over the lazy dog."
fig4:
  video:
    - "foo1.webm"
    - "foo2.ogv"
    - "foo3.mp4"
  poster: "foo.png"
  caption: "The quick brown fox hxy jumps over the lazy dog."
fig5:
  audio:
    - foo1.ogg"
    - "foo2.mp3"
  caption: "The quick brown fox hxy jumps over the lazy dog."
---

{% nada fig1 %}

{% nada fig2 %}

{% nada fig3 width="100%" height="500" %}

{% nada fig4 class="x6" wrap="mm" %}

{% nada fig5 class="x6" wrap="" %}
```

As stated earlier, the tag variables override the front matter vars which override the `_config.yml` variables.

By defaut, Nada will load a template called `nada.html` from your `_includes` folder. The logic in this template is up to you, and should be based on your needs/front matter.

Here's an example template:

```text
<figure{% if nada.id %} id="{{ nada.id }}"{% endif %}{% if nada.class %} class="{{ nada.class }}"{% endif %}>
	
	{% if nada.wrap %}<div class="{{ nada.wrap }}">{% endif %}
		{% if nada.image %}
			<img
				src="{{ site.uploads }}{{ nada.image }}"
				{% if nada.width %}width="{{ nada.width }}"{% endif %}
				{% if nada.height %}height="{{ nada.height }}"{% endif %}
				{% if nada.alt %}alt="{{ nada.alt }}"{% endif %}
			>
		{% elsif nada.iframe %}
			<iframe
				src="{{ nada.iframe }}"
				{% if nada.width %}width="{{ nada.width }}"{% endif %}
				{% if nada.height %}height="{{ nada.height }}"{% endif %}
				marginheight="0"
				marginwidth="0"
				frameborder="0"
				scrolling="no"
				webkitallowfullscreen
				mozallowfullscreen
				allowfullscreen
			></iframe>
		{% elsif nada.video %}
			<video
				preload="none"
				{% if nada.poster %}poster="{{ site.uploads }}{{ nada.poster }}"{% endif %}
				width="{% if nada.width %}{{ nada.width }}{% else %}480{% endif %}"
				height="{% if nada.height %}{{ nada.height }}{% else %}270{% endif %}"
				controls
			>
				{% for file in nada.video %}
					{% assign ext = file | split: "." %}
					<source
						src="{{ site.uploads }}{{ file }}"
						type="{% case ext[1] %}{% when "mp4" %}video/mp4{% when "ogv" %}video/ogg{% when "webm" %}video/webm{% endcase %}"
					>
				{% endfor %}
			</video>
		{% elsif nada.audio %}
			<audio
				preload="none"
				controls
			>
				{% for file in nada.audio %}
					{% assign ext = file | split: "." %}
					<source
						src="{{ site.uploads }}{{ file }}"
						type="{% case ext[1] %}{% when "ogg" %}audio/ogg{% when "mp3" %}audio/mpeg{% endcase %}"
					>
				{% endfor %}
			</audio>
		{% endif %}
	{% if nada.wrap %}</div>{% endif %}
	
	{% if nada.caption %}<figcaption>{{ nada.caption | markdownify | trim }}</figcaption>{% endif %}
	
</figure>
```

While that may look like a ton of markup, the advantage here is that the same logic isn't crammed into the logic of a plugin file. The control is in the hands of the end user.

Again, the default Jekyll `include` tag could do something very similar; the advantage to my plugin is the variable "normalization", which should make the Liquid logic easier to manage.

Lastly, if you don't want Liquid to parse the included template, append `:raw` to `nada` tag call, like so:

```text
{% nada:raw template="test.html" foo="baz" %}
```

## Feedback

[Bugs? Constructive feedback? Questions?](https://github.com/mhulse/jekyll-nada/issues/new?title=Your%20code%20sucks!&body=Here%27s%20why%3A%20)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nada/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
