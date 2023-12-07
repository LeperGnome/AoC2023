const std = @import("std");
const expect = @import("std").testing.expect;
const print = std.debug.print;

pub fn solution() !usize {
    // For part 1:
    // const tlimits = [4]usize{ 35, 93, 73, 66 };
    // const rdist = [4]usize{ 212, 2060, 1201, 1044 };

    const tlimits = [1]usize{35937366};
    const rdist = [1]usize{212206012011044};
    return inner(&tlimits, &rdist);
}

fn inner(tlimits: []const usize, rdist: []const usize) !usize {
    var acc: usize = 1;
    for (tlimits, 0..) |mt, i| {
        var nwins: usize = 0;
        for (0..tlimits[i]) |t| {
            const dist = t * (mt - t);
            if (dist > rdist[i]) {
                nwins += 1;
            }
        }
        acc *= nwins;
    }
    return acc;
}

test "solution" {
    try expect(try inner(&[3]usize{ 7, 15, 30 }, &[3]usize{ 9, 40, 200 }) == @as(usize, 288));
    try expect(try inner(&[1]usize{71530}, &[1]usize{940200}) == @as(usize, 71503));
}
