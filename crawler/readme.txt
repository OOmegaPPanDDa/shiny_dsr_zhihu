各種套件請自行安裝
node js
python3.5
https://github.com/shanelau/zhihu
https://github.com/7sDream/zhihu-py3/blob/master/zhihu/answer.py
https://github.com/7sDream/zhihu-oauth


中文繁簡轉換功能 安裝
	> https://github.com/skydark/nstools/blob/master/zhtools/zh_wiki.py
	> https://github.com/skydark/nstools/blob/master/zhtools/langconv.py
	> 於上述網址下載 zh_wiki.py 和 langconv.py
	> 將 zh_wiki.py 和 langconv.py 放置於當前目錄或 python 路徑 (site-packages)



Terminal

Hot Based (根據熱門程度取資料)
	確認當前目錄至少有 zhihu_oauth_best_answer.py
	>	python zhihu_oauth_best_answer.py <話題 id> <問題數>
	>	第一次會要求輸入知乎帳密，除非妳已經有了別人的 token.pkl
	>	(可以的話不要拿別人的 token.pkl QQ)
	>	最後檔案輸出名為 zhihu_answer.csv，建議跑完後修改名字以免之後重跑程式時被蓋掉
	>	如果 Windows 有遇到 UnicodeEncodeError
		>	先切換 cmd 編碼：chcp 65001
		>	再跑：python zhihu_oauth_answer.py

Time Based (根據時間取資料)

	確認當前目錄至少有 zhihu_topic_Q.js zhihu_topic_Q.sh (zhihu_topic_Q.bat) zhihu_oauth_answer.py

	檢視一下所選的話題有多少問題：
	>	node view_topic_test.js <話題id>
	>	查看 totalpage 值，一個 page 有 20 個 questions

	取得話題下問題的 url：
	>	MAC/linux >> sh zhihu_topic_Q.sh <話題id> <page數> > zhihu_topic_Q.txt
	>	Windows >> zhihu_topic_Q.bat <話題id> <page數> > zhihu_topic_Q.txt
	>	取出來的 url 有按時間排列，由最近至較久以前的

	取得 answers 相關資料：

	>	python zhihu_oauth_answer.py
	>	第一次會要求輸入知乎帳密，除非妳已經有了別人的 token.pkl
	>	(可以的話不要拿別人的 token.pkl QQ)
	>	最後檔案輸出名為 zhihu_answer.csv，建議跑完後修改名字以免之後重跑程式時被蓋掉
	>	如果 Windows 有遇到 UnicodeEncodeError
		>	先切換 cmd 編碼：chcp 65001
		>	再跑：python zhihu_oauth_answer.py

Windows 讀檔問題：
Windows 不知為何編碼問題很多
拿到 zhihu_answer.csv 後用 excel 開會是亂碼 ...
用 read.csv 讀檔也是一堆錯誤 ...
以下是我個人的解決流程
(0)	用 Rstudio 的 import dataset 試試看，輸出成功後再 as.data.fram 轉成 dataframe

(1) 用 Sublime 開啟 zhihu_answer.csv
(2) Save with encoding utf-8 with BOM, 關閉檔案
(3) 用 Excel 開 zhihu_answer.csv (此時看到的內容應該不是中文亂碼了)
(4) 另存新檔成 answer.csv (不要跟 zhihu_answer.csv 同檔名)
(5) 用 sublime 開啟 answer.csv
(6) Save with encoding utf-8
(7) zhihu <- read.csv('answer.csv', fileEncoding = 'utf-8')
(8) zhihu <- zhihu[seq(from=2,to=nrow(zhihu), by=2),]

answer.csv 將會是一個 ecxel 和 read.csv 都沒有問題的檔案

如果還是不行...

(9-1)	把不是亂碼的 csv 檔中所有的東西剪下
(9-2)	貼到 word 上， 記得選擇只保留文字
(9-3)	再把它們從 word 上剪下
(9-4)	Sublime 開另一個新檔貼上
(9-5)	存檔成 answer.csv，記得要 Save with encoding utf-8
(9-6)	zhihu <- read.csv('answer.csv', fileEncoding = 'utf-8')
(9-7)	zhihu <- zhihu[seq(from=2,to=nrow(zhihu), by=2),]

如果還是悲劇...那我也無解了，看你要不要轉戰 VM 用 Linux 系統 QQ

