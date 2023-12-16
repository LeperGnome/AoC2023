import functools

inp = open("./input.txt", "r").read()

pattern_lines: list[tuple[str, list[int]]] = []

for line in inp.splitlines(keepends=False):
    pattern, nums = line.split(" ", 1)
    nums = [int(n) for n in nums.split(",")]
    pattern_lines.append(("?".join([pattern]*5), nums*5))


s = 0
for pattern, blocks in pattern_lines:
    @functools.cache
    def arrange_count(nchars: int, nblocks:int) -> int:
        if nchars == 0:
            return int(nblocks == 0)
        count = 0
        if pattern[nchars-1] != "#":
            count += arrange_count(nchars-1, nblocks)
        if nblocks > 0:
            len_ = blocks[nblocks-1]
            if fit_block_at(nchars - len_, len_):
                gap = 0 if nchars == len_ else 1 
                count += arrange_count(nchars-len_-gap, nblocks-1)
        return count

    def fit_block_at(start: int, len_: int) -> bool:
        if start < 0:
            return False
        if start+len_ > len(pattern):
            return False
        return (
            all(el != '.' for el in pattern[start: start+len_]) and
            (start == 0 or pattern[start-1] != "#")
        )
    cnt = arrange_count(len(pattern), len(blocks))
    s += cnt
    print(cnt)

print(s)
        

