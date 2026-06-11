const std = @import("std");

pub const Node = struct {
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

pub fn push(head: *?*Node, node: *Node) void {
    const first = head.*;
    head.* = node;
    node.next = first;
}

pub fn print_ll(head: ?*Node) void {
    if (head == null) {
        return;
    }
    var curr: ?*Node = head.?;
    var i: usize = 0;
    while (curr != null) : (i += 1) {
        std.debug.print("value -{}- : {}\n", .{ i, curr.?.val });
        curr = curr.?.next;
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
    while (curr) |node| : (i += 1) {
        try std.testing.expect(curr.?.val == i);
        curr = node.next;
    }
}

test "linked list push many items" {
    var head: ?*Node = null;
    var nodes: [3]Node = undefined;

    for (0..nodes.len) |i| {
        nodes[i] = .{
            .val = @intCast(i + 1),
            .next = null,
        };

        push(&head, &nodes[i]);
    }
    try std.testing.expect(head != null);

    var curr: ?*const Node = head;
    var i: u8 = 3;
    while (curr) |node| : (i -= 1) {
        try std.testing.expect(curr.?.val == i);
        curr = node.next;
    }
}
