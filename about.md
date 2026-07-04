---
layout: page
title: About
permalink: /about/
---

<img class="about-avatar" src="{{ site.author.avatar | relative_url }}" alt="{{ site.author.name }}" onerror="this.style.display='none'">

{{ site.author.bio }}

## Background

{{ site.author.background }}

## Areas of interest

<ul class="interest-list">
{% for interest in site.author.interests %}
  <li>{{ interest }}</li>
{% endfor %}
</ul>

<div class="about-links">
  <a href="{{ site.author.github }}" target="_blank" rel="noopener me">GitHub</a>
  <a href="{{ site.author.linkedin }}" target="_blank" rel="noopener me">LinkedIn</a>
  <a href="mailto:{{ site.author.email }}">Email</a>
</div>
