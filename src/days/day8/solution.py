from itertools import cycle
import math

class Node:
    l: "Node"
    r: "Node"
    def __init__(self, val: str, l_val, r_val):
        self.val = val
        self.l_val = l_val
        self.r_val = r_val

    def __repr__(self) -> str:
        return f"[Node] {self.val} = ({self.l.val}, {self.r.val})"

with open("./input.txt", "r") as f:
    instr = f.readline().strip()
    print(instr)
    f.readline()
    inp = f.readlines()

nodes = []

for line in inp:
    line = line.strip()
    v, lr = line.split(' = ', 1)
    lr = lr[1:len(lr)-1]
    l, r = lr.split(', ', 1)
    node = Node(v, l ,r)
    nodes.append(node)

for node in nodes:
    node.l = [n for n in nodes if n.val == node.l_val][0]
    node.r = [n for n in nodes if n.val == node.r_val][0]


cur_nodes = [node for node in nodes if node.val[2] == 'A']
start_vals = [node.val for node in cur_nodes]
seen: list[list[tuple[str, int]]] = [[(v, 0)] for v in start_vals]
cycle_lens = [0]*len(start_vals)

print(cur_nodes)
print(start_vals)

for instr_idx, di in enumerate(cycle(instr)):
    instr_idx = instr_idx % len(instr)
    new = []
    for ghost_n, cur_node in enumerate(cur_nodes):
        if di == "R":
            next_node = cur_node.r
        else:
            next_node = cur_node.l

        try:
            if cycle_lens[ghost_n] == 0:
                n_before = seen[ghost_n].index((next_node.val, instr_idx))
                cycle_lens[ghost_n] = len(seen[ghost_n]) - n_before
        except ValueError:
            seen[ghost_n].append((next_node.val, instr_idx))

        new.append(next_node)

    cur_nodes = new

    if all(l != 0 for l in cycle_lens):
        break

print("Took:", math.lcm(*cycle_lens))

