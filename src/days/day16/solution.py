from collections import deque


M = [
    list(line) 
    for line in open("./input.txt", "r").read().splitlines(keepends=False)
]

def calc(init):
    q = deque([init])
    seen = set()
    
    while len(q):
        cur = q.popleft()
        coords, di = cur
        x, y = coords
        if (
            (x < 0 or x >= len(M[0])) or
            (y < 0 or y >= len(M))
        ):
            continue
    
        seen.add(cur)
        dx, dy = di
        cur_cell = M[y][x]
        if (
            cur_cell == '.'
            or (cur_cell == '|' and dx == 0)
            or (cur_cell == '-' and dy == 0)
        ):
            nx, ny = x + dx, y + dy
            nxt = ((nx, ny), di)
            if nxt not in seen:
                q.append(nxt)
    
        elif cur_cell == '|':
            nxt1 = ((x, y+1), (0, 1))
            nxt2 = ((x, y-1), (0, -1))
            if nxt1 not in seen:
                q.append(nxt1)
            if nxt2 not in seen:
                q.append(nxt2)
    
        elif cur_cell == '-':
            nxt1 = ((x+1, y), (1, 0))
            nxt2 = ((x-1, y), (-1, 0))
            if nxt1 not in seen:
                q.append(nxt1)
            if nxt2 not in seen:
                q.append(nxt2)
    
        elif cur_cell == '\\':
            if dx == 1 or dy == -1:
                nxt1 = ((x, y+1), (0, 1)) # from left -> down
                nxt2 = ((x-1, y), (-1, 0)) # from down -> left
                if nxt2 not in seen:
                    q.append(nxt1)
                if nxt2 not in seen:
                    q.append(nxt2)
    
            if dx == -1 or dy == 1:
                nxt1 = ((x, y-1), (0, -1)) # from right -> up
                nxt2 = ((x+1, y), (1, 0)) # from up -> right
                if nxt2 not in seen:
                    q.append(nxt1)
                if nxt2 not in seen:
                    q.append(nxt2)
    
        elif cur_cell == '/':
            if dx == 1 or dy == 1:
                nxt1 = ((x, y-1), (0, -1)) # from left -> up
                nxt2 = ((x-1, y), (-1, 0)) # from up -> left
                if nxt2 not in seen:
                    q.append(nxt1)
                if nxt2 not in seen:
                    q.append(nxt2)
    
            if dx == -1 or dy == -1:
                nxt1 = ((x, y+1), (0, 1)) # from right -> up
                nxt2 = ((x+1, y), (1, 0)) # from up -> right
                if nxt2 not in seen:
                    q.append(nxt1)
                if nxt2 not in seen:
                    q.append(nxt2)
    
    
    known_coords = set(el[0] for el in seen)

    # for ri, row in enumerate(M):
    #     for ci, el in enumerate(row):
    #         if (ci, ri) in known_coords:
    #             print("#", end='')
    #         else:
    #             print(".", end='')
    #     print()
    return len(known_coords)

init = (
    (0, 0), # x, y
    (1, 0), # current directoin
)

ans = 0

for y in range(len(M)):
    pos1 = ((0, y), (1, 0))
    pos2 = ((len(M[0])-1, y), (-1, 0))
    ans = max(ans, calc(pos1))
    ans = max(ans, calc(pos2))

for x in range(len(M)):
    pos1 = ((x, 0), (0, 1))
    pos2 = ((x, len(M)-1), (0, -1))
    ans = max(ans, calc(pos1))
    ans = max(ans, calc(pos2))

print(ans)
