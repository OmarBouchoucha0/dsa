const std = @import("std");

pub const Queue = struct {
    items: std.ArrayList(usize),
    len: u8,

    // we could preallocate memeory here or create diffenet functions that does that
    pub fn init() Queue {
        return Queue{
            .items = .empty,
            .len = 0,
        };
    }

    pub fn deinit(self: *Queue, allocator: std.mem.Allocator) void {
        self.items.deinit(allocator);
    }

    pub fn push(self: *Queue, allocator: std.mem.Allocator, val: usize) !void {
        try self.*.items.insert(allocator, 0, val);
        self.*.len += 1;
    }

    pub fn pop(self: *Queue) void {
        _ = self.*.items.pop().?;
        self.*.len -= 1;
    }

    pub fn print(self: Queue) void {
        for (self.items.items, 0..) |item, i| {
            std.debug.print("item {} : {}\n", .{ i, item });
        }
    }
};

test "empty queue" {
    const queue: Queue = Queue.init();
    try std.testing.expect(queue.len == 0);
}

test "queue push 1 item" {
    var queue: Queue = Queue.init();
    const allocator = std.testing.allocator;
    defer queue.deinit(allocator);

    try queue.push(allocator, 5);
    try std.testing.expect(queue.len != 0);
    try std.testing.expect(queue.items.items[0] == 5);
}

test "queue push many item" {
    var queue: Queue = Queue.init();
    const allocator = std.testing.allocator;
    defer queue.deinit(allocator);

    for (0..5) |i| {
        try queue.push(allocator, i);
    }
    try std.testing.expect(queue.len != 0);

    for (0..5) |i| {
        try std.testing.expect(queue.items.items[i] == 4 - i);
    }
    try std.testing.expect(queue.items.items[4] == 0);
}

test "queue pop 1 item" {
    var queue: Queue = Queue.init();
    const allocator = std.testing.allocator;
    defer queue.deinit(allocator);

    try queue.push(allocator, 1);
    queue.pop();
    try std.testing.expect(queue.len == 0);
}

test "queue pop many item" {
    var queue: Queue = Queue.init();
    const allocator = std.testing.allocator;
    defer queue.deinit(allocator);

    for (0..5) |i| {
        try queue.push(allocator, i);
    }

    for (0..4) |_| {
        queue.pop();
    }
    try std.testing.expect(queue.len == 1);
    try std.testing.expect(queue.items.items[0] == 4);
}
