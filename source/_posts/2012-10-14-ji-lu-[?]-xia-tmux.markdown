---
layout: post
title: "紀錄一下 tmux"
date: 2012-10-14 00:02
comments: true
categories: 
---

最近真是用 Tmux 用上癮了，好棒的東西！以前很少用 screen，也不是說 screen 不好，但對於
screen 分割視窗的方法不是很熟悉。另外，screen 使用 ctrl+a 來下指令，和 emacs 的指令衝突，
我不是很喜歡改預設設定，除非我真的無法習慣又非用不可。就因此，我選了 tmux。

在 Mac 上安裝 tmux 和 ubuntu 上面一樣簡單。

{% codeblock lang:sh %}
brew install tmux  # Mac
sudo apt-get install tmux  # Ubuntu
{% endcodeblock %}

## 啟動 tmux：輸入 tmux

在終端機中輸入 tmux，開啟 tmux

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14120925.png %}

## 分割視窗：水平 ctrl-b %，垂直 ctrl-b "

下面有顯示基本資訊和視窗列表的 status bar，有一點類似 byobu。tmux 的控制 prefix 是
ctrl+b，使用 ctrl+b % 用來把視窗分割成水平兩半。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14121427.png %}

也可以分割為垂直的，只要使用 ctrl-b "

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14121924.png %}

分割出來的每一個視窗，稱為 pane。每個 pane 都可以再被分成更小的 pane。好比說剛剛垂直
分割的視窗，也可以再分割為兩個水平的，只要再輸入一次 ctrl-b %

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14122140.png %}

如此一來，切割 pane 的工作就完成了，那如何在 panel 中切換呢？

## 切換 panel：ctrl-b &lt;方向鍵&gt; 或 ctrl-b o

切割完 pane，要在 pane 之間切換，只要用 ctrl-b 和方向鍵就可完成。當然，也可以用 ctrl-b o，
有點類似 emacs 的「往下一個 buffer c-x o」，但是在 pane 多的時候，用方向鍵直覺很多。

## 開新視窗：ctrl-b c

類似 screen 的新視窗，用 c 當作指令。輸入這個指令以後，我們會得到一個全新的 window，下面
status bar 也會出現一個新的項目。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14122933.png %}

## 切換視窗：ctrl-b &lt;數字&gt; 或 下一個：ctrl-b n、前一個：ctrl-b p

其中 status bar 上面寫的視窗編號，我們可以用 ctrl-b 數字，快速切換。比方說，按下 ctrl-b
0，就會回到最剛開始開的視窗。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14123225.png %}

而 ctrl-b n 和 ctrl-b p 分別代表 next 和 pervious，類似 emacs 的表達法（這就是為什麼
我那麼愛 tmux，一整個很 emacs style）

## 輸入指令：ctrl-b :

tmux 眾多的指令，有些要使用參數，可以使用 ctrl-b : 快速鍵來輸入，按下這個快速鍵，游標會
移到 status bar，就可以輸入指令了。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14123605.png %}

## 為視窗改名：renamew &lt;新名稱&gt;

有時候我習慣用一個 window 代表一個針對 bug 工作。但是只要 window 數量一多，很容易搞混。而修改視窗
的名稱，則會顯示在 status bar，算是相當實用的功能。使用 ctrl-b : renamew &lt;new name&gt;
可以完成。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14124139.png %}

## 顯示 pane 的編號：ctrl-b q

視窗有編號，pane 也有編號。知道 pane 的編號可以讓我們更容易操作 pane。按下 ctrl-b q，則
tmux 會用 ASCII art 顯示 pane 的編號。

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14125035.png %}

## 交換 pane：swapp -s &lt;pane1&gt; -t &lt;pane2&gt;

知道編號以後，就可以用 swapp 指令交換 pane 的位置，比方說

{% codeblock lang:sh %}
swapp -s 0 -t 1
{% endcodeblock %}

就可以使得 pane 0 和 pane 1 的位置互相調換

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14125035-1.png %}

## 回捲：ctrl-b [

如果輸出資料太長，一般圖形終端機可以用捲軸往回卷。tmux 也可以。按下 ctrl-b [ 以後，
上下左右鍵可以用來控制捲動方向。此時，使用 ctrl-shift-2 可以開始選取。按下上下左右按鍵
可以修改選取範圍。選取完畢後，可以按下 alt-w 複製。複製的通時會回到一般模式。再按下
ctrl-] 就可以把剛剛複製的東西貼到終端機上面！

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14102929.png %}

## 兩個終端機共用一個 tmux session：attach

介紹最後一個功能，是我愛 tmux 超過 Terminator 的主要原因：假如我下班了，透過 vpn
連回公司。我卻沒有辦法單單用 ssh 就開始使用我在 Terminator 的 session。而是要透過
vnc。個人不喜歡 vnc，尤其是透過 vnc 只為了簡單的指令介面。這時，tmux 可以被共用
的功能，就可以派上用場。

{% codeblock %}
# SSH to your office pc...

$ tmux attach
{% endcodeblock %}

{% img http://i1162.photobucket.com/albums/q535/kk1fff/2012-10-14104138.png %}

## Else

Tmux 是非常強的東西，還有很多東西沒有機會介紹到。常用的在這邊也整理一下。

    ctrl-b ctrl-<方向鍵> -- 調整 pane 大小
    :joinp -s <Window編號>.<Pane編號> -- 把別的 window 的 pane 拉過來
    ctrl-b <空白鍵> -- 改變 pane 的 layout
    ctrl-b d -- Deattch session，把 session 留在機器上，終端機模擬器就可以關閉了

還有什麼想到在補上。

當然，如果用不慣純文字模式，用 Terminator 來作分割終端機也是非常好用。只是沒有辦法
用 SSH 連回去而已。而 tmux 可以降低對滑鼠的依賴（滑鼠基本上可以說是用不上），又可以遠端
工作。還可以類似 screen 般的保持 session 存活。
