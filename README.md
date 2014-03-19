# Jekyll Nada

<p align="center">
  <a href="http://www.imdb.com/title/tt0096256/" target="_blank">
	<img width="100%" src="nada.gif" alt="I have come here to chew bubblegum and kick ass ... and I'm all out of bubblegum.">
  </a>
</p>

## About

**A glorified [Jekyll](http://jekyllrb.com/) include tag.**

I wrote this plugin to help me manage embedding of different types of media (`<img>`, `<iframe>`, HTML5 `<audio>` and `<video>`, Flash, etc.) in post pages.

The functionality of this plugin is _very_ similar to the default Jekyll `{% include %}` tag, except that I've added the ability to combine tag, front-matter and `site.config` variables (where the former will trump the latter if there are duplicate variables).

Before this plugin, I had [written these](https://github.com/mhulse/jekyll-nada/issues/1) ... Long story short, I **hated** that all of the HTML was mixed in with the logic.

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

**OR**, even better, add the following to your site's `_config.yml`:

```yml
gems:
  - jekyll-nada
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

As stated earlier, the tag variables override the front-matter variables, which override the `_config.yml` variables.

By defaut, Nada will load a template called `nada.html` from your `_includes` folder. The logic in this template is up to you, and should be based on your needs/front-matter.

Here's an example template:

```text
<figure{% if nada.id %} id="{{ nada.id }}"{% endif %}{% if nada.class %} class="{{ nada.class }}"{% endif %}>
	
	{% if nada.wrap %}<div class="{{ nada.wrap }}">{% endif %}
		{% if nada.image %}
			{% if nada.lat and nada.lon %}
				<a href="https://www.google.com/maps/place/{{ nada.lat | cgi_escape }}+{{ nada.lon | cgi_escape }}" target="_blank" rel="nofollow">
			{% endif %}
			<img
				src="{{ site.uploads }}{{ nada.image }}"
				{% if nada.width %}width="{{ nada.width }}"{% endif %}
				{% if nada.height %}height="{{ nada.height }}"{% endif %}
				{% if nada.alt %}alt="{{ nada.alt }}"{% endif %}
			>
			{% if nada.lat and nada.lon %}
				</a>
			{% endif %}
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
		{% elsif nada.flash %}
			<object type="application/x-shockwave-flash" data="{{ site.uploads }}{{ nada.flash }}" width="{{ nada.width }}" height="{{ nada.height }}">
				<param name="movie" value="{{ site.uploads }}{{ nada.flash }}">
				<param name="allowscriptaccess" value="always">
				<param name="menu" value="false">
				<param name="quality" value="high">
				<param name="flashvars" value="{{ nada.flashvars }}">
				{% if nada.base %}<param name="base" value="{% if nada.base contains "http" %}{{ nada.base }}{% else %}{{ site.uploads }}{{ nada.base }}{% endif %}">{% endif %}
				<p><a href="http://www.adobe.com/go/getflash"><img src="http://wwwimages.adobe.com/www.adobe.com/content/dam/Adobe/en/legal/logo/160x41_get_flashplayer.gif" alt="Get Adobe Flash player"/></a></p>
			</object>
		{% endif %}
	{% if nada.wrap %}</div>{% endif %}
	
	{% if nada.caption %}<figcaption>{{ nada.caption | markdownify | trim }}</figcaption>{% endif %}
	
</figure>
```

While that may look like a lot of markup, the advantage here is that the same markup isn't crammed into the logic of a plugin file. Using a template puts full control into the hands of the end user.

Again, the default Jekyll `include` tag could do something very similar; the advantage to my plugin is the multi-level variable "normalization", which should make the Liquid logic easier to manage.

Lastly, if you don't want Liquid to parse the included template, append `:raw` to `nada` tag call, like so:

```text
{% nada:raw template="test.html" foo="baz" %}
```

## Contributing

Please read the [CONTRIBUTING.md](https://github.com/mhulse/jekyll-nada/blob/branch/CONTRIBUTING.md).

### TL;DR:

1. Fork it: `http://github.com/<my-github-username>/nada/fork`
1. Create your feature branch: `git checkout -b my-new-feature`
1. Commit your changes: `git commit -am 'Add some feature.'`
1. Push to the branch: `git push origin my-new-feature`
1. Create new [pull request](https://github.com/mhulse/jekyll-nada/pulls).

## Feedback

[Bugs? Constructive feedback? Questions?](https://github.com/mhulse/jekyll-nada/issues/new?title=Your%20code%20sucks!&body=Here%27s%20why%3A%20)

## Changelog

* [v0.0.1 milestones](https://github.com/mhulse/jekyll-nada/issues?direction=desc&milestone=1&page=1&sort=updated&state=closed)

## [Release history](https://github.com/mhulse/jekyll-nada/releases)

* 2014-02-22   [v0.0.1](https://github.com/mhulse/jekyll-nada/releases/tag/v0.0.1)   Hello world!

---

#### LEGAL

Copyright © 2014 [Micky Hulse](http://mky.io)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

<img width="20" height="20" align="absmiddle" src="https://github.global.ssl.fastly.net/images/icons/emoji/octocat.png" alt=":octocat:" title=":octocat:" class="emoji">
