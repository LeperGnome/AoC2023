const std = @import("std");
pub const day1 = @import("days/day1/solution.zig");
pub const day2 = @import("days/day2/solution.zig");
pub const day3 = @import("days/day3/solution.zig");
pub const day4 = @import("days/day4/solution.zig");
pub const day5 = @import("days/day5/solution.zig");
pub const day6 = @import("days/day6/solution.zig");
pub const day7 = @import("days/day7/solution.zig");

test {
    std.testing.refAllDecls(@This());
}
