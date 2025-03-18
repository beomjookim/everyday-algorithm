# BFS. 연결을 딕셔너리로 만들고. 계속 더해가기.
# visited 필수!

from collections import defaultdict, deque

def solution(n, edges):
    adj = defaultdict(list)
    res = defaultdict(int)
    
    for a, b in edges:
        adj[a].append(b)
        adj[b].append(a)
    
    queue = deque([[1, 0]])   # node 이름, 떨어진 거리
    visited = set({1})
    res[0] = 1
    
    while queue:
        name, dist = queue.popleft()
        
        for node in adj[name]:
            if node not in visited:
                queue.append([node, dist+1])
                visited.add(node)
                res[dist+1] += 1
    
    return res[max(res)]
