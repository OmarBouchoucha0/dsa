const std = @import("std");

const Node = struct {
    val: usize,
    left: ?*Node,
    right: ?*Node,

    pub fn deinit(self: *Node, allocator: std.mem.Allocator) void {
        if (self.left) |left_child| {
            left_child.deinit(allocator);
        }
        if (self.right) |right_child| {
            right_child.deinit(allocator);
        }
        allocator.destroy(self);
    }

    pub fn push(allocator: std.mem.Allocator, root: *?*Node, val: usize) !void {
        var new_node = try allocator.create(Node);
        new_node.val = val;
        new_node.left = null;
        new_node.right = null;
        if (root.* == null) {
            root.* = new_node;
            return;
        }
        var curr = root.*;
        while (curr != null) {
            if (val > curr.?.val) {
                if (curr.?.left == null) {
                    curr.?.left = new_node;
                    return;
                } else {
                    curr = curr.?.left;
                }
            } else {
                if (curr.?.right == null) {
                    curr.?.right = new_node;
                    return;
                } else {
                    curr = curr.?.right;
                }
            }
        }
    }

    pub fn search(root: *?*Node, val: usize) bool {
        var curr = root.*;
        while (curr != null) {
            if (curr.?.val == val) {
                return true;
            }
            if (curr.?.val > val) {
                curr = curr.?.right;
            } else {
                curr = curr.?.left;
            }
        }
        return false;
    }

    pub fn print(root: *?*Node) void {
        if (root.* == null) {
            return;
        }
        std.debug.print("val : {}", .{root.*.?.val});
        print(root.*.?.left);
        print(root.*.?.right);
    }
};

test "tree of 1" {
    const allocator = std.testing.allocator;
    var root: ?*Node = null;
    defer Node.deinit(root.?, allocator);
    try Node.push(allocator, &root, 4);
    try std.testing.expect(root.?.val == 4);
}

test "tree of 3" {
    const allocator = std.testing.allocator;
    var root: ?*Node = null;
    defer Node.deinit(root.?, allocator);
    try Node.push(allocator, &root, 1);
    try Node.push(allocator, &root, 0);
    try Node.push(allocator, &root, 2);
    try std.testing.expect(root.?.val == 1);
    try std.testing.expect(root.?.left.?.val == 2);
    try std.testing.expect(root.?.right.?.val == 0);
}

test "tree of 5" {
    const allocator = std.testing.allocator;
    var root: ?*Node = null;
    defer Node.deinit(root.?, allocator);
    try Node.push(allocator, &root, 1);
    try Node.push(allocator, &root, 0);
    try Node.push(allocator, &root, 3);
    try Node.push(allocator, &root, 5);
    try Node.push(allocator, &root, 2);
    try std.testing.expect(root.?.val == 1);
    try std.testing.expect(root.?.left.?.val == 3);
    try std.testing.expect(root.?.right.?.val == 0);
    try std.testing.expect(root.?.left.?.left.?.val == 5);
    try std.testing.expect(root.?.left.?.right.?.val == 2);
}
