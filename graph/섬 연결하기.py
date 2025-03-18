# 많은 사람들이 kruskal로 알고 있는데, 그들이 푼 방식은 prim 알고리즘이다.
# 그냥 prim을 쓰게 되면 헷갈리고, 역시나 이것도 최소 힙(우선순위 큐)을 써서 풀면 되는 문제였다.

import heapq

def solution(n, costs):
    answer = 0
    costs.sort(key=lambda x:x[2])  # 비용 기준 정렬
    
    # 초기 연결된 노드
    connect = set([costs[0][0]])  
    
    # 우선순위 큐 초기화
    heap = []
    
    # 초기 노드와 연결된 간선 삽입
    for cost in costs:
        if cost[0] in connect or cost[1] in connect:
            heapq.heappush(heap, (cost[2], cost[0], cost[1]))

    while len(connect) < n:
        weight, u, v = heapq.heappop(heap)  # 최소 비용 간선 선택
        
        if u in connect and v in connect: continue  # 이미 연결된 노드라면 무시

        # 새로운 노드를 MST에 추가
        connect.update([u, v])
        answer += weight
        
        # 새로 연결된 노드의 간선들을 힙에 추가
        for cost in costs:
            if cost[0] in connect and cost[1] in connect: continue  # 이미 연결된 노드는 무시
            if cost[0] in connect or cost[1] in connect: heapq.heappush(heap, (cost[2], cost[0], cost[1]))
    
    return answer
