t="""41 48 83 86 17 | 83 86  6 31 17  9 48 53
13 32 20 16 61 | 61 30 68 82 17 32 24 19
 1 21 53 59 44 | 69 82 63 72 16 21 14  1
41 92 73 84 69 | 59 84 76 51 58  5 54 83
87 83 26 28 32 | 88 30 70 12 93 22 82 36
31 18 13 56 72 | 74 77 10 23 35 67 36 11"""

with open("./input.txt", "r") as f:
    inp = f.read()

cs = {}
init: list[int] = []

for n, l in enumerate(inp.splitlines()):
    l, r = l.split(" | ", 1)
    nl = set(int(el.strip()) for el in  l.split(' ') if el)
    nr = set(int(el.strip()) for el in  r.split(' ') if el)
    cs[n] = (nl, nr)
    init.append(n)

total = len(init)
q = init

for n in q:
    l, r = cs[n]
    w = len(l & r)
    total += w
    q += [n+i+1 for i in range(w)]

print(total)
