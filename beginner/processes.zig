// std.process.run - spawns a child, waits for it, collect it stdout and stderr and hands them back as owned slices. when you need finer control, drop down to std.process.spawn and talk to the child's pipes directly.

const std = @import("std");

pub fn main(init: std.process.Init) !void {
  var dbg: std.heap.DebugAllocator(.{}) = .init;
  defer _ = dbg.deinit();
  const gpa = dbg.allocator();

  var io_impl: std.Io.Threaded = .init(gpa, .{});
  defer io_impl.deinit();
  const io = io_impl.io;

  // std.process.run is the convenience: spawn, wait, collect
  const result = try std.process.run(gpa, io , .{.argv = &.{"uname", "-s"}});
  defer gpa.free(result.stdout);
  defer gpa.free(result.stderr);

  std.debug.print("os: {s}", args: anytype)
}