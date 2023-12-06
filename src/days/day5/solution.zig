const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;
const ArrayList = std.ArrayList;

const Mapping = ArrayList(Range);
const Range = struct {
    source_start: usize,
    dest_start: usize,
    len: usize,
};

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

fn inner(in: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var lines = std.mem.split(u8, in, "\n");
    var seed_ranges = ArrayList([2]usize).init(allocator);

    var seeds_int_iter = std.mem.splitSequence(u8, lines.next().?[7..], " ");
    while (seeds_int_iter.next()) |seed| {
        const s = try std.fmt.parseInt(usize, seed, 10);
        const n = try std.fmt.parseInt(usize, seeds_int_iter.next().?, 10);
        try seed_ranges.append(.{ s, n });
    }
    var maps = ArrayList(Mapping).init(allocator);
    var cur_map = Mapping.init(allocator);

    while (lines.next()) |line| {
        if (line.len == 0) {
            if (cur_map.items.len > 0) {
                print("{any}\n\n", .{cur_map.items});
                try maps.append(try cur_map.clone());
                cur_map.clearAndFree();
            }
            continue;
        }
        if (!std.ascii.isDigit(line[0])) continue;
        var parts = std.mem.splitSequence(u8, line, " ");
        const r = Range{
            .dest_start = try std.fmt.parseInt(usize, parts.next().?, 10),
            .source_start = try std.fmt.parseInt(usize, parts.next().?, 10),
            .len = try std.fmt.parseInt(usize, parts.next().?, 10),
        };
        try cur_map.append(r);
    }

    var location: usize = std.math.maxInt(usize);

    for (seed_ranges.items) |seeds_range| {
        for (0..seeds_range[1]) |offset| {
            var cur_value: usize = seeds_range[0] + offset;
            for (maps.items) |mapping| {
                cur_value = sourceToDest(cur_value, mapping);
            }
            location = @min(location, cur_value);
        }
    }

    return location;
}

fn sourceToDest(source: usize, mapping: Mapping) usize {
    for (mapping.items) |range| {
        if (source >= range.source_start and source <= range.source_start + range.len - 1) {
            const offset = source - range.source_start;
            return range.dest_start + offset;
        }
    }
    return source;
}

test "solution" {
    const test_in =
        \\seeds: 79 14 55 13
        \\
        \\seed-to-soil map:
        \\50 98 2
        \\52 50 48
        \\
        \\soil-to-fertilizer map:
        \\0 15 37
        \\37 52 2
        \\39 0 15
        \\
        \\fertilizer-to-water map:
        \\49 53 8
        \\0 11 42
        \\42 0 7
        \\57 7 4
        \\
        \\water-to-light map:
        \\88 18 7
        \\18 25 70
        \\
        \\light-to-temperature map:
        \\45 77 23
        \\81 45 19
        \\68 64 13
        \\
        \\temperature-to-humidity map:
        \\0 69 1
        \\1 0 69
        \\
        \\humidity-to-location map:
        \\60 56 37
        \\56 93 4
        \\
    ;

    try expect(try inner(test_in) == @as(usize, 46));
}
