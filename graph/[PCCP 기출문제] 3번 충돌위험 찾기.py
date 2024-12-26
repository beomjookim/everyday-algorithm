# https://school.programmers.co.kr/learn/courses/30/lessons/340211

# 1 dictionary를 iterate 할 때는 dictionary 사이즈를 바꾸면 아니된다.
# 2 파이썬의 공간복잡도는 int 하나가 4byte라고 할때, 32,000,000개(128MB) ~ 512,000,000개(512MB) 가능하다

from collections import defaultdict

def solution(points, routes):    
    res = 0
    
    numbers = dict()
    for i in range(len(points)): numbers[i+1] = [points[i][0]-1, points[i][1]-1]
    
    robots = [[i, numbers[routes[i][0]][0], numbers[routes[i][0]][1], 1] for i in range(len(routes))]
    
    temp_phase = defaultdict(int)
    
    for _, x, y, _ in robots: temp_phase[(x,y)] += 1
    for key in temp_phase:
        if temp_phase[key] >= 2: res += 1
        
    while robots:
        new_robots = []
        temp_phase = defaultdict(int)
        
        for robot, cur_x, cur_y, des_ind in robots:
            if des_ind == len(routes[robot]): continue
            des_x, des_y = numbers[routes[robot][des_ind]]
            
            if cur_x > des_x: cur_x -= 1
            elif cur_x < des_x: cur_x += 1
            elif cur_y > des_y: cur_y -= 1
            else: cur_y += 1
            
            if (cur_x, cur_y) == (des_x, des_y): des_ind += 1
                
            temp_phase[(cur_x,cur_y)] += 1
            new_robots.append([robot, cur_x, cur_y, des_ind])
            
        for key in temp_phase:
            if temp_phase[key] >= 2: res += 1
        
        robots = new_robots
            
    return res
