// An enum is a closed set of named integer values

const std = @import("std");
const Direction = enum {
    north,
    south,
    east,
    west,

    pub fn opposite(self: Direction) Direction {
        return switch (self) {
            .north => .south,
            .south => .north,
            .east => .west,
            .west => .east,
        };
    } //enum decl ends
};

// Enum with explicit integer tag type
const Color = enum(u8) {
    red = 1,
    green = 2,
    blue = 4,
};

pub fn main() !void {
    const d = Direction.north;
    std.debug.print("{s}\n", .{@tagName(d)});
    std.debug.print("{s}\n", .{@tagName(d.opposite())});

    const c = Color.green;
    std.debug.print("Value: {d}\n", .{@intFromEnum(c)});
}
