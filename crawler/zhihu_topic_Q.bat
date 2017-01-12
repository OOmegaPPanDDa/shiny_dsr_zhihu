@echo on
for /l %%w in (1, 1, %2) do node zhihu_topic_Q.js %1 %%w