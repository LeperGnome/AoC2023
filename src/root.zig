const std = @import("std");
pub const day1 = @import("days/day1/solution.zig");
pub const day2 = @import("days/day2/solution.zig");

test {
    std.testing.refAllDecls(@This());
}
