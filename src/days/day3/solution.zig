const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Matrix = []const []const u8;

// ---------------- part 1 ------------------

pub fn solution_first() !usize {
    const in = @embedFile("./input.txt");
    return inner_first(in);
}

fn inner_first(in: []const u8) !usize {
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
    return sum;
}

fn num_has_adjacent_symbol1(x: usize, y: usize, map: Matrix) bool {
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

test "solution_first" {
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
    try expect(try inner_first(test_in) == @as(usize, 4361));
}

// ---------------- part 2 ------------------

const Coords = struct {
    x: usize,
    y: usize,
};
const Gears = std.AutoHashMap(Coords, usize);

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

    // cloning into dynamic array (this would be just .collect::<Vec<String>>() in rust)
    var clines = ArrayList([]const u8).init(allocator);
    defer clines.deinit();
    while (lines.next()) |line| {
        try clines.append(line);
    }
    // map of potential gear coordinates (x,y) to accumulated value
    var gears = Gears.init(allocator);
    // iterator over window of 3 rows, so i can check adjacent elements of middle row
    var groups = std.mem.window([]const u8, clines.items, 3, 1);
    var group_n: usize = 0;
    while (groups.next()) |line_group| : (group_n += 1) {
        const mid_line = line_group[1];
        if (line_group[2].len == 0) {
            break;
        }
        // buffer for found number e.g. ['2', '3', '4'] for 234
        var num_buf = ArrayList(u8).init(allocator);
        defer num_buf.deinit();

        // coordinates of adjacent gear if any
        var adj_gear: ?Coords = null;

        for (mid_line, 0..) |ch, x| {
            if (x == mid_line.len - 1 or x == 0) {
                continue;
            }
            if (std.ascii.isDigit(ch)) {
                // accumulating number from digits
                try num_buf.append(ch);
                if (near_gear(
                    .{ .x = x, .y = 1 },
                    &line_group,
                    group_n,
                )) |coord| {
                    // saving adjacent gear coordinates
                    adj_gear = coord;
                }
            } else {
                // registering gear when number ends
                try register_gear(&gears, adj_gear, num_buf, &sum);
                adj_gear = null;
                num_buf.clearAndFree();
            }
        }
        // registering gear for last number
        try register_gear(&gears, adj_gear, num_buf, &sum);
    }

    var i = gears.iterator();
    while (i.next()) |e| {
        print("gear: {any}: {d}\n", .{ e.key_ptr.*, e.value_ptr.* });
    }

    return sum;
}

fn register_gear(gears: *Gears, gc: ?Coords, buf: std.ArrayList(u8), sum: *usize) !void {
    if (gc) |coord| {
        const num = try std.fmt.parseInt(usize, buf.items, 10);
        // multiplying existing accumulator for gear's coordinates or adding new one
        if (gears.*.getEntry(coord)) |e| {
            e.value_ptr.* *= num;
            sum.* += e.value_ptr.*;
        } else {
            try gears.put(coord, num);
        }
    }
}

fn near_gear(coords: Coords, map: *const Matrix, y_offset: usize) ?Coords {
    for ([_]i64{ -1, 0, 1 }) |dy| {
        for ([_]i64{ -1, 1 }) |dx| {
            const gy = @as(usize, @intCast(@as(i64, @intCast(coords.y)) + dy));
            const gx = @as(usize, @intCast(@as(i64, @intCast(coords.x)) + dx));
            const el = map.*[gy][gx];
            if (el == '*') {
                return Coords{ .x = gx, .y = gy + y_offset };
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
