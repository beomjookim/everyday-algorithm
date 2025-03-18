# https://school.programmers.co.kr/learn/courses/30/lessons/43162

# 처음에 모든 네트워크가 서로 다른 네트워크에 포함된다는 설정으로 훨씬 쉬워진 문제.
# set의 union과 dict의 del 등에 대한 복기.

def solution(n, comps):
    networks = dict({i:set([i]) for i in range(n)})
    computers = [i for i in range(n)]
        
    for i in range(n-1):
        for j in range(i+1, n):
            # 서로 다른 곳에 속할 경우 
            if comps[i][j] and computers[i] != computers[j]:
                temp = networks[computers[j]]
                
            # 두번째 네트워크 모두 첫번째 네트워크에 넣어줌.            
                networks[computers[i]] = networks[computers[i]].union(networks[computers[j]])
                del networks[computers[j]]
                
            # 각 컴퓨터가 어디 네트워크에 속했는지도 표시를 바꿔줘야 함.
                for k in temp: computers[k] = computers[i]
                    
    return len(networks)
