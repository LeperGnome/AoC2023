inp = open("./input.txt", "r").read()

M = list[list[str]]

maps: list[tuple[M, M]] = []
buf: M = []

for line in inp.splitlines(keepends=False):
    if line == "":
        buf_t = [list(row) for row in zip(*buf)]
        maps.append((buf.copy(), buf_t.copy()))
        buf.clear()
        continue

    buf.append(list(line))

buf_t = [list(row) for row in zip(*buf)]
maps.append((buf, buf_t))


def sym(m: M) -> int | None:
    for idx in range(0, len(m)-1):
        li = idx
        ri = idx + 1
        while (
            li >= 0 and
            ri < len(m)
        ):
            if m[li] != m[ri]:
                break
            li -= 1
            ri += 1
        else:
            return idx + 1
    return None

def sym2(m: M, old) -> int | None:
    for idx in range(0, len(m)-1):
        li = idx
        ri = idx + 1
        fs = False
        while (
            li >= 0 and
            ri < len(m)
        ):
            diff = sum(m[ri][i] != m[li][i] for i in range(len(m[li])))
            if diff > 1:
                break
            if diff == 1 and fs:
                break
            if diff == 1:
                fs = True

            li -= 1
            ri += 1
        else:
            if idx + 1 == old:
                pass
            else:
                return idx + 1
    return None

s = 0

def get_ax(m, mt) -> int:
    ax = sym(m)
    _ax = sym2(m, ax)
    if _ax is not None:
        return 100 * _ax
    else:
        ax = sym(mt)
        _ax = sym2(mt, ax)
        if _ax is None:
            raise RuntimeError("no sym found")
    return _ax

for m, mt in maps:
    s += get_ax(m, mt)


print(s)
