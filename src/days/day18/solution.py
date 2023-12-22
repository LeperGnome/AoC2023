from collections import namedtuple, deque

Instruction = namedtuple("Instruction", ["dir", "n", "color"])

dirmap = {
    "R": (1, 0),
    "L": (-1, 0),
    "U": (0, -1),
    "D": (0, 1),
    "0": (1, 0),
    "2": (-1, 0),
    "3": (0, -1),
    "1": (0, 1),
}

instructions: list[Instruction] = []

for l in open("./input.txt", "r").read().splitlines(keepends=False):
    _, _, c = l.split(" ")
    c = c.strip("()#")
    d = c[-1]
    n = c[: len(c) - 1]
    instr = Instruction(dir=dirmap[d], n=int(n, 16), color=c)
    instructions.append(instr)

print(instructions)

current: tuple[int, int] = (0, 0)
tiles: set[tuple[int, int]] = set([current])

minx, miny, maxx, maxy = 0, 0, 0, 0

for instr in instructions:
    dx, dy = instr.dir
    for i in range(instr.n):
        x, y = current
        nx, ny = x + dx, y + dy
        maxx = max(maxx, nx)
        maxy = max(maxy, ny)
        minx = min(minx, nx)
        miny = min(miny, ny)
        current = (x + dx, y + dy)
        tiles.add(current)


maxarea = (maxy - miny + 3) * (maxx - minx + 3)
print(maxarea)

q = deque([(minx - 1, miny - 1)])
seen = set()

while q:
    pnt = q.popleft()
    if pnt in seen or pnt in tiles:
        continue
    seen.add(pnt)
    x, y = pnt
    for d in dirmap.values():
        dx, dy = d
        nx, ny = x + dx, y + dy
        newt = (x + dx, y + dy)
        if minx - 2 < nx < maxx + 2 and miny - 2 < ny < maxy + 2:
            q.append(newt)

for y in range(miny - 1, maxy + 2):
    for x in range(minx - 1, maxx + 2):
        if (x, y) in seen:
            print("@", end="")
        elif (x, y) in tiles:
            print("#", end="")
        else:
            print(".", end="")
    print()

print(maxarea - len(seen))
