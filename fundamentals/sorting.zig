const std = @import("std");

pub fn main() void {
  var nums = [_]i32{5,3,8,1,9,2,7,4,6};

  std.mem.sort(i32, &nums, {}, std.sort.asc(i32));
  std.debug.print("asc: {any}\n", .{nums});
}