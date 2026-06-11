const std = @import("std");

const Node = struct {
    val: u8,
    next: ?*Node,
};

pub fn append(head: *?*Node, node: *Node) void {
    if (head.* == null) {
        head.* = node;
    } else {
        var curr: *Node = head.*.?;
        while (curr.next != null) {
            curr = curr.next.?;
        }
        curr.next = node;
    }
}

test "liked list append in empty list" {
    var head: ?*Node = null;
    var new_node = Node{
        .val = 5,
        .next = null,
    };
    append(&head, &new_node);
    try std.testing.expect(head != null);
    try std.testing.expect(head.?.val == 5);
}

test "linked list append many items" {
    var head: ?*Node = null;
    var nodes: [3]Node = undefined;

    for (0..nodes.len) |i| {
        nodes[i] = .{
            .val = @intCast(i + 1),
            .next = null,
        };

        append(&head, &nodes[i]);
    }
    try std.testing.expect(head != null);

    var curr: ?*const Node = head;
    var i: u8 = 1;
    while (curr) |node| {
        try std.testing.expect(curr.?.val == i);
        curr = node.next;
        i += 1;
    }
}
