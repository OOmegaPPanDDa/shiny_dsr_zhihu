from langconv import *

f = open('ntusd-negative.txt','r',encoding = 'utf-8')
data = []
for line in f:
	data.append(Converter('zh-hant').convert(line))
f.close()

f = open('traditional-ntusd-negative.txt','w',encoding = 'utf-8')
f.write(''.join(data))
f.close()

f = open('ntusd-positive.txt','r',encoding = 'utf-8')
data = []
for line in f:
	data.append(Converter('zh-hant').convert(line))
f.close()

f = open('traditional-ntusd-positive.txt','w',encoding = 'utf-8')
f.write(''.join(data))
f.close()
