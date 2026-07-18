// SIMD vector let you do data-parallel math.
const std = @import("std");

pub fn Vector() void {
    const a: @Vector(4, f32) = .{ 1, 2, 3, 4 };
    const b: @Vector(4, f32) = .{ 10, 20, 30, 40 };

    // Element-wise math is a single SIMD instruction on most targets
    const c = a + b;
    std.debug.print("{d}\n", .{c});

    // Reduce to scalar
    const total = @reduce(.Add, c);
    std.debug.print("sum: {d}\n", .{total});

    // Splat - broadcast a scalar
    const ones: @Vector(4, f32) = @splat(1.0);
    std.debug.print("{d}\n", .{a + ones});
}
