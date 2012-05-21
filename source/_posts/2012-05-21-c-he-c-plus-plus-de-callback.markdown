---
layout: post
title: "C 和 C++ 的 Callback"
date: 2012-05-21 11:58
comments: true
categories: 
---
### C 的 Callback

Callback 把函數當成指標，在 C 裡面是這樣用

{% codeblock lang:c %}
#include <stdio.h>

int compute(int a, int b, int (*op)(int, int)) {
  return (*op)(a, b);
}

int add(int a, int b) {
  return a+b;
}

int sub(int a, int b) {
  return a-b;
}

int main() {
  fprintf(stdout, "add: %d\n", compute(10, 5, &add));
  fprintf(stdout, "sub: %d\n", compute(10, 5, &sub));
}
{% endcodeblock %}

宣告時包含函數雛型，用 * 來宣告

{% codeblock lang:c %}
int (*op) (int, int)
{% endcodeblock %}

傳入時使用取址運算子去取得函數指標

{% codeblock lang:c %}
&add
{% endcodeblock %}

呼叫時 dereference 然後當函數使用

{% codeblock lang:c %}
int result = (*op)(a, b);
{% endcodeblock %}

這樣的方法也可以用在 C++ 的靜態函數中（類別函數），但是不能用在物件函數。

### C++ 的 Callback

C++ 有 this 指標，物件函數是需要有物件資料的。所以不能用傳統 C 的方式傳遞函數指標。C++
物件函數的指標使用是這樣。

{% codeblock lang:cpp %}
#include <iostream>

class Ops {
 public:
  int add(int b) {
    return a+b;
  }
  
  int sub(int b) {
    return a-b;
  }
  int a;
};

int compute(Ops* obj, int (Ops::*op)(int), int b) {
  return (obj->*op)(b);
}

int main() {
  Ops obj;
  obj.a = 10;
  std::cout << "Add: " << compute(&obj, &Ops::add, 5) << std::endl;
  std::cout << "Sub: " << compute(&obj, &Ops::sub, 5) << std::endl;
  return 0;
}
{% endcodeblock %}

宣告的時候需要帶類別和雛型

{% codeblock lang:cpp %}
int (Ops::*op)(int)
{% endcodeblock %}

傳送時用 &amp; 運算子取址

{% codeblock lang:cpp %}
&Ops::add
{% endcodeblock %}

呼叫時，需要使用實體來呼叫，實體可以是指標也可以是物件參考

{% codeblock lang:cpp %}
int result = obj->*op(a);  // 物件是指標形式時
int result = obj.*op(a);    // 物件是參考形式時
{% endcodeblock %}

### Reference

* [The Syntax of C and C++ Function Pointers](http://www.newty.de/fpt/fpt.html#chapter2)
