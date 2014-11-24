---
title: 城市骨骼
layout: post
guid: urn:uuid:ac28bead-627d-4d6d-8f78-d981730908b8
tags:
  - 城市
  - 北京
  - Python
  - Gephi
  
---

闲来无事利用Python在8684.cn上抓取了公交线路和站点信息，然后用Gephi画出了站点之间的拓扑结构并用了自带的Force Altas算法做了处理，算是假期的无聊消遣。

一些图片的效果意外地好（比如成都的），可以看出城市中公交线路的分布和城市的发展有着千丝万缕的关系。

---
因为是第一次用Python，所以代码写得东倒西歪，效率也很低，不过我是一个懒到透顶的人，扔在那里不处理了。

文件1 抓取8684上的线路信息

	#!/usr/bin/python
	
	from bs4 import BeautifulSoup
	import urllib2
	import re
	import time
	
	City='suzhou'
	CityNumber=14
	UrlStr = "http://"+City+".8684.cn/line"
	for i in range(1,CityNumber+1):
		Url = UrlStr+str(i)
		time.sleep(1)
		Req = urllib2.Request(Url)
		resp = urllib2.urlopen(Req)
		respHtml = resp.read()
		soup = BeautifulSoup(respHtml,fromEncoding="GB2312")
		if i==1:
			Found = soup.findAll('a',href=re.compile(r"/x_(?!ff2b3e48)"))
			print i
		elif i!=7: 
			Found = Found + soup.findAll('a',href=re.compile("/x_(?!ff2b3e48)"))
			print i
	
	print "Res=",Found
	class Line:
		def __init__(self):
			self.name=''
			self.link=''
	LineSet=[]
	p1=re.compile(r"><")
	p2=re.compile(r"")
	fileH=open('LineUrl.txt','w')
	for j in range(0,len(Found)):
		thisStr=str(Found[j])
		thisLine=Line()
		thisLine.name=thisStr.split('>')[1].split('<')[0]
		thisLine.link="http://"+City+".8684.cn"+thisStr[9:20]
		LineSet.append(thisLine)
		print j,LineSet[j].name, LineSet[j].link
		fileH.write(thisLine.name+','+thisLine.link+';')
	fileH.close()
文件2 抓取8684上每条线路的站点信息

	#!/usr/bin/python
	#coding=utf-8
	
	from bs4 import BeautifulSoup
	import urllib2
	import re
	import time
	
	fileU=open('LineUrl.txt')
	urlStr=fileU.read()
	fileU.close()
	spUrl=urlStr.split(';')
	print spUrl
	FileS=open('Site.txt','a')
	for i in range(0,len(spUrl)-1):
		if(spUrl[i].find('8684.cn/x_ff2b3e48')>=0):
			print 'find!'
			continue
		name=spUrl[i].split(',')[0]
		Url=spUrl[i].split(',')[1]
		Req = urllib2.Request(Url)
		resp = urllib2.urlopen(Req)
		respHtml = resp.read()
		soup = BeautifulSoup(respHtml,fromEncoding="gb18030")
		Found = soup.findAll(attrs={'class':'hc_p8'})
	
		for j in range(0,len(Found)):
			Res1=str(Found[j]).split(r'<a href=')
			FileS.write(str(i)+'|'+name+'|'+Res1[0].split('<i>')[1].split('：')[0]+'|')
			for k in range(1,len(Res1)):
				FileS.write(Res1[k].split('>')[1].split('<')[0]+'@')
			FileS.write('\n')
		print i, name
		time.sleep(1)
	FileS.close()

文件3 合并处理线路信息的格式

	#!/usr/bin/python
	#coding=utf-8
	
	import urllib2
	import re
	import time
	
	fileU=open('Site.txt')
	urlStr=fileU.read()
	fileU.close()
	spUrl=urlStr.split('\n')
	class line:
		def __init__(self):
			self.id=-1
			self.name=''
			self.station=[]
	spLine=[]
	for i in range(0,len(spUrl)-1):
		ThisLine=line()
		tempstr=str(spUrl[i]).split('|')
		ThisLine.id=tempstr[0]
		ThisLine.name=tempstr[1]+'|'+tempstr[2]
		ThisLine.station=tempstr[3].split('@')
		print ThisLine.name
		print ThisLine.station[1]
		ThisLine.station.remove('')
		spLine.append(ThisLine)
		print 'spUrl', i
	class p_station:
		def __init__(self):
			self.name=''
			self.line=[]
			self.count=0
	StationPair=[]
	StationSet=[]
	for i in range(0,len(spLine)):
		i1=0
		i2=0
		for j in range(0,len(spLine[i].station)-1):
			StationStr=spLine[i].station[j]+'%'+spLine[i].station[j+1]
			if StationStr in StationSet:
				This=StationPair[StationSet.index(StationStr)]
				This.line.append(spLine[i].name)
				This.count+=1
				i1+=1
			else:
				ThisPair=p_station()
				ThisPair.name=StationStr
				ThisPair.line.append(spLine[i].name)
				ThisPair.count+=1
				StationPair.append(ThisPair)
				StationSet.append(StationStr)
				i2+=1
		print 'spLine', i, spLine[i].name, len(StationPair), 'New=',i2,'Added=',i1
	fileP=open('StationPair.txt','a')
	for i in range(0,len(StationPair)):
		fileP.write(StationPair[i].name+'@'+str(StationPair[i].count)+'@')
		for j in range(0,len(StationPair[i].line)):
			fileP.write(StationPair[i].line[j]+'~')
		fileP.write('\n')
		print 'station', i
	fileP.close()

文件4 将线路信息处理成Gephi的格式

	#!/usr/bin/python
	#coding=utf-8
	
	import urllib2
	import re
	import time
	
	fileU=open('StationPair.txt')
	PairStr=fileU.read()
	fileU.close()
	Pair=PairStr.split('\n')
	class p_station:
		def __init__(self):
			self.start=''
			self.end=''
			num=0
	DoP=[]
	for i in range(0,len(Pair)-1):
		newp=p_station()
		newp.num=str(Pair[i]).split('@')[1]
		newp.start=str(Pair[i]).split('@')[0].split('%')[0]
		newp.end=str(Pair[i]).split('@')[0].split('%')[1]
		DoP.append(newp)
	fileD=open('DoP.txt','w')
	fileD.write('source\ttarget\tweight\n')
	for i in range(0,len(DoP)):
		fileD.write(DoP[i].start+'\t'+DoP[i].end+'\t'+DoP[i].num+'\n')
	fileD.close()

---
我知道你们是不会看上面的代码的

贴两张效果图

![Beijing](/media/images/beijing.png)

![Lanzhou](/media/images/lanzhou.png)

![Chengdu](/media/images/chengdu.png)