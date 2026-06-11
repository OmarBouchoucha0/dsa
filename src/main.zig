const std = @import("std");
const ll = @import("linkedList.zig");

pub fn main() void {
    var head: ?*ll.Node = null;
    var nodes: [3]ll.Node = undefined;
    for (0..nodes.len) |i| {
        nodes[i] = .{
            .val = @intCast(i + 1),
            .next = null,
        };
        ll.append(&head, &nodes[i]);
    }

    var others: [3]ll.Node = undefined;
    for (0..others.len) |i| {
        others[i] = .{
            .val = @intCast(i + 1),
            .next = null,
        };

        ll.push(&head, &others[i]);
    }
    ll.print_ll(head);
}
