# https://school.programmers.co.kr/learn/courses/30/lessons/340213

# 어려울 바 없었던 단순 구현 문제.

def solution(video_len, pos, op_start, op_end, commands):
    
    def trim(val):
        mn, sc = val.split(':')
        return int(mn)*60 + int(sc)
    
    video_len = trim(video_len)
    pos = trim(pos)
    op_start = trim(op_start)
    op_end = trim(op_end)
    
    if op_start <= pos < op_end: pos = op_end
    
    for com in commands:
        if com == 'prev': pos = max(pos-10, 0)
        elif com == 'next': pos = min(pos+10, video_len)
        
        if op_start <= pos < op_end: pos = op_end
            
    return str(pos//60).zfill(2) + ':' + str(pos%60).zfill(2)
