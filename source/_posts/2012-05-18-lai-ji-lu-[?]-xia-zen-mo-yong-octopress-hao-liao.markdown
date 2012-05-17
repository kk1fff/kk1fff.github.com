---
layout: post
title: "來紀錄一下怎麼用 Octopress 好了"
date: 2012-05-18 01:25
comments: true
categories: 
---

新增一篇文章

{% codeblock lang:bash %}
$ bundle exec rake new_post['文章的標題']
{% endcodeblock %}

在本機預覽

{% codeblock lang:bash %}
$ bundle exec rake preview
{% endcodeblock %}

發佈出去

{% codeblock lang:bash %}
$ bundle exec rake generate
$ bundle exec rake deploy
{% endcodeblock %}
