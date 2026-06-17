const std = @import("std");
const Allocator = std.mem.Allocator;

const TreeNodeError = error{DuplicateNode};

//bfs and dfs on a binary tree
const TreeNode = struct {
    val: u8,
    left: ?*TreeNode,
    right: ?*TreeNode,

    pub fn append(allocator: Allocator, root: *?*TreeNode, val: u8) !void {
        var new_node = try allocator.create(TreeNode);
        new_node.val = val;
        if (root.* == null) {
            root = new_node;
            return;
        }
        var curr = root.*;
        var prev: ?*TreeNode = null;
        while (curr != null) {
            if (curr.?.val == val) {
                return TreeNodeError.DuplicateNode;
            }
            if (curr.?.val > val) {
                prev = curr;
                curr = curr.?.left;
            } else {
                prev = curr;
                curr = curr.?.right;
            }
        }

        if (prev.?.val > val) {
            prev.?.left = new_node;
        } else {
            prev.?.right = new_node;
        }
    }

    pub fn deinit(root: *TreeNode, allocator: Allocator) !void {
        if (root.left != null) {
            TreeNode.deinit(root, allocator);
        }
        if (root.left != null) {
            TreeNode.deinit(root, allocator);
        }
        allocator.destroy(root);
    }

    pub fn dfs(root: ?*TreeNode, allocator: Allocator) void {
        if (root == null) {
            return;
        }
        var s = std.Deque(*TreeNode);
        defer s.deinit(allocator);
        var curr = root;
        s.pushFront(allocator, curr.?);
    }
};
