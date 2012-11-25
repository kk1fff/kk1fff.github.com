---
layout: post
title: "Hello World to B2G"
date: 2012-05-20 00:25
comments: true
categories: 
---

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/b2g_lock.png %}

今天趁 JSDC 一股熱忱，決定來練習一個 B2G App。

### Hello Gaia

建立 B2G App 首先要當然是要替檔案建立資料夾，我直接建立在 Gaia/apps 底下，開一個 hello 資料夾，
再來建立的是 mainfest.json，依據 [App manifest](https://developer.mozilla.org/en/Apps/Manifest)
網頁上的描述，這個檔案至少有 name 和 description 要寫，類似這樣

{% codeblock lang:javascript manifest.json %}
{
  "name" : "hello world",
  "version" : "0.0.1",
  "description" : "this is hello"
}
{% endcodeblock %}

<!-- more -->

其中要注意就是 XULRunner 對於 json 的處理似乎比 node 還要更嚴謹，JSON 的 key 值一定
要用雙引號，而且結尾不可以有逗號。

再來就是一個簡單的 index.html

{% codeblock lang:html index.html %}
<html>
<head></head>
<body>
hello gaia.
</body>
</html>
{% endcodeblock %}

之後到 gaia 的 root，先砍掉已經 build 好的 profile （如果先前有 build 過），再重新
make

{% codeblock lang:bash %}
$ rm -r profile
$ make
{% endcodeblock %}

Build 完以後，重新執行 Gaia 的模擬器，就可以看到：app 出現了！！

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/2012-05-2015813.png %}

點一下我們剛剛弄好的 hello，就會跑出剛剛網頁的內容

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/2012-05-2020205.png %}

### Map

從 Openstreet Map 上面可以取得我們所想要的地圖資料，在透過 iframe 就可以把他嵌進網頁裡面
只要把剛剛的 hello gaia 稍微小改一下

{% codeblock lang:html index.html %}
<html>
<head></head>
<body>
<iframe width="425" height="350" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://www.openstreetmap.org/export/embed.html?bbox=121.296,24.9586,121.3607,25.0079&amp;layer=mapnik" style="border: 1px solid black"></iframe><br /><small><a href="http://www.openstreetmap.org/?lat=24.98325&amp;lon=121.32835&amp;zoom=14&amp;layers=M">View Larger Map</a></small>
</body>
</html>
{% endcodeblock %}

重新編譯後，馬上，地圖就出現了

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/2012-05-2020648.png %}

### Reference

* [WebAPI](https://wiki.mozilla.org/WebAPI)
* [Getting started with making apps](https://developer.mozilla.org/en/Apps/Getting_Started)
* [App manifest](https://developer.mozilla.org/en/Apps/Manifest)
