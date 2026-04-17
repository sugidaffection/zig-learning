const std = @import("std");

pub fn main() !void {
    std.debug.print("Welcome to the Basics project!\n", .{});
    
    const a: i32 = 10;
    const b: i32 = 20;
    std.debug.print("{} + {} = {}\n", .{ a, b, a + b });
}

test "add test" {
    try std.testing.expect(1 + 1 == 2);
}
