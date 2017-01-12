# -*- coding: utf-8 -*-
"""
Created on Fri Dec 23 04:42:26 2016

@author: HSIN
"""

from __future__ import unicode_literals, print_function

import os
import sys

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


qid_Collect = []
for i in client.topic(int(sys.argv[1])).best_answers:
    qid_Collect.append(i.question.id)

qid_Collect = list(set(qid_Collect))
qid_Collect = qid_Collect[:int(sys.argv[2])]
print(len(qid_Collect))

dataCollect = [['question_title','question_detail','question_time','question_follower_num',
                'ans','ans_time','ans_upvote_num','ans_collect_num','ans_comment_num',
                'author_follower_num','author_followee_num','author_upvote_num','author_thank_num',
                'author_answer_num','author_question_num','author_post_num',
                'author_name'
                #'author_gender','author_business','author_education'
                ]]
                
for i, qid in enumerate(qid_Collect):
    
    question = client.question(qid)
    print(i+1)
    print(Converter('zh-hant').convert(question.title))
    print('https://www.zhihu.com/question/' + str(qid))
    print("%0.3fs." % (time() - t0))
    print('\n')
    
    counter = 0
    for ans in question.answers:

        counter = counter + 1
        if counter > 500:
            break
            
        print(qid, ans.id, counter)


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

        """
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
        """
        
        
        dataCollect.append(data)
        
        
f = open("zhihu_answer.csv","w",encoding="utf-8")  
w = csv.writer(f)  
w.writerows(dataCollect)
f.close()
