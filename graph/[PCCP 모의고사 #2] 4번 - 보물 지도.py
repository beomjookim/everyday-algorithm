# https://school.programmers.co.kr/learn/courses/15009/lessons/121690

# 한 시간 넘어가서 진짜 포기할 뻔 했다... ㅋㅋㅋㅋ 그치만 결국 이겼쥬?

# x, y 축 및 미세 인덱싱 바꿔줘야 하고
# 점프를 하는 여부에 대한 정보를 포함해서 경로를 짜줘야 한다.
# 이것도 어찌보면 BFS를 활용한 단순 구현 문제라고 생각할 수도 있을 것 같다.

from collections import deque

def solution(n, m, hole):    
    res = float('inf')

    stat_table = [[[float('inf'), float('inf')] for _ in range(n)] for _ in range(m)]   # jump o, x
    
    for hx, hy in hole: stat_table[m-hy][hx-1] = [-1,-1]
            
    queue = deque([(m-1, 0, 0, True)])       # x, y, 해당 점까지의 최단거리, 점프여부
    stat_table[m-1][0][0] = 0
    
    while queue:
        x, y, cur_dis, jump = queue.popleft()
        
        for dx, dy in [[-1,0], [1,0], [0,-1], [0,1]]:
            nx, ny = x+dx, y+dy
            
            if 0 <= nx < m and 0 <= ny < n:
                if nx == 0 and ny == n-1:
                    if jump: res = min(res, cur_dis)
                    else: res = min(res, cur_dis+1)
                else:
                    if stat_table[nx][ny][0] != -1:
                        if jump:
                            if stat_table[nx][ny][0] > cur_dis+1:
                                stat_table[nx][ny][0] = cur_dis+1
                                queue.append([nx,ny,cur_dis+1,jump])
                        elif not jump:
                            if stat_table[nx][ny][1] > cur_dis+1:
                                stat_table[nx][ny][1] = cur_dis+1
                                queue.append([nx,ny,cur_dis+1,jump])
                    elif jump:
                        nx += dx
                        ny += dy
                        if 0 <= nx < m and 0 <= ny < n and stat_table[nx][ny][1] > cur_dis+1:
                            stat_table[nx][ny][1] = cur_dis+1
                            queue.append([nx,ny,cur_dis+1,False])
    
    return res if res != float('inf') else -1
