# 서로 인접해 있다는 조건만 있을 뿐, 길이도 범위도 정해지지 않았기 때문에 좀 어려웠다.
# 2D for loop 2번 돌리니까 시간초과가 남.
# 2개의 좋은 풀이를 찾았는데, 둘 다 for loop 단계 하나 줄이고 대신 컨테이너 변수 하나 늘리는 식으로.
# 변수만 늘리는 것이 아니라, for loop 하나 돌리면서 이전 범위 전체에 대한 값을 하나 가져가면서 품.
# 이게 핵심이다. for loop 대신할 수 있는 하나의 변수만 찾으면 끝나는 문제.

# 그리고 또 느낀 건데, max가 느리긴 느리지만 3개 이하의 값을 다룰 때는 별 상관없는 것 같다.

# 기존 느린 풀이
def solution(sequence):
    starts_with_plus = [val * (-1) ** bool(i%2) for i, val in enumerate(sequence)]      # [1,-1,1,-1, ...]
    starts_with_minus = [val * (-1) ** bool((i+1)%2) for i, val in enumerate(sequence)] # [-1,1,-1,1, ...]
    
    res = 0
    
    for i in range(len(sequence)):
        temp = starts_with_plus[i]
        if res < temp: res = temp
        
        for j in range(i+1, len(sequence)):
            temp += starts_with_plus[j]
            if res < temp: res = temp
    
    for i in range(len(sequence)):
        temp = starts_with_minus[i]
        if res < temp: res = temp
        
        for j in range(i+1, len(sequence)):
            temp += starts_with_minus[j]
            if res < temp: res = temp
    
    return res


# 좋은 풀이 1
def solution(sequence):
    answer = 0
    a = [0]
    b = [0]
    for i in range(len(sequence)):
        if i % 2 == 0:
            a.append(sequence[i])
            b.append((-1)*sequence[i])
        else:
            b.append(sequence[i])
            a.append((-1)*sequence[i])
    def dp(a):
        for i in range(1,len(a)):
            if a[i] + a[i-1] > a[i]:
                a[i] += a[i-1]
        return a
    
    return max(max(dp(a)),max(dp(b)))


# 좋은 풀이 2
from sys import maxsize

INF = maxsize

def solution(sequence):
    answer = -INF
    size = len(sequence)
    s1 = s2 = 0				# 1
    s1_min = s2_min = 0		# 2
    pulse = 1
    
    for i in range(size):
        s1 += sequence[i] * pulse
        s2 += sequence[i] * (-pulse)
        
        # 3
        answer = max(answer, s1-s1_min, s2-s2_min)
        
        # 4
        s1_min = min(s1_min, s1)
        s2_min = min(s2_min, s2)
        
        # 5
        pulse *= -1
    return answer
