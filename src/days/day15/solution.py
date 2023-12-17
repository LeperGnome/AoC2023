from collections import defaultdict


def myhash(s: str) -> int:
    val = 0
    for c in s:
        val += ord(c)
        val *= 17
        val %= 256
    return val


boxes = defaultdict(list)


def rmlens(label: str):
    box = myhash(label)
    lenses = boxes[box]
    for lens in lenses:
        if lens[0] == label:
            lenses.remove(lens)
            break

def addlens(label: str, foc: str):
    box = myhash(label)
    lenses = boxes[box]
    found = next(iter([
        (i, lens) 
        for i, lens in enumerate(lenses) 
        if lens[0] == label
    ]), None)
    if found:
        old_idx, old_lens = found
        lenses.remove(old_lens)
        lenses.insert(old_idx, (label, foc))
    else:
        lenses.append((label, foc))


for inst in open("./input.txt", "r").read().strip().split(","):
    val = 0
    if inst[-1] == "-":
        label = inst.strip('-')
        rmlens(label)
    else:
        label, foc = inst.split('=', 1)
        addlens(label, foc)


s = 0

for boxn, lenses in boxes.items():
    for i, lens in enumerate(lenses):
        val = boxn + 1
        val *= i+1
        val *= int(lens[1])
        s += val

print(s)
