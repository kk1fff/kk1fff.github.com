---
layout: post
title: "把 Ubuntu 12.10 的 GCC 降級"
date: 2013-01-13 01:43
comments: true
categories: 
---
Ubuntu 12.10 預設安裝 gcc 4.7，但是這個版本的 gcc 在 build 一些東西的時候會出現問題，比方說，
ICS，或是目前的 Firefox OS，在 KeyedVector 那邊會有問題。其實降級的指令可以用在很多地方，就是
update-alternatives

{% codeblock lang:sh %}
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.6
{% endcodeblock %}

alternatives 也有圖形化介面 -- galternatives，不過這個需要另外用 apt-get 安裝

{% codeblock lang:sh %}
sudo apt-get install galternatives
{% endcodeblock %}

