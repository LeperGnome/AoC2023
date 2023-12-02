const std = @import("std");
const expect = @import("std").testing.expect;

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

fn inner(in: []const u8) !usize {
    var sum: usize = 0;
    var iter = std.mem.split(u8, in, "\n");
    while (iter.next()) |line| {
        if (line.len == 0) continue;
        var buf = [2]u8{ 0, 0 };
        const ds = [_]u8{ '1', '2', '3', '4', '5', '6', '7', '8', '9' };

        var min_idx: ?usize = std.mem.indexOfAny(u8, line, &ds);
        if (min_idx) |i| {
            buf[0] = line[i];
            buf[1] = line[i];
        }
        var max_idx: ?usize = std.mem.lastIndexOfAny(u8, line, &ds);
        if (max_idx) |i| {
            buf[1] = line[i];
        }

        for (nums, 0..) |num, n_val| {
            const val: u8 = @intCast(n_val + 49);
            if (std.mem.lastIndexOf(u8, line, num)) |idx| {
                if (max_idx) |mi| {
                    if (idx > mi) {
                        buf[1] = val;
                        max_idx = idx;
                    }
                } else {
                    max_idx = idx;
                    buf[1] = val;
                }
            }
            if (std.mem.indexOf(u8, line, num)) |idx| {
                if (min_idx) |mi| {
                    if (idx < mi) {
                        buf[0] = val;
                        min_idx = idx;
                    }
                } else {
                    min_idx = idx;
                    buf[0] = val;
                }
            }
        }

        const num: usize = try std.fmt.parseInt(usize, &buf, 10);
        sum += num;
    }
    return sum;
}

test "solution" {
    try expect(try inner("12") == @as(usize, 12));
    try expect(try inner("onetwo") == @as(usize, 12));
    try expect(try inner("2onetwo") == @as(usize, 22));
    try expect(try inner("2aslkdjf") == @as(usize, 22));
    try expect(try inner("twoaslkdjf") == @as(usize, 22));
    try expect(try inner("4onetwoaslkdjf9") == @as(usize, 49));
    try expect(try inner("ninesdkjf1") == @as(usize, 91));
    try expect(try inner("6j") == @as(usize, 66));
}

const nums = [_][]const u8{
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
};
