---
title: 北京地铁的时间距离
layout: post
guid: urn:uuid:ac28bead-627d-4d6d-8f78-d981730908b8
tags:
  - JavaScript
  - D3.js
  - 北京
  - 地铁
  - 城市
  
---

最近用D3.js写了一个[小网页](/Projects/Beijing_Subway_Distance/index.html)，来计算北京地铁任一站点到其它各个站点之间的时间距离。现在做了一个初版，顺道记录一下实现时候一些有趣的地方。

#### D3.js

D3.js我很早之前就想学，无奈不会js，这次有了这个想法，终于下定决心开始实践。D3.js上手有点不适应，不过理解了它面向数据、用数据生成元素、把数据绑定到D3对象的逻辑之后，其实用起来还是挺方便的。尤其是在处理动态数据的时候，事半功倍，得心应手。

我在学D3.js的时候参考了它的[官方文档](github.com/mbostock/d3/wiki)，也看了这本书[《数据可视化实战：使用D3设计交互式图表》](http://book.douban.com/subject/24748670/)。这本书写得相对基础，有很多细节没有讲到，但是对我这样对JS一无所知的小白来说，入门还是很好的选择。

D3.js用好了还是很帅的。相对来说Processing.js自由度更大，但是用起来麻烦多了。

#### 数据

说到D3.js，首先想到的肯定是数据。北京地铁的数据我是手动输入的，其中的站间时间和换乘时间是利用的百度地图和北京地铁首末班车的数据估算的。

数据录入时有很多实际的考量。考虑到大家都不会坐机场线往返于东直门和三元桥，也不会从T2到T3，我在录入数据的时候只录入了东直门和三元桥分别到T2和T3航站楼的数据。当然这样会出现从T2到T3的时间距离过长的情况，不过考虑到本身这段路程没什么意义，就没有再加以修改。

换乘站的数据我是分别录入的，比如西直门站我分为了2号线、4号线和13号线三个站点录入，方便后面的最短路由算法计算。站间时间和换乘时间都是有向的，虽然在我的数据里两个方向的数据全都一致（机场线除外）。因为我的数据来源没有对上下行和换乘方向所用的时间做出区分，不过我们都知道，2号线和4号线换乘两个方向的时间相差甚多。（事实上，更精细地来说，换乘站的换乘时间和两条线路的上下行方向也有关系。比如国家图书馆的同台换乘。不过我没有考虑这个。）

在最终的图形呈现上，我把换乘站合并为一个，同时对机场线做了符合我们认知的处理。

#### Dijkstra

（我很忧伤永远记不得这个怎么拼……）

在做这个之前，[党主席](https://dangfan.me)告诫我用Python跑Dijkstra会很慢。但是我觉得写C实在是太麻烦了，所以还是用Python跑了一遍，意外地快。后来主席大人说对于大规模的网络来说Python是灾难，但是我这个网络规模还是很小的。

我本想把距离数据跑出来放到文件里直接读，但是既然这么快我就用js重现了一遍。还是挺快的。

以及这次我是第一次写Dijkstra一遍通的。

#### 小bug

最早我使用的是v2版本的D3.js，当我换到v3下面之后发现在我拖动节点的时候整个页面也在运动。[这个网站](http://bl.ocks.org/mbostock/6123708)帮我解决了这个问题。

最早的版本中，换乘站的距离是按照其中某一个线路的站台出发的距离。后期我更改为任意一个线路站台到某站点的最短时间。

#### 其他

我本来想做一个在建/规划线路加入既有线网后的时间距离图，代码也做了一些预留，但是暂时还不打算实现。一方面在建/规划线路的时间只能做一个大概估计，另外一方面这些线路提出了一些很奇葩的问题，比如6号线2期和大站快车的速度和待避时间、亦庄火车站的处理、15号线和16号线在既有线网上加站的处理方法、新机场线、R1、S6、CBD线的速度和票价（是否应该纳入线网的计算）。等我想清楚了这些问题，我会把这部分加上。

附赠北京地铁线路大全，留着备忘：

既有线路  
>1号线（苹果园-四惠东）  
2号线（积水潭-积水潭）  
4号线/大兴线（安河桥北-天宫院）  
5号线（天通苑北-宋家庄）  
6号线（海淀五路居-草房）  
8号线（朱辛庄-南锣鼓巷）  
9号线（国家图书馆-郭公庄）  
10号线（巴沟-巴沟）  
13号线（西直门-东直门）  
14号线（张郭庄-西局）  
15号线（俸伯-望京西）  
八通线（四惠-土桥）  
昌平线（西二旗-南邵）   
亦庄线（宋家庄-亦庄火车站）  
房山线（郭公庄-苏庄）  
机场线（东直门-东直门）  

在建线路  
>6号线二期（草房-东小营）  
7号线（北京西站-焦化厂）  
8号线3期（南锣鼓巷-瀛海）  
14号线东段（善各庄-金台路）  
14号线中段（金台路-西局）  
15号线一期西段（望京西-清华东）  
16号线/山后线（北安河-宛平城）  
西郊线（巴沟-香山）  
昌平线二期（南邵-涧头西）  
机场线西延（东直门-北新桥）

计划线路  
>3号线（田村-高辛庄）   
6号线3期（金安桥-海淀五路居）  
9号线北延（国家图书馆-西二旗）   
11号线（金顶街-六里桥）   
12号线（四季青桥-东坝）   
15号线2期（清华东-西苑）  
15号线东延（俸伯-南彩）    
17号线（未来科技城北-站前区南）  
18线（R1号线，上岸-宋庄）  
19号线（牡丹园-南苑）  
房山线北延（郭公庄-丰益桥南）  
门头沟线（苹果园-石门营）  
燕房线（阎村北-燕化/周口店镇）  
东四环线（青云路-环球影城）  
玉泉路线（福寿岭-西百家窑）  
新机场线（牡丹园-新机场）  
平谷线  
S6线（市郊铁路）  
CBD捷运（东大桥-九龙山）

（据[地铁族](http://www.ditiezu.com/thread-370683-1-2.html)）