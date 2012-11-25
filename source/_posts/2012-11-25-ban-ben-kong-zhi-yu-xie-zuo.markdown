---
layout: post
title: "版本控制系統和協作模式"
date: 2012-11-25 13:21
comments: true
categories: 
---

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B5348103724.png 'gitk 是 git 的 GUI front-end' %}

參與了幾個計畫，看一些 mailing list 裡面的作法，覺得版本控制真是一個非常有趣的事情。據說有
些公司，仍然在沒有版本控制的世界裡。我很幸運，經歷過的公司都有，讓我學到很多。

版本控制的目的當然就是讓大家可以一起分享一份 source code，可以讓大家同時改自己想改的部份，
可以讓 release 和 develop 的人從某一個時間點開始分開不同的路徑，release 可以專心讓
release 版本變得穩定。也可以在 release 完成後把他們並回主幹。順道一題，媒體常常會在某
W 開頭的作業系統出了以後，就說下一版的已經在開發，我想大家都知道這根本就是廢話，main trunk
本來就是一直走下去的。

廢話不多說。我遇到的第一套工具（自己唸書時用的 SVN 不算），叫做 perforce。Perforce 是一套
商業版的版本控制系統。他是所謂集中式的版本控制。而且公司內部的管理邏輯算是簡單。也就是說，你改
了一下，就 check-in 了。我在第一次上 code 的時候就把 main trunk 弄 build fail（汗），
主要是因為我犯了個明顯的錯誤，但因為缺法 review 的過程，所以沒有人發現。

此外，基於版本管理系統的運作都相當的複雜，通常，除了一個好的客戶端工具（包括 GUI 和指令介面），
還需要一些好的 Guide。Open source 的版本控制系統在網路上已經有很多，而 perforce 不是。
因此少了社群高手對 perforce 的講解和推廣，獲取資訊的來源少了很多。甚至有人只把 perforce
當成是 ftp 抓 code 來用，基於又慢又不熟悉的環境，我一點也不驚訝。

<!-- more -->

## Git

過了一些時間，我參與了另一項計畫。這個計畫使用大家都愛的 git。git，著名的分散式版本控制系統，
對於當時的我，我根本不知道「分散式版本控制系統」的意義在何處。當時我們只用到 git 的其中一個
特性：local branch。git 是非常容易使用和刪除 local branch 的。

    git checkout -b new_branch_namw  # 從現在所在的版本處，開一個 branch，並切到那個 branch
    git branch -D some_branch # 把某個 branch 砍了

但基於 git 本身就需要在 local branch 運作。其實你在開發的那個版本，相對於遠端來源的
branch，早就算是 local branch：從你下 pull 的那一刻起，你機器上的版本和 remote 的版本
就分開了。直到下次 pull 才會重新 merge。

當時我們沒有正確的使用 issue tracking system。因此，local branch 的功能大多數都沒有用到，
我們只是不停 pull，寫，pull，merge，push。也就是 git 最基本的循環。

    git pull # 取得遠端程式碼
    # 開工，寫一些東西
    git commit # 在本地 commit，順便寫些 log
    git pull # 把在你寫程式這段時間的遠端程式 merge 回來
    git mergetool # 如果有任何 conflict，就要用這個指令去啟動 meld 手動合併
    git push # 把你改完的東西送上去

其實，這就是一般 SVN 的循環。除了 git 這個名字聽起來大勝以外。其他沒什麼值得驕傲的。

## Review system

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534820819.png 'Android Open Source Project 的 Gerrit system' %}

過了幾個月，我們的 review system 上線了。是 git 的好朋友，也就是 gerrit。這套在 Android
中廣為使用的 review system 跟 git 可以說是完美的結合。透過 google 提供的 repo 指令，送上
review system 一氣呵成。

    git commit
    repo upload

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534821833.png '正在 Review 的 Gerrit patch' %}

他就會出現在 gerrit 上面，然後 reviewer 會檢視你的 source code，給你意見，最後你可以
修改，改完後

    git commit --amend
    repo upload

去覆蓋上一個 commit。來回幾次，當 review process 完成後，程式就會被送上 main trunk。

## Patch

忘了提，那個我們寫完以後送到 review system 上的檔案，稱為 patch。open source 常用的開發
模型，大抵上是我們一般人把 patch 完成後，交給某些核心成員 review。這些核心成員對 source
code 架構很清楚，也清楚知道目前專案進行的方向，他們會針對每個 patch 給予意見，並且把 review
完成的 patch 送進版本控制系統中。我們一般人只有傳送 patch 的權限，而這些人則有 commit
patch 的權限。

也因此，Patch 的傳遞在 open source 專案中非常重要。有一些 Patch 使用 mailing list
來傳遞，把 patch 檔案夾帶在附件中發送到 mailing list，讓大家去 review 這個 patch。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534822435.png '夾帶在 mail 中的 patch' %}

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534822535.png 'Patch 檔案內容' %}

有一些則使用 Issue tracking system，比方說 Mozilla。Mozilla 使用自行開發的
Bugzilla 當作 Issue tracking system。每個要上 Patch 的人都會先把 Patch 傳送到 Bugzilla
上面去給相關領域的人 review，也可以討論。一旦 Review 完成，每天會有固定的人去蒐集 review
完成但沒有放進主線的 patch，最後把這個 patch 合併到 Mozilla 中稱為 inbound 的 repository。
inbound 可以給人抓下來 build，有些人（像我）喜歡用 inbound 的 source。inbound 經過一天
的自動測試和人工試用以後，如果沒有問題這些 Patch 就會進到 central，也就是 mozilla
source code 的主線。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534822720.png 'Bugzilla 就是 Mozilla 討論或 review patch 的主要環境'%}

換句話說，Patch 的世界裡面，只管你產生出的 Patch，不管你使用的工具。Mozilla 是使用一套
和 git 類似的分散式版本控制工具--mercurial，並且使用 mercurial queue 來管理 local patch。
但這不代表熟悉 git 的人一定要學習 mercurial。mozilla 有一個對應的 git mirror。只要用
git 能夠產生出合乎格式的 patch，一樣可以 review 並且上到 central。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534823324.png 'Patch 進入 inbound 之後' %}

如果用 patch 的角度來看，gerrit 其實也是送 patch，只是 patch 是由自動化工具產生，並且
自動上傳到 gerrit 去 review。

## Pull request

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534824555.png 'Review 一個 pull request' %}

{% img http://i1162.photobucket.com/albums/q535/kk1fff/87A25E555FEB71672012-11-254E0B534824537.png '檢視 Pull request 的 diff' %}

若要說起分散式版本控制的最大突破，我想 pull request 大概當之無愧。這得先說一下 git 的特性。
當 A 和 B 是兩個不同的 repositery，卻有共用的歷史。此時，把 A merge 到 B 和把 B merge
到 A 都是可行的。分散式的世界裡，所有的 repositery 都可以是 server 也都可以是 client。
換句話說，如果你從某個 repositery 拿到了一份 code，改完了，你想 merge 回主線，你不一定
要親自 commit，也可以要求對方來 pull 你的 change，這就是 pull request。

要用 pull request，首先要先在 github 下 fork 一個專案，也就是說，把你想要改的專案整個複製
一份到你自己的 github 帳號底下。接下來，把你自己的 fork 的專案 clone 到硬碟裡面，修改你想
修改的部份，然後 commit、push 送回到 github，接下來，到 github 內，選取想要 pull request
的 branch，然後按下上面的 pull request 按鈕，選擇要送給哪個專案的哪個 branch，寫下
comment，一切就完工了。

收到 pull request 的一方，則會被 email 通知。就可以對這個 patch（沒錯，又是 patch）進行
review。review 完成後如果要 merge，可以選擇直接在旁邊的按鈕按下 merge。或是，使用指令
介面。使用指令介面的好處是：可以 rebase，如此可以保持版本樹的乾淨。

假設我收到一個來自帳號 kk1fff，Repo gaia 而 branch 叫做 work793111 的 pull request，
而我要 merge 進入我的主幹，那我可以進入 repostory 的資料夾：

    git remote kk1fff git://github.com/kk1fff/gaia.git # 加入一個 repo
    git fetch kk1fff # 取回 git 資料
    git checkout kk1fff/work793111 # 把 branch 的資料 fetch 出來
    git checkout -b merging_kk1fff # 建立新分支
    git rebase b2g/gaia # 把這個新分支 rebase 到現在的 main trunk 上
    git push b2g gaia # 推上去，大功告成

## 小結

每個專案都有不同的協同開發方式。Open source 專案幾乎都是 based on patch，就是由有心人去
修正軟體，產生 patch，在由比較熟悉專案的人物去合併進入主幹。Patch 的好處是增加了 review
的流程，但相對的畫的時間也比較多一點。針對不同的情況也可以進行討論。但小型專案的話，這樣的
程序就顯得過於複雜。讓大家都有 checkin 版本控制的權限就會顯得簡單多。
