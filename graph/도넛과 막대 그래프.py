# https://school.programmers.co.kr/learn/courses/30/lessons/258711

# 좀 오래 걸렸지만 어렵지 않았던 문제.
# 최고의 풀이보다는 빨리 구현할 수 있는 풀이도 시도할 깜냥을 늘려야겠다.

def solution(edges):
    number = dict()
    
    main_node = -1
    total_graphs = -1
    pointed = []
    
    for i, o in edges:
        if i not in number: number[i] = [[],[]]
        if o not in number: number[o] = [[],[]]

        if number[o][0]: number[o][0].append(i)
        else: number[o][0] = [i]

        if number[i][1]: number[i][1].append(o)
        else: number[i][1] = [o]
        
    for node in number:
        ins, outs = number[node]
        if not ins and len(outs) > 1:
            main_node = node  # 주인공 노드 발견
            total_graphs = len(outs)    # 전체 그래프 개수 확인
            pointed = outs
            for point in outs: number[point][0].remove(node)
            del number[node]
            break
            
    ilja = 0
    palja = 0
            
    for node in number:
        ins, outs = number[node]
        if not outs: ilja += 1
        elif len(ins) == 2 and len(outs) == 2: palja += 1
    
    return [main_node, total_graphs-ilja-palja, ilja, palja]
