const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;
const ArrayList = std.ArrayList;

pub fn solution1() !usize {
    const in = @embedFile("./input.txt");
    return inner1(in);
}

fn inner1(in: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var sum: usize = 0;
    var lines = std.mem.splitSequence(u8, in, "\n");
    var clines = ArrayList([]const u8).init(allocator);
    defer clines.deinit();
    while (lines.next()) |line| {
        try clines.append(line);
    }
    var groups = std.mem.window([]const u8, clines.items, 3, 1);
    while (groups.next()) |line_group| {
        const mid_line = line_group[1];
        if (line_group[2].len == 0) {
            break;
        }
        var buf = ArrayList(u8).init(allocator);
        var had_adj = false;
        defer buf.deinit();
        print("{s}\n", .{mid_line});

        for (mid_line, 0..) |col, x| {
            if (x == mid_line.len - 1 or x == 0) {
                continue;
            }
            if (std.ascii.isDigit(col)) {
                try buf.append(col);
                if (num_has_adjacent_symbol1(x, 1, line_group)) {
                    had_adj = true;
                }
            } else {
                if (had_adj) {
                    const num = try std.fmt.parseInt(usize, buf.items, 10);
                    print("found num: {d}\n", .{num});
                    sum += num;
                }
                had_adj = false;
                buf.clearAndFree();
            }
        }
        if (had_adj) {
            const num = try std.fmt.parseInt(usize, buf.items, 10);
            print("found num: {d}\n", .{num});
            sum += num;
        }
    }

    print("sum: {d}\n", .{sum});
    return sum;
}

fn num_has_adjacent_symbol1(x: usize, y: usize, map: []const []const u8) bool {
    for ([_]i64{ -1, 0, 1 }) |dy| {
        for ([_]i64{ -1, 1 }) |dx| {
            const el = map[
                @as(usize, @intCast(@as(i64, @intCast(y)) + dy))
            ][
                @as(usize, @intCast(@as(i64, @intCast(x)) + dx))
            ];
            print("------: {c} ({c})\n", .{ el, map[y][x] });
            if (el != '.') {
                if (std.ascii.isDigit(el) and dy == 0) {
                    continue;
                }
                print("nice: {c}\n", .{el});
                return true;
            }
        }
    }
    return false;
}

test "solution1" {
    const test_in =
        \\............
        \\.467..114...
        \\....*.......
        \\...35..633..
        \\.......#....
        \\.617*.......
        \\......+.58..
        \\...592......
        \\.......755..
        \\....$.*.....
        \\..664.598...
        \\............
    ;
    try expect(try inner1(test_in) == @as(usize, 4361));
}

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

fn inner(in: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var sum: usize = 0;
    var lines = std.mem.splitSequence(u8, in, "\n");
    var clines = ArrayList([]const u8).init(allocator);
    defer clines.deinit();
    while (lines.next()) |line| {
        try clines.append(line);
    }
    var gears = std.AutoHashMap([2]usize, usize).init(allocator);
    var groups = std.mem.window([]const u8, clines.items, 3, 1);
    var group_n: usize = 0;
    while (groups.next()) |line_group| : (group_n += 1) {
        const mid_line = line_group[1];
        if (line_group[2].len == 0) {
            break;
        }
        var buf = ArrayList(u8).init(allocator);
        defer buf.deinit();
        print("{s}\n", .{mid_line});
        var gc: ?[2]usize = null;

        for (mid_line, 0..) |col, x| {
            if (x == mid_line.len - 1 or x == 0) {
                continue;
            }
            if (std.ascii.isDigit(col)) {
                try buf.append(col);
                if (near_gear(
                    x,
                    1,
                    line_group,
                    group_n,
                )) |coord| {
                    gc = coord;
                }
            } else {
                if (gc) |coord| {
                    print("found gear: {any}\n", .{coord});
                    const num = try std.fmt.parseInt(usize, buf.items, 10);
                    if (gears.getEntry(coord)) |e| {
                        e.value_ptr.* *= num;
                        sum += e.value_ptr.*;
                        print("adding to sum: {d}\n", .{num});
                    } else {
                        try gears.put(coord, num);
                    }
                }
                gc = null;
                buf.clearAndFree();
            }
        }
        if (gc) |coord| {
            print("found gear: {any}\n", .{coord});
            const num = try std.fmt.parseInt(usize, buf.items, 10);
            if (gears.getEntry(coord)) |e| {
                e.value_ptr.* *= num;
                sum += e.value_ptr.*;
                print("adding to sum: {d}\n", .{num});
            } else {
                try gears.put(coord, num);
            }
        }
    }

    var i = gears.iterator();
    while (i.next()) |e| {
        print("gear: {d}: {d}\n", .{ e.key_ptr.*, e.value_ptr.* });
    }

    print("sum: {d}\n", .{sum});
    return sum;
}

fn near_gear(x: usize, y: usize, map: []const []const u8, y_offset: usize) ?[2]usize {
    for ([_]i64{ -1, 0, 1 }) |dy| {
        for ([_]i64{ -1, 1 }) |dx| {
            const gy = @as(usize, @intCast(@as(i64, @intCast(y)) + dy));
            const gx = @as(usize, @intCast(@as(i64, @intCast(x)) + dx));
            const el = map[gy][gx];
            print("------: {c} ({c})\n", .{ el, map[y][x] });
            if (el == '*') {
                print("nice: {c}\n", .{el});
                return [2]usize{ gx, gy + y_offset };
            }
        }
    }
    return null;
}

test "solution2" {
    const test_in =
        \\............
        \\.467..114...
        \\....*.......
        \\...35..633..
        \\.......#....
        \\.617*.......
        \\......+.58..
        \\...592......
        \\.......755..
        \\....$.*.....
        \\..664.598...
        \\............
    ;
    try expect(try inner(test_in) == @as(usize, 467835));
}
