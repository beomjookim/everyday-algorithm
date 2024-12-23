# https://school.programmers.co.kr/learn/courses/30/lessons/340212

# 이분탐색인 것만 알아채면 구현은 어렵지 않은 문제

def solution(diffs, times, limit):
    
    def valid_time(level):
        time = 0

        for i in range(len(diffs)):
            if diffs[i] > level:
                if i: time += (diffs[i]-level) * times[i-1]
                time += (diffs[i]-level) * times[i]
            time += times[i]
    
        return time <= limit
    
    i, j = 1, 100000
    
    while i < j:
        mid = (i+j)//2
        if valid_time(mid): j = mid
        else: i = mid+1
    
    return i
