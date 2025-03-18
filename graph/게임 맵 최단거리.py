# 일반적인 BFS 문제인데... 효율성에서 결렸다.
# 겨우 한 줄 때문에...
# 어지간하면 로직에 영향 없는 내에서, queue에 넣기 전에 할 수 있는 거 다 해주고 나서 queue 돌리는 게,
# 특히나 visited 같이 queue의 절대 크기 자체를 좌지우지할 수 있는 경우 매우 중요함.


# BFS
from collections import deque

def solution(maps):
    # 큐
    queue = deque([[0, 0, 1]]) # (x, y, 누적값)
    m = len(maps)
    n = len(maps[0])
    visited = set({(0, 0)})
    
    while queue:
        x, y, acc = queue.popleft()
        
        for dx, dy in [[-1,0], [0,-1], [0,1], [1, 0]]:
            tx, ty = x+dx, y+dy
            
            if 0 <= tx < m and 0 <= ty < n and maps[tx][ty] and (tx, ty) not in visited:
                if tx == m-1 and ty == n-1: return acc+1
                visited.add((tx,ty))

                queue.append([tx, ty, acc+1])

    return -1
