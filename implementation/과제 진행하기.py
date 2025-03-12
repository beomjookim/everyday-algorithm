# 말그대로 단순 구현 문제.
# 구현의 어떤 포인트를 어떻게 설정을 하고 푸느냐가 매우 중요함.
# 다행히 받자마자 stack에 집어넣는 판단을 함으로써 풀이가 매우 단순화 됨.

# python으로 정렬하는 테크닉도 더 파보자.

def solution(plans):
    
    def hr_to_min(st):
        hr, mn = st.split(':')
        return int(hr)*60+int(mn)
    
    stack = []  # [time_left, name]
    res = []
    
    plans.sort(key = lambda x: x[1])
    
    print(plans)
    
    for i in range(len(plans)-1):
        stack.append([int(plans[i][2]), plans[i][0]])
        time = hr_to_min(plans[i+1][1]) - hr_to_min(plans[i][1])
        
        while time and stack:
            if time >= stack[-1][0]:
                plan_time, name = stack.pop()
                res.append(name)
                time -= plan_time
            else: 
                stack[-1][0] -= time
                time = 0
    
    return res + [plans[-1][0]] + [stack[i][1] for i in range(len(stack)-1, -1, -1)]
