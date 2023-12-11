from itertools import combinations

inp = open("./input.txt", "r").read()

M = []

C = 1000000

init_coords = []

for ri, row in enumerate(inp.splitlines(keepends=False)):
    for ci, el in enumerate(row):
        if el == "#":
            init_coords.append((ri,ci))

for line in inp.splitlines(keepends=False):
    if all(c == "." for c in line):
        M.append(list(line))
    M.append(list(line))


for ci in range(len(M[0])-1, -1, -1):
    empty = True
    for ri in range(len(M)):
        empty *= M[ri][ci] != "#"
    if not empty:
        continue
    for ri in range(len(M)):
        M[ri].insert(ci, ".")

print(*M, sep="\n")    
    
gc = []

for ri, row in enumerate(M):
    for ci, el in enumerate(row):
        if el == "#":
            gc.append((ri,ci))


bigc = []

for i in range(len(gc)):
    big = (
        init_coords[i][0] + (C-1)*(gc[i][0]-init_coords[i][0]),
        init_coords[i][1] + (C-1)*(gc[i][1]-init_coords[i][1]),
    )
    # print(f"init: {init_coords[i]}, grown: {gc[i]}, big: {big}")
    bigc.append(big)

print(bigc)

s = 0
for a,b in combinations(bigc, 2):
    s += abs(a[0] - b[0]) + abs(a[1] - b[1])
print(s) 
