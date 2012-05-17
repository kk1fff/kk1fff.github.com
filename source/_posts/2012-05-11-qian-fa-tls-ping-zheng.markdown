---
layout: post
title: "簽發 TLS 憑證"
date: 2012-05-13 14:49
comments: true
categories: 
published: false
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

什麼是 trust chain 呢？trust chain 就是一種類似老鼠會的組織。剛剛不是說過，我們的瀏覽
器裡面有內建一些根憑證嗎？因為我們已經相信了這些根憑證，所以我們也就相信了他們認證的憑證，
而他們認證的憑證又認證了新的憑證，我們也相信，如此一來，只要我們從 server 下載到的憑證的
認證單位的認證單位的認證單位....最後是我們瀏覽器的根憑證，那我們就可以相信這個憑證是有效
的。

問題是，你要怎麼取得這種憑證？基本上，沒辦法，除非付錢。你可以付錢，請某個單位幫你認證你的
憑證，這樣的話，因為幫你認證的單位的憑證有被內建在瀏覽器，所以瀏覽器就會認為你的憑證有效。
或者，你也可以自己造一張自簽的憑證，然後用這張憑證去認證你的 server 憑證，再請使用者把這張
自簽憑證手動加入瀏覽器根憑證，當然這狀況就是你的使用者肯、而且他要知道怎麼弄。

測試 SSL 連線當然用後者就可以了。所以，我們要怎麼建立 SSL 憑證呢？建立憑證的步驟，不外乎

1. 建立私鑰
1. 建立 CSR(Certificate signing request)，這個步驟將會需要輸入憑證的相關資訊。
1. 簽發憑證，這個步驟是透過簽發單位，對 CSR 作簽章，經過這個步驟後，就可以取得正式的
憑證。

這些步驟都可以使用 OpenSSL 來完成。

簽發 Self-signed 憑證的過程

{% codeblock lang:bash %}
$ openssl genrsa -des3 -out ca.key 2048  # 建立 CA 私鑰
$ openssl req -new -x509 -key ca.key -out ca.csr  # 建立 CSR
$ openssl x509 -days 365 -in ca.csr -signkey ca.key -out ca2.crt  # 對 CSR 作簽章，有效期 365 天。由於私鑰和建立 CSR 的私鑰是同一個，所以就成了 self-signed certificate

# 驗證一下，是不是正確
$ openssl x509 -in ca.crt -text -noout
{% endcodeblock %}

上面這段指令的功用，就是產生一個 Key、一個 Version 3 的 CSR、然後簽證他。第一行指令不難
理解，其中 des3 是金鑰演算法，2048 是長度。第二行指令則是用 req 指令，-new 代表產生
新的 CSR，-key 表示產生 CSR 的金鑰，而
