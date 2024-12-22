# https://school.programmers.co.kr/learn/courses/15009/lessons/121687
# 많은 사람들이 mod를 사용해서 풀었다는데, 그럴 필요까지는 없어보인다. 오히려 공간복잡도 관점으로 봤을 때 이 풀이가 나음.

def solution(command):
    x, y = 0, 0
    dir_x, dir_y = 0, 1
    
    for com in command:
        if com == 'G': x, y = x+dir_x, y+dir_y
        elif com == 'B': x, y = x-dir_x, y-dir_y
        elif com == 'R': dir_x, dir_y = dir_y, -dir_x
        else: dir_x, dir_y = -dir_y, dir_x        
    
    return [x, y]
