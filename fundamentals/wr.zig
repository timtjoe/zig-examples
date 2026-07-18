// std.io.write and std.io.read are the byte-stream interfaces.

const std = @import("std");

const Point = struct {
    x: i32,
    y: i32,

    pub fn format(
        p: Point,
        w: *std.Io.Writer,
    ) std.Io.Writer.Error!void {
        try w.print("({d}, {d})", .{ p.x, p.y });
    }
};

pub fn main() !void {
    var dbg: std.heap.DebugAllocator(.{}) = .init;
    defer _ = dbg.deinit();
    const gpa = dbg.allocator();

    var io_impl: std.Io.Threaded = .init(gpa, .{});
    defer io_impl.deinit();
    const io = io_impl.io();

    // 1. Write to stdout. The buffer lives on the stack; flush before exit.
    var out_buf: [4096]u8 = undefined;
    var out_file = std.Io.File.stdout().writer(io, &out_buf);
    const out = &out_file.interface;
    defer out.flush() catch {};

    try out.print("plain string: {s}\n", .{"hi"});
    try out.print("number: {d}\n", .{42});

    // Types with a 'format' method print via {f} - the explicit 'f' makes to custom formatters visible at the call site.

    const p: Point = .{.x = 3, .y = 4};
    try out.print("point: {f}\n", .{p});

    // 2. Write.Allocating - grows a heap buffer, return owner bytes.
    var alloc_writer: std.Io.Writer.Allocating = .init(gpa);
    defer alloc_writer.deinit();
    const w = &alloc_writer.writer;

    try w.print("line {d}\n", .{1});
    try w.print("line {d}\n", .{2});

    try out.print("collected:\n{s}", .{alloc_writer.written()});

    // 3. reading over a fixed slice - for parsing in-memory bytes
    var src: std.Io.Reader = .fixed("alpha,beta,gamma");
    while (try src.takeDelimiter(',')) |field| {
        try out.print("field: {s}\n", .{field});
    }

}