const std = @import("std");

const Item = struct {
    value: i32,
    node: std.DoublyLinkedList.Node = .{},
};

pub fn main() !void {
    var list: std.DoublyLinkedList = .{};

    var a: Item = .{ .value = 10 };
    var b: Item = .{ .value = 20 };
    var c: Item = .{ .value = 30 };

    list.append(&a.node);
    list.append(&b.node);
    list.append(&c.node);

    var it = list.first;
    while (it) |n| : (it = n.next) {
        const parent: *Item = @fieldParentPtr("node", n);
        std.debug.print("{d}\n", .{parent.value});
    }

    // Remove a node - pointers are unaffected, list shrinks
    list.remove(&b.node);
    std.debug.print("after removing 20:\n", .{});
    it = list.first;
    while (it) |n| : (it = n.next) {
        const parent: *Item = @fieldParentPtr("node", n);
        std.debug.print("{d}\n", .{parent.value});
    }
}
