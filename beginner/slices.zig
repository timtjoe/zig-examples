const std = @import("std");

pub fn main() void {
    var arr = [_]i32{ 10, 20, 30, 40, 50 };
    // Slice of the whole array
    // const mid = arr[1..4];
    const s: []i32 = arr[0..];
    s[0] = 99;

    std.debug.print("total: {d}\n", .{sum(s)});
}
fn sum(nums: []const i32) i32 {
    var total: i32 = 0;
    for (nums) |n| total += n;
    return total;
}
