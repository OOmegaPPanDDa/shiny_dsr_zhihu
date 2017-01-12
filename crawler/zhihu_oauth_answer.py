# -*- coding: utf-8 -*-
"""
Created on Fri Dec 23 04:42:26 2016

@author: HSIN
"""

from __future__ import unicode_literals, print_function

import os

from zhihu_oauth import ZhihuClient
from langconv import *

import csv
from time import time

t0 = time()

TOKEN_FILE = 'token.pkl'


client = ZhihuClient()

if os.path.isfile(TOKEN_FILE):
    client.load_token(TOKEN_FILE)
else:
    client.login_in_terminal()
    client.save_token(TOKEN_FILE)
    
    

question_url_list = []
f = open('zhihu_topic_Q.txt','r',encoding='utf-8')
for line in f:
    if line[:4]=='http':
        print(line)
        question_url_list.append(line.replace('\n',''))
f.close()

question_url_list = list(set(question_url_list))


dataCollect = [['question_title','question_detail','question_time','question_follower_num',
                'ans','ans_time','ans_upvote_num','ans_collect_num','ans_comment_num',
                'author_follower_num','author_followee_num','author_upvote_num','author_thank_num',
                'author_answer_num','author_question_num','author_post_num',
                'author_name','author_gender','author_business','author_education'
                ]]
                
                
                

for i, url in enumerate(question_url_list):
    
    question = client.question(int(url.replace('https://www.zhihu.com/question/','')))
    print(i+1)
    print(question.title)
    print(url)
    print("%0.3fs." % (time() - t0))
    print('\n')
    
    for ans in question.answers:
        data = []
        
        try:
            data.append(Converter('zh-hant').convert(question.title))
        except:
            data.append(None)

        try:
            data.append(Converter('zh-hant').convert(question.detail))
        except:
            data.append(None)

        try:
            data.append(question.created_time)
        except:
            data.append(None)

        try:
            data.append(question.follower_count)
        except:
            data.append(None)
        
        try:
            data.append(Converter('zh-hant').convert(ans.content))
        except:
            data.append(None)

        try:
            data.append(ans.created_time)
        except:
            data.append(None)

        try:
            data.append(ans.voteup_count)
        except:
            data.append(None)

        try:
            data.append(len(list(ans.collections)))
        except:
            data.append(None)

        try:
            data.append(ans.comment_count)
        except:
            data.append(None)
        
        try:
            data.append(ans.author.follower_count)
        except:
            data.append(None)

        try:
            data.append(ans.author.following_count)
        except:
            data.append(None)

        try:
            data.append(ans.author.voteup_count)
        except:
            data.append(None)

        try:
            data.append(ans.author.thanked_count)
        except:
            data.append(None)

        try:
            data.append(ans.author.answer_count)
        except:
            data.append(None)

        try:
            data.append(ans.author.question_count)
        except:
            data.append(None)

        try:
            data.append(ans.author.articles_count)
        except:
            data.append(None)
            
        try:
            data.append(Converter('zh-hant').convert(ans.author.name))
        except:
            data.append(None)

        try:
            data.append(Converter('zh-hant').convert(ans.author.gender))
        except:
            data.append(None)

        try:
            data.append(Converter('zh-hant').convert(ans.author.business.name))
        except:
            data.append(None)
            
        try:
            data.append(Converter('zh-hant').convert(ans.author.education.major.name))
        except:
            data.append(None)
        
        
        dataCollect.append(data)
        
        
f = open("zhihu_answer.csv","w",encoding="utf-8")  
w = csv.writer(f)  
w.writerows(dataCollect)
f.close()
