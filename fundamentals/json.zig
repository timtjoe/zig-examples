const std = @import("std");

const Config = struct {
    host: []const u8,
    port: u16,
    debug: bool,
};

pub fn main() !void {
    var dbg: std.heap.DebugAllocator(.{}) = .init;
    defer _ = dbg.deinit();
    const alloc = dbg.allocator();

    // Parse as JSON string into a typed struct
    const src =
        \\{"host": "localhost", "port":8080, "debug":true}
    ;

    const parsed = try std.json.parseFromSlice(Config, alloc, src, .{});
    defer parsed.deinit();
    const cfg = parsed.value;

    std.debug.print("host: {s}\n", .{cfg.host});
    std.debug.print("port: {d}\n", .{cfg.port});
    std.debug.print("debug: {}\n", .{cfg.debug});

    const dynamic = try std.json.parseFromSlice(std.json.Value, alloc, src, .{});
    defer dynamic.deinit();
    if (dynamic.value.object.get("port")) |v| {
        std.debug.print("dynamic port: {d}\n", .{v.integer});
    }

    // Stringify: write into an Io.Write.Allocating, then read its bytes back.
    var aw: std.Io.Writer.Allocating = .init(alloc);
    defer aw.deinit();
    try std.json.Stringify.value(cfg, .{ .whitespace = .indent_2 }, &aw.writer);
    std.debug.print("{s}\n", .{aw.written()});
}
