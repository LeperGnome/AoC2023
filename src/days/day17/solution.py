import heapq
from enum import Enum
from collections import namedtuple


M = [list(l) for l in open("./input.txt", "r").read().splitlines(keepends=False)]

end = (len(M[0]) - 1, len(M) - 1)


class Dir(Enum):
    UP = (0, -1)
    DOWN = (0, 1)
    LEFT = (-1, 0)
    RIGHT = (1, 0)

    def __lt__(self, other) -> bool:
        return self.value < other.value


opposite = {
    Dir.LEFT: Dir.RIGHT,
    Dir.RIGHT: Dir.LEFT,
    Dir.UP: Dir.DOWN,
    Dir.DOWN: Dir.UP,
}


TileState = namedtuple("TileState", ["acc", "d", "x", "y", "n"])


init = TileState(0, Dir.RIGHT, 0, 0, 0)
q = [(init, [])]

dists = {}

optimal = float("inf")
opt_log = None

pre_turn = 4
max_straight = 10

while len(q):
    tile, log = heapq.heappop(q)

    if (tile.x, tile.y) == end and tile.n >= pre_turn:
        if tile.acc < optimal:
            optimal = tile.acc
            opt_log = log
            continue

    if tile.acc >= optimal:
        continue

    if dists.get((tile.x, tile.y, tile.n, tile.d), float("inf")) <= tile.acc:
        continue

    dists[(tile.x, tile.y, tile.n, tile.d)] = tile.acc

    for new_d in Dir:
        dx, dy = new_d.value
        nx, ny = tile.x + dx, tile.y + dy
        if nx < 0 or nx >= len(M[0]) or ny < 0 or ny >= len(M):
            continue
        new_acc = tile.acc + int(M[ny][nx])

        if new_d == tile.d:
            if tile.n < max_straight:
                new_t = TileState(new_acc, new_d, nx, ny, tile.n + 1)
                heapq.heappush(
                    q,
                    (
                        new_t,
                        log + [(nx, ny)],
                    ),
                )
        elif (
            new_d != Dir.DOWN
            and tile.d == Dir.UP
            or new_d != Dir.UP
            and tile.d == Dir.DOWN
            or new_d != Dir.RIGHT
            and tile.d == Dir.LEFT
            or new_d != Dir.LEFT
            and tile.d == Dir.RIGHT
        ) and tile.n >= pre_turn:
            new_t = TileState(new_acc, new_d, nx, ny, 1)
            heapq.heappush(
                q,
                (
                    new_t,
                    log + [(nx, ny)],
                ),
            )

print(optimal)


l = set(opt_log) if opt_log is not None else set()

for ri, row in enumerate(M):
    for ci, el in enumerate(row):
        if (ci, ri) in l:
            print("#", end="")
        else:
            print(".", end="")
    print()
