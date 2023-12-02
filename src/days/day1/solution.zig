const std = @import("std");
const expect = @import("std").testing.expect;

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

const ds = [_][]const u8{ // note: order matters
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
};
const dc = [_]u8{ // note: order matters
    '1', '2', '3', '4', '5', '6', '7', '8', '9',
};

fn inner(in: []const u8) !usize {
    var sum: usize = 0;
    var iter = std.mem.split(u8, in, "\n");
    while (iter.next()) |line| {
        if (line.len == 0) continue;

        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var rline = line;
        for (ds, 0..) |s, idx| {
            const replaced = try std.mem.replaceOwned(u8, allocator, rline, s, &[_]u8{dc[idx]});
            rline = replaced;
        }
        std.debug.print("{s}\n", .{rline});

        const min_idx = std.mem.indexOfAny(u8, rline, &dc).?;
        const max_idx = std.mem.lastIndexOfAny(u8, rline, &dc) orelse min_idx;
        const num: usize = try std.fmt.parseInt(usize, &[_]u8{ rline[min_idx], rline[max_idx] }, 10);

        sum += num;
    }
    std.debug.print("{d} \n", .{sum});
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
    try expect(try inner("eightwo1") == @as(usize, 81));
}
