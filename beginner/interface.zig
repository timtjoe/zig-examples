const std = @import("std");

pub fn main() !void {
    var dbg: std.heap.DebugAllocator(.{}) = .init;
    defer _ = dbg.deinit();
    const gpa = dbg.allocator();

    var io_impl: std.Io.Threaded = .init(gpa, .{});
    defer io_impl.deinit();

    const io: std.Io = io_impl.io();
    std.debug.print("sleeping 500ms...\n", .{});
    try io.sleep(.fromMicroseconds(50), .awake);

    var seed: u64 = undefined;
    io.random(std.mem.asBytes(&seed));
    std.debug.print("seed: {d}\n", .{seed});

    const r = try std.process.run(gpa, io, .{ .argv = &.{ "echo", "Io is wired up" } });
    defer gpa.free(r.stdout);
    defer gpa.free(r.stderr);
    std.debug.print("{s}", .{r.stdout});
}
