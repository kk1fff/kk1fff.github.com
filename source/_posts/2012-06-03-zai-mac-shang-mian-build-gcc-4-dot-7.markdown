---
layout: post
title: "在 Mac 上面 Build GCC 4.7"
date: 2012-06-03 02:02
comments: true
categories: 
---
Homebrew 和 Macports 不相容，所以只能選一個。不過 Homebrew 追 gcc 的版本似乎是很慢。
也因此，想要體驗 C++ 11 只有靠自己。還好，build GCC 的指令並不難，但是卻有一些小小的
眉角。

### 下載檔案

依據 GCC 的網頁，安裝 GCC 除了需要下載 GCC Source Code 以外，還需要下載 GMP、MPFR
和 MPC 三個套件。這些東西除了 MPC 以外，其他都可以在高速電腦中心的 FTP 下載到。

下載 GCC 原始碼

{% codeblock lang:bash %}
wget ftp://ftp.twaren.net/Unix/GNU/gnu/gcc/gcc-4.7.0/gcc-4.7.0.tar.bz2
tar jxf gcc-4.7.0.tar.bz2
mv gcc-4.7.0 gcc
{% endcodeblock %}

下載附加套件，然後把這些套件放進 GCC 原始碼資料夾下，並且把資料夾的版號去掉，這樣 GCC
就可以搜尋到這些套件，不需要在 configure 下面設定

{% codeblock lang:bash %}
cd gcc
wget ftp://ftp.twaren.net/Unix/GNU/gnu/gmp/gmp-5.0.5.tar.bz2
tar jxf gmp-5.0.5.tar.bz2
mv gmp-5.0.5 gmp
wget ftp://ftp.twaren.net/Unix/GNU/gnu/mpfr/mpfr-3.1.0.tar.bz2
tar mpfr-3.1.0.tar.bz2
mv mpfr-3.1.0 mpfr
wget http://www.multiprecision.org/mpc/download/mpc-0.9.tar.gz
tar zxf mpc-0.9.tar.gz
mv mpc-0.9 mpc
{% endcodeblock %}

### Configure

首先，建立一個和 gcc 目錄同級的 build 目錄，然後進入 build 目錄內進行編譯。這樣可以讓
編譯的結果和 gcc 原始碼分開，確保編譯出來的東西可以很輕易的被 clean。

{% codeblock lang:bash %}
../gcc/configure \
  --prefix=$HOME/local/ \
  --program-suffix=-4.7 \
  --enable-language=c,c++ \
  --with-mpfr-lib=$PWD/mpfr/src/.libs \
  --with-mpfr-include=$PWD/../gcc/mpfr/src
{% endcodeblock %}

其中 --prefix 自然就是這個程式的目錄，而 --program-suffix 則是未來接在 gcc 工具後面的
字串，在這裡加上 -4.7 也就是以後要使用 gcc-4.7 和 g++-4.7 以當作和 Mac 內建 tool 的區
別。

後面的 MPFR 參數則是 configure 的重點，這些沒寫會 build 不過，因為 configure mpc 時
會找不到 mpfr 的 include。如果組態順利，就可以 make 了

### Make

Make 過程很簡單，就是那個老招

{% codeblock lang:bash %}
make -j4
make install
{% endcodeblock %}

如果安裝路徑的 bin 是在 path 以下，那就會有 gcc-4.7 和 g++-4.7 指令。

### Try it

使用 GCC 4.7 當然就是要適用一下 C++11 的功能。這邊去網路上面找到了一個簡單的 lambda
function 程式碼，來嘗試一下。

{% codeblock lang:cpp lambda.cpp %}
#include <iostream>

using namespace std;

int main()
{
  auto func = [] () { cout << "Hello world"; };
  func(); // now call the function
}
{% endcodeblock %}

編譯時記得使用 c++11 的標準

{% codeblock %}
g++-4.7 lambda.cpp -std=c++11
{% endcodeblock %}

### Note

本來想把他做成 Homebrew 套件的，可是看到 gcc45 的 rb 檔，就嚇到了！如果有人會製作
Homebrew 套件，也請指教一下！

[gcc45.rb](https://github.com/staticfloat/homebrew-versions/blob/master/gcc45.rb)

### Reference

* [Downloading GCC](http://gcc.gnu.org/install/download.html)
* [Installing GCC: Configuration](http://gcc.gnu.org/install/configure.html)
