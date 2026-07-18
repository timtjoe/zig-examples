// In 0.16, file operations lives under std.Io.Dir and std.Io.File and every call takes the Io value.

const std = @import("std");

pub fn main() !void {
    var dgb: std.heap.DebugAllocator(.{}) = .init;
    defer _ = dgb.deinit();
    const gpa = dgb.allocator();

    var io_impl: std.Io.Threaded = .init(gpa, .{});
    defer io_impl.deinit();
    const io = io_impl.io();

    const cwd = std.Io.Dir.cwd();
    const path = "/tmp/hello.txt";

    // write
    {
        var buf: [128]u8 = undefined;
        var file = try cwd.createFile(io, path, .{});
        defer file.close(io);

        var fw = file.writer(io, &buf);
        const w = &fw.interface;
        try w.writeAll("Hello, Zig 0.16!\nLine two.\n");
        try w.flush();
    }

    // Read the whole file into memory
    {
        const contents = try cwd.readFileAlloc(io, path, gpa, .unlimited);
        defer gpa.free(contents);
        std.debug.print("read:\n{s}", .{contents});
    }

    // Append - Io.File has no seek; use writePositionAll at the file size.
    {
        var file = try cwd.openFile(io, path, .{ .mode = .read_write });
        defer file.close(io);
        const info = try file.stat(io);
        try file.writePositionalAll(io, "Line there.\n", info.size);
    }
    // Read line by line
    {
        var read_buf: [256]u8 = undefined;
        var file = try cwd.openFile(io, path, .{});
        defer file.close(io);

        var fr = file.reader(io, &read_buf);
        const r = &fr.interface;

        var line_num: u32 = 0;
        while (try r.takeDelimiter('\n')) |line| {
            line_num += 1;
            std.debug.print("{d}: {s}\n", .{ line_num, line });
        }
    }
    try cwd.deleteFile(io, path);
}
