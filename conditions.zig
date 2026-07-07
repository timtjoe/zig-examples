// If is an expression, and it can also unwrap optionals and error unions.
const std = @import("std");

pub fn main() void {
    const score: u32 = 75;
    // if as expression
    const label = if (score >= 60) "pass" else "fail";
    std.debug.print("{s}\n", .{label});

    // unwrap an optional with capture
    const maybe: ?i32 = 42;
    if (maybe) |val| {
        std.debug.print("got: {d}\n", .{val});
    } else {
        std.debug.print("null\n", .{});
    }

    // direct null check
    const nothing: ?i32 = null;
    if (nothing == null) std.debug.print("nothing here\n", .{});

// inclusive if... don't exist
    // if(0...9) |val| {"output"} else {"output"}
}
