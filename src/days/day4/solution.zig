const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

fn inner(in: []const u8) !usize {
    var lines = std.mem.split(u8, in, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) continue;
    }
    return 0;
}
test "solution" {
    const test_in = "";

    try expect(try inner(test_in) == @as(usize, 0));
}
