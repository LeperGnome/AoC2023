from dataclasses import dataclass
from collections import Counter

@dataclass
class Hand:
    cards: list[int]
    bid: int
    tp: int

chs = ["A", 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']
chs.reverse()
hands = []

def calc_tp(cards: str) -> int:
    cnt = Counter(cards)
    
    jcnt = cnt.pop('J') if 'J' in cnt else 0
    if jcnt == 5:
        return 7

    maxnums = [x[1] for x in cnt.most_common(2)]
    maxnums[0] += jcnt

    if maxnums[0] == 5:
        return 7
    if maxnums[0] == 4:
        return 6
    if maxnums[0] == 3 and maxnums[1] == 2:
        return 5
    if maxnums[0] == 3:
        return 4
    if maxnums[0] == 2 and maxnums[1] == 2:
        return 3
    if maxnums[0] == 2:
        return 2
    return 1

with open("./input.txt", "r") as f:
    for line in f.readlines():
        cards, bid = line.split(' ', 1)
        hands.append(Hand(
            cards=[chs.index(c) for c in cards],
            bid=int(bid),
            tp=calc_tp(cards)),
        )

    hands = sorted(hands, key = lambda x: (x.tp, x.cards))
    s = 0
    for i, hand in enumerate(hands):
        rank = i+1
        print(rank, hand)
        s += rank*hand.bid

    print(s)


