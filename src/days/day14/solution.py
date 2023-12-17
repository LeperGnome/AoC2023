M = [
    list(line) 
    for line in open("./input.txt", "r").read().splitlines(keepends=False)
]
MT = list(list(r) for r in zip(*M))

s = 0

for row in MT:
    row.reverse()
    blen = 0
    print(*row, sep="")
    for idx, c in enumerate(row):
        pos = idx+1
        if c == "O":
            blen += 1
        if c == "#":
            b = sum(range(pos-blen, pos))
            s += b
            blen = 0

    b = sum(range(len(row)-blen+1, len(row)+1))
    s += b

print(s)
