from collections import deque

inp = open("./input.txt", "r").read()

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

corr_pipes_for_step = {
    (1, 0): {"-", "7", "J"},
    (-1, 0): {"-", "F", "L"},
    (0, 1): {"|", "L", "J"},
    (0, -1): {"|", "F", "7"},
}

pipe_to_steps = {
    "-": {(1, 0), (-1, 0)},
    "|": {(0, 1), (0, -1)},
    "7": {(-1, 0), (0, 1)},
    "J": {(-1, 0), (0, -1)},
    "F": {(1, 0), (0, 1)},
    "L": {(1, 0), (0, -1)},
    "S": {(0, -1), (0, 1), (-1, 0), (1, 0)},
}

M = []

start = (0,0)

for y, row in enumerate(inp.splitlines(keepends=False)):
    l = []
    for x, el in enumerate(row):
        if el == "S":
            start = (x, y)
        l.append(el)
    M.append(l)


q = deque()
q.append((0, start))
seen = {}


while len(q):
    i, pos = q.popleft()
    # print(f"#{i} now at: {M[pos[1]][pos[0]]} {pos}")
    if pos in seen:
        # print(f"#{i} met at {pos} {seen[pos]}")
        break
    seen[pos] = i
    x, y = pos
    cur_pipe = M[y][x]
    corr_steps = set()
    for step in pipe_to_steps[cur_pipe]:
        new_pos = (x+step[0], y+step[1])
        if M[new_pos[1]][new_pos[0]] in corr_pipes_for_step[step]:
            corr_steps.add(step)
            if new_pos not in seen or seen[new_pos] != i - 1:
                q.append((i+1, new_pos))
    if cur_pipe == "S":
        M[y][x] = [k for k, v in pipe_to_steps.items() if v == corr_steps][0]


loop_cells = set(seen.keys())
on_pipe = False
cnt = 0

ucomp = {"L": "J", "F": "7"}

for ri, row in enumerate(M):
    prev_u = None
    inside = False
    for ci, el in enumerate(row):
        cur_pos = (ci, ri)
        if prev_u is not None:
            if el == "-":
                print(bcolors.WARNING + el + bcolors.ENDC, end="")
                continue
            if ucomp.get(prev_u) != el:
                print(bcolors.WARNING + el + bcolors.ENDC, end="")
                inside = not inside
                prev_u = None
                continue
            else:
                print(bcolors.WARNING + el + bcolors.ENDC, end="")
                prev_u = None
                continue


        if cur_pos in loop_cells:
            print(bcolors.WARNING + el + bcolors.ENDC, end="")
            if el == "|":
                inside = not inside
            else:
                prev_u = el
        elif inside:
            cnt += 1
            print(bcolors.OKGREEN + 'I' + bcolors.ENDC, end="")
        else:
            print(el, end="")
    print()

print(cnt)
