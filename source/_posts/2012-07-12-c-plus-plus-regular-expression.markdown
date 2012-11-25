---
layout: post
title: "C++ Regular Expression"
date: 2012-07-12 17:54
comments: true
categories: 
---
用過 Python 以後，就會深深愛上 Python 那強大的 Regex parsing 能力。回過頭來，對
於 C++ parsing 的功能，我還停留在 scanf 和 &gt;&gt; 這兩個基本到到不行的功能，
聽說 C++11 有加入了 Regular Expression 的功能。就順便來研究一下，希望 C++ 能夠
有足以和 Perl 或 Python 那個家族的 Parsing 能力。

原本希望用 clang 3.1 來編譯，但是遇到
{% codeblock lang:cpp %}
#include <regex>
{% endcodeblock %}
就掛了，顯然 based library 還沒 Ready。改用 g++-4.7 就過了，可是，一切沒那麼容易，
我不管建立任何 Regular expression 都會被丟出例外，連 wikipedia 上面的範例都噴射，
最後只好放棄。考慮到 C++11 的 regex 是來自 boost，乾脆直接拿 boost 來用。

<!-- more -->

使用 clang 或是 g++ 要注意指定 -std=c++11，而使用 boost，因為只是第三方 library，
不需要指名使用 C++11 的標準，但是要注意連結 boost library。以我的 Mac 來說，
使用 brew 安裝 Boost
{% codeblock lang:bash %}
$ brew install boost
# 會被安裝在 /usr/local/Cellar/boost/1.49.0
{% endcodeblock %}
要注意使用 -lboost_regex-mt 參數來連結。

那就直接來看檔案吧
{% codeblock lang:cpp regex.cpp %}
#ifdef USE_BOOST_REGEX
#include <boost/regex.hpp>
#else
#include <regex>
#endif

#include <iostream>
#include <string>

#ifdef USE_BOOST_REGEX
using namespace boost;
#endif

int main() {
  try {
    regex reg("[0-9]+");
    std::string s = "<tag>1</tag>";

    smatch mat;
    std::cout << "Matched: " << regex_search(s, mat, reg) << std::endl;

    ssub_match prefix = mat.prefix();
    std::string str_prefix(prefix.first, prefix.second);
    std::cout << "Prefix: " << str_prefix << std::endl;
    std::cout << "Length: " << prefix.length() << std::endl;

    
  } catch (const regex_error& e) {
    std::cout << "Error: " << e.what() << std::endl;
  }
}
{% endcodeblock %}

{% codeblock lang:makefile Makefile %}
regex: regex.cpp
	@echo "Will now build" $^
	$(CXX) $^ -g3 -lboost_regex-mt -DUSE_BOOST_REGEX -o regex

.PHONY: regex
{% endcodeblock %}

Regex 在 C++11 和 boost 有些許差異：在 C++11 中，使用 &lt;regex&gt; 標頭，函數
命名空間在 std；在 boost 中，使用 &lt;boost/regex.hpp&gt; 標頭檔，命名空間是
boost。其他部分幾乎是相同的。

regex 類別是用來放 regex pattern 的類別，使 basic_regex 樣板定義的類別，宣告是
這樣

{% codeblock lang:cpp %}
typedef basic_regex<char>      regex;
typedef basic_regex<wchar_t>   wregex;
{% endcodeblock %}

所以寬字元使用 wregex。但我們一般使用 UTF-8 使用 regex 就可以。

regex matching 提供兩個 function：regex_match 和 regex_search。這兩個函數的功用
分別是：regex_match 要 match 整個輸入字串，而 regex_search 只需要 match 部分字串。
