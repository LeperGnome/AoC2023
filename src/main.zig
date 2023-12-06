const std = @import("std");
const root = @import("root.zig");

pub fn main() !void {
    var args = std.process.args();
    _ = args.skip();

    const n = try std.fmt.parseInt(u8, args.next().?, 10);
    var timer = try std.time.Timer.start();

    const res = try switch (n) {
        1 => root.day1.solution(),
        2 => root.day2.solution(),
        3 => root.day3.solution(),
        4 => root.day4.solution(),
        5 => root.day5.solution(),
        6 => root.day6.solution(),
        else => error.InvalidDayNumber,
    };
    const took = std.fmt.fmtDuration(timer.read());
    std.debug.print("Solution for day #{d}: {d}\nTook: {}\n", .{ n, res, took });
}
