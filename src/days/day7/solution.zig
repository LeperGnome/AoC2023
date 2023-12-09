const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;
const sort = std.sort;

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

const Hand = struct {
    cards: []const u8,
    bid: usize,
    type_: u8,
};

fn inner(in: []const u8) !usize {
    var lines = std.mem.split(u8, in, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var pts = std.mem.splitSequence(u8, line, " ");
        const cards = pts.next().?;

        const hand = Hand{
            .cards = cards,
            .bid = try std.fmt.parseInt(usize, pts.next().?, 10),
            .type_ = calc_type(cards),
        };
        print("{any}\n", .{hand});
    }
    return 0;
}

fn calc_type(cards: []const u8) u8 {
    sort.block(u8, &cards[0..], {}, sort.asc(u8));
    print("{c}\n", .{cards});
    var prev = cards[0];
    var counts = [5]u8{ 1, 0, 0, 0, 0 };
    var ci: usize = 1;

    for (cards[1..]) |c| {
        if (c == prev) {
            counts[ci] += 1;
        } else {
            ci += 1;
            counts[ci] = 1;
        }
        prev = c;
    }
    sort.heap(u8, &counts, {}, sort.desc(u8));

    print("counts: {d}\n", .{counts});
    return counts[0] + counts[1];
}

test "solution" {
    const test_in =
        \\32T3K 765
        \\T55J5 684
        \\KK677 28
        \\KTJJT 220
        \\QQQJA 483
    ;
    _ = test_in;
}
