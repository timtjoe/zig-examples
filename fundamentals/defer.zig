//defer runs a statement when the enclosing block exits, in LIFO order.

const std = @import("std");

fn riskyOp(fail: bool) !void {
    std.debug.print("start\n", .{});
    defer std.debug.print("cleanup (aways runs)\n", .{});

    if (fail) return error.Oops;
    std.debug.print("success\n", .{});
}

fn acquire() !i32 {
    return 7;
}

fn release(x: i32) void {
    std.debug.print("release {d}\n", .{x});
}

// errdefer only runs when the enclosing function returns an error
fn errdeferDemo(fail: bool) !void {
    const handle = try acquire();
    errdefer release(handle); //only runs on the error path
    if (fail) return error.WorkFailed;
    release(handle); //normal path
}

pub fn main() !void {
  // defer stack - LIFO. Print 3, 2, 1.
  {
    defer std.debug.print("1\n", .{});
    defer std.debug.print("2\n", .{});
    defer std.debug.print("3\n", .{});
  }

  riskyOp(false) catch {};
  riskyOp(true) catch {};

  errdeferDemo(false) catch {};
  errdeferDemo(true) catch {};
}