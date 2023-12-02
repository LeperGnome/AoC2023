const std = @import("std");
const expect = @import("std").testing.expect;

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

fn inner(in: []const u8) !usize {
    var iter = std.mem.split(u8, in, "\n");

    while (iter.next()) |line| {
        if (line.len == 0) continue;
    }
    return 0;
}

test "solution" {
    // try expect(try inner("12") == @as(usize, 12));
}
