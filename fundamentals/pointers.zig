const std = @import("std");

fn increment(p: *i32) void {
    p.* += 1;
}

pub fn main() !void {
    // *T is a single-item pointer; *const T is the read-only flavor

    var x: i32 = 10;

    // Take address
    const p: *i32 = &x;

    // Deference
    std.debug.print("before: {d}\n", .{p.*});
    increment(p);
    std.debug.print("after: {d}\n", .{x}); // 11

    // Pointer to a struct field
    var point = struct { x: f32, y: f32 }{ .x = 1.0, .y = 2.0 };
    const px: *f32 = &point.x;
    px.* = 99.0;
    std.debug.print("point.x = {d}\n", .{point.x});

    // Pointer equality - compares addresses, not contents
    var u: u8 = 1;
    var v: u8 = 1;
    std.debug.print("same: {}\n", .{&u == &u});
    std.debug.print("diff: {}\n", .{&u == &v});
    u +%= 0; // touch so it isn't const-promoted
    v +%= 0;

    // Multi-Pointers - [*]T is a many-item pointer - basically a C pointer, with no length attached.
    std.debug.print("---multi-pointers---\n", .{});

    var arr = [_]u32{ 10, 20, 30, 40 };

    // Coerce array to many-pointer
    const mp: [*]u32 = &arr;
    std.debug.print("{d}\n", .{mp[0]}); // 10
    std.debug.print("{d}\n", .{mp[2]}); // 30

    // Arithmetic
    const mp2 = mp + 1;
    std.debug.print("{d}\n", .{mp2[0]});

    // Convert back to a slice with known length
    const s: []u32 = mp[0..arr.len];
    std.debug.print("len: {d}\n", .{s.len});
}

// use [*]T when you're talking to C APIs. In pure Zig code, prefer slices ([]T) - they carry their length around and rule out a whole class of bugs.
