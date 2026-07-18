const std = @import("std");

pub fn main() !void {
  var x: i32 = 1;
  x += 1;

  // Type inference with var
  var y = @as(f32, 2.5);
  y *= 2.0;
  std.debug.print("y = {d}\n", .{y});
}