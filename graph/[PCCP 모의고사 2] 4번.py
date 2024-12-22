# https://school.programmers.co.kr/learn/courses/15009/lessons/121690

# 재밌는 문제.

# 발상 1: 일차로 모든 배열을 돌면서, 각각의 덩어리에 해당하는 원소들을 모두 찾아 이름붙여서 해당 엘리먼트에 저장해둔다. 
# 뿐만 아니라 배열에 값들을 저장해둔다.
# 이후 각 시추점에서 아래로 내려가면서 걸리는 값들을 전부 더해준다.

# !!!!!!!!!!!!!!!!=
# 아래의 코드는 효율성 테스트에서 하나도 통과를 못함. 
# DFS 문제에서 흔히 등장하는 유형이다.... 잘 숙지해서 다시 이런 유형 안 틀리게 하자.

```
def solution(land):
    dungs = {}
    ind = 2
    
    def traverse(x, y, ind, land):
        dirs = [[0,1],[0,-1],[1,0],[-1,0]]
        size = 1
        land[x][y] = ind
        
        for di_x, di_y in dirs:
            n_x, n_y = x+di_x, y+di_y
            if 0 <= n_x < len(land) and 0 <= n_y < len(land[0]):
                if land[n_x][n_y] == 1:
                    size += traverse(n_x, n_y, ind, land)
        
        return size
    
    for i in range(len(land)):
        for j in range(len(land[0])):
            if land[i][j] == 1:
                # 해당 덩어리 모두 돌고 넘버링 함 (넘버링은 2부터 시작)
                # 다 끝나면 크기값을 dungs에 저장함
                dungs[ind] = traverse(i, j, ind, land)
                ind += 1
    
    res = 0
    
    for i in zip(*land):
        temp = 0
        for j in set(i): 
            if j: temp += dungs[j]
        if res < temp: res = temp
    
    return res
  ```

# 역시 문제는 이 로직의 가장 핵심인 traverse 함수에 있었다. 
# 기존에는 dfs 함수를 구현해서 재귀로 구현했었는데, 이 부분만 반복 dfs로 교체해주니 효율성을 전부 통과했다.

```
    def traverse(x, y, ind):
        stack = [(x, y)]
        size = 0
        while stack:
            cx, cy = stack.pop()
            if land[cx][cy] == 1:  # 석유 덩어리를 찾으면
                size += 1
                land[cx][cy] = ind  # 방문 처리 및 ID 할당
                for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
                    nx, ny = cx + dx, cy + dy
                    if 0 <= nx < len(land) and 0 <= ny < len(land[0]) and land[nx][ny] == 1:
                        stack.append((nx, ny))
        return size
```

# 두 개의 시간복잡도는 아무리 봐도 같다. 미세하게 작동 시에 차이가 있겠지만, 적나라하게 시간효율이 달라진 점은 없다.
# 그러나 재귀의 경우는 recursion limit이 1000으로 제한되어있는 반면, BFS는 리스트를 쓰므로 그렇지 않다.
# 결과적으로, DFS를 구현할 때에도 재귀보다 반복문을 쓰는 편이 훨씬 낫다는 결론이다.
# 앞으로는 DFS는 무조건 반복으로 구현한다.
