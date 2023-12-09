const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;

const Node = struct {
    li: usize,
    ri: usize,
    l: [3]u8,
    r: [3]u8,
    val: [3]u8,
};
const NodeList = std.ArrayList(Node);
const NodeRefList = std.ArrayList(*Node);

pub fn solution() !usize {
    const in = @embedFile("./input.txt");
    return inner(in);
}

fn inner(in: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var nodes = NodeList.init(allocator);
    var lines = std.mem.split(u8, in, "\n");
    const dirs = lines.next().?;
    _ = lines.next();

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var pt = std.mem.splitSequence(u8, line, " = ");
        const val = pt.next().?;
        var lr = pt.next().?;
        lr = lr[1 .. lr.len - 1];
        var lrindex = std.mem.splitSequence(u8, lr, ", ");
        var node = Node{
            .li = 0,
            .ri = 0,
            .l = undefined,
            .r = undefined,
            .val = undefined,
        };
        @memcpy(&node.l, lrindex.next().?.ptr);
        @memcpy(&node.r, lrindex.next().?.ptr);
        @memcpy(&node.val, val[0..3].ptr);
        print("{s}: ({s}, {s})\n", .{ node.val, node.l, node.r });
        try nodes.append(node);
    }

    var curnodes = NodeRefList.init(allocator);

    for (nodes.items, 0..) |*node, idx| {
        if (node.val[2] == 'A') {
            try curnodes.append(node);
        }
        node.li = for (nodes.items, 0..) |n, index| {
            if (std.mem.eql(u8, &n.val, &node.l)) break index;
        } else 0;

        node.ri = for (nodes.items, 0..) |n, index| {
            if (std.mem.eql(u8, &n.val, &node.r)) break index;
        } else 0;

        print("[{d}] {s}: ({s}[{d}], {s}[{d}]), \n", .{ idx, node.val, node.l, node.li, node.r, node.ri });
    }

    var i: usize = 0;
    while (true) : (i += 1) {
        // print("looking at nodes {any}\n", .{curnodes.items});
        // print("----------\n", .{});
        if (i % 100000000 == 0) print("i: {}", .{i});
        const dir = dirs[i % dirs.len];
        var allz = true;

        for (curnodes.items, 0..) |node, idx| {
            allz = allz and node.val[2] == 'Z';
            if (dir == 'R') {
                curnodes.items[idx] = &nodes.items[node.ri];
            } else {
                curnodes.items[idx] = &nodes.items[node.li];
            }
        }
        if (allz) {
            break;
        }
    }

    return i;
}

test "solution" {
    const test_in =
        \\LR
        \\
        \\11A = (11B, XXX)
        \\11B = (XXX, 11Z)
        \\11Z = (11B, XXX)
        \\22A = (22B, XXX)
        \\22B = (22C, 22C)
        \\22C = (22Z, 22Z)
        \\22Z = (22B, 22B)
        \\XXX = (XXX, XXX)
    ;

    try expect(try inner(test_in) == @as(usize, 6));
}
