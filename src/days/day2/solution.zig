const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

fn inner(in: []const u8) !usize {
    var lines = std.mem.split(u8, in, "\n");
    var sum: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var max_cols = [3]usize{ 1, 1, 1 };
        var desc = std.mem.split(u8, line, ": ");
        const game_id = try std.fmt.parseInt(usize, desc.first()[5..], 10);
        var sets = std.mem.splitSequence(u8, desc.next().?, "; ");
        while (sets.next()) |s| {
            var cols = std.mem.split(u8, s, ", ");
            while (cols.next()) |col| {
                var i = std.mem.splitSequence(u8, col, " ");
                const n = try std.fmt.parseInt(usize, i.next().?, 10);
                const cur_col = i.next().?;
                if (std.mem.eql(u8, cur_col, "red")) {
                    max_cols[0] = @max(max_cols[0], n);
                }
                if (std.mem.eql(u8, cur_col, "green")) {
                    max_cols[1] = @max(max_cols[1], n);
                }
                if (std.mem.eql(u8, cur_col, "blue")) {
                    max_cols[2] = @max(max_cols[2], n);
                }
            }
        }
        const mul = max_cols[0] * max_cols[1] * max_cols[2];
        sum += mul;
        print("Game {d} [{d}]: red {any}\n", .{ game_id, mul, max_cols });
    }
    return sum;
}

test "solution" {
    const test_in =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    try expect(try inner(test_in) == @as(usize, 2286));
}
