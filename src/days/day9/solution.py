from itertools import pairwise


inp = open("./input.txt", "r").read()

def get_prediction(seq: list[int]) -> int:
    if all(el == 0 for el in seq):
        return 0

    diffs = [b - a for a, b in pairwise(seq)]
    return get_prediction(diffs) + diffs[-1]

s = 0

for line in inp.splitlines(keepends=False):
    seq = [int(x) for x in line.split(" ")]
    seq.reverse() # part 2
    s += get_prediction(seq) + seq[-1]

print("Result:", s)
