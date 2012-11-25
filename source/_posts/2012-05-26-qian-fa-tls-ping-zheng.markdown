---
layout: post
title: "簽發 TLS 憑證"
date: 2012-05-26 4:39
comments: true
categories: 
published: true
---
使用 SSL 真的是個痛苦的過程，最麻煩的部份莫過於憑證。SSL 除了保障資料不被竊聽以外，還會保障
Server 沒有被調包。為了作這件事情，瀏覽器透過一系列的方法去確定這個 Server 真的就是字面上
打的那個 Server。

瀏覽器如何檢查呢？首先，瀏覽器內建有許多根憑證，這些根憑證憑證商自己簽發給自己的憑證，他的
保證來自於使用者對於瀏覽器廠商的信任，所以我們假設這些憑證都是可被相信的，會一直強調信任
是因為這些根憑證是之後驗證其他憑證的基礎，所以我們如果不相信他，那其他的驗證也別說了。當
我們嘗試連線到一個網站時，瀏覽器會對這個網站作 SSL Handshake，建立 session layer
的連線。這個連線位於 TCP 和 HTTP 之間，可以把他當作是一個安全的可信賴連線。在 SSL
Handshark 的時候，瀏覽器會從 Server 下載 Server 憑證和 Server 的 CA 憑證。這兩個
憑證用來建立所謂的 trust chain。

<!-- more -->

什麼是 trust chain 呢？trust chain 就是一種類似老鼠會的組織。剛剛不是說過，我們的瀏覽
器裡面有內建一些根憑證嗎？因為我們已經相信了這些根憑證，所以我們也就相信了他們認證的憑證，
而他們認證的憑證又認證了新的憑證，我們也相信，如此一來，只要我們從 server 下載到的憑證的
認證單位的認證單位的認證單位....最後是我們瀏覽器的根憑證，那我們就可以相信這個憑證是有效
的。

問題是，你要怎麼取得這種憑證？基本上，沒辦法，除非付錢。你可以付錢，請某個單位幫你認證你的
憑證，這樣的話，因為幫你認證的單位的憑證有被內建在瀏覽器，所以瀏覽器就會認為你的憑證有效。
或者，你也可以自己造一張自簽的憑證，然後用這張憑證去認證你的 server 憑證，再請使用者把這張
自簽憑證手動加入瀏覽器根憑證，當然這狀況就是你的使用者肯、而且他要知道怎麼弄。

測試 SSL 連線當然用後者就可以了。這些步驟都可以使用 OpenSSL 來完成。

簽發 Self-signed 憑證的過程

### 建立 CA 憑證
{% codeblock lang:bash %}
openssl genrsa -des3 -out ca.key 4096  # 建立 CA 私鑰
openssl req -new -x509 -days 365 -key ca.key -out ca.crt  # 簽發 CA 憑證

# 驗證一下，是不是正確
openssl x509 -in ca.crt -text -noout
{% endcodeblock %}

### 建立 Server 憑證
{% codeblock lang:bash %}
openssl genrsa -des3 -out server.key 4096  # 建立 Server 私鑰
openssl req -new -key server.key -out server.csr  # 建立 CSR，這個步驟會要求輸入基本資料，記得，CN 一定要符合 Domain（可以是 localhost 囉）
openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt  # 使用 CA Key 簽發憑證
{% endcodeblock %}

### 匯入瀏覽器

匯入瀏覽器的流程很容易，以 Firefox 來說，在 [設定] -> [Advanced] -> [Encryption]
可以找到 [View Certificates] 按鈕。

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/2012-05-2642500.png %}

按下這個按鈕後，出現憑證列表，選擇 [Authorities]，就會出現所有認證機構的憑證。

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/2012-05-2642358.png %}

最後選擇 [Import] 選取剛剛建立好的 ca.crt，出現一個選項，至少要在相信他簽發的 Website

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/2012-05-2643502.png %}

最後憑證就會出現在列表之中了

{% img center http://i1162.photobucket.com/albums/q535/kk1fff/2012-05-2642500.png %}

匯入 Server 的方式因各種不同 Server 而異，主要會使用到 ca.crt、server.crt 和 server.key
因為使用者已經相信簽發機構簽發的憑證，所以我們匯入 Server 之後，建立的 ssl 就可以被 user
信任。

### Reference
* [Creating Certificate Authorities and self-signed SSL certificates](http://www.tc.umn.edu/~brams006/selfsign.html)
* [How to create a self-signed SSL Certificate](http://www.akadia.com/services/ssh_test_certificate.html)
