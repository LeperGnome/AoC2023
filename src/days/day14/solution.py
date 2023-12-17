M = [
    list(line) 
    for line in open("./input.txt", "r").read().splitlines(keepends=False)
]
M = list(list(el) for el in zip(*M[::-1]))

def tilt():
    for ri, row in enumerate(M):
        blen = 0
        last_rock = -1
        new_r = []
        for idx, c in enumerate(row):
            if c == "O":
                blen += 1
            if c == "#":
                new_r += ["."]*(idx-(last_rock+1)-blen)
                new_r += ["O"]*blen
                new_r.append("#")
                blen = 0
                last_rock = idx

        new_r += ["."]*(len(M[0])-(last_rock+1)-blen)
        new_r += ["O"]*blen
        M[ri] = new_r

def calculate_load() -> int:
    s = 0
    for row in M:
        for idx, c in enumerate(row):
            pos = idx+1
            if c == "O":
                s += pos
    return s


def printm():
    mc = list(list(el) for el in zip(*[r[::-1] for r in M]))
    for row in mc:
        for el in row:
            print(el, end="")
        print()
    print()

print("Init:")
printm()

known = set()
log = []
result = 0

needed = 1000000000
for idx in range(needed):
    for i in range(4):
        tilt()
        M = list(list(el) for el in zip(*M[::-1]))

    snapshot = (calculate_load(), repr(M))
    if snapshot in known:
        print("pattern at", idx)
        pattern_beg = log.index(snapshot)
        pattern = log[pattern_beg:]
        rest = needed - idx - 1
        result = pattern[rest % len(pattern)][0]
        break

    log.append(snapshot)
    known.add(snapshot)
    print(f"{idx+1} cycle complete")

print([l[0] for l in log])
print(result)
