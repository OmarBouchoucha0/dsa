const std = @import("std");

pub const Stack = struct {
    items: std.ArrayList(usize),
    len: u8,

    pub fn init() Stack {
        return Stack{
            .items = .empty,
            .len = 0,
        };
    }

    pub fn deinit(self: *Stack, allocator: std.mem.Allocator) void {
        self.items.deinit(allocator);
    }

    pub fn push(self: *Stack, allocator: std.mem.Allocator, val: usize) !void {
        try self.*.items.append(allocator, val);
        self.*.len += 1;
    }

    pub fn pop(self: *Stack) void {
        _ = self.*.items.pop().?;
        self.*.len -= 1;
    }

    pub fn peek(self: Stack) usize {
        return self.items.last().?.*;
    }

    pub fn print(self: Stack) void {
        for (self.items.items, 0..) |item, i| {
            std.debug.print("item {} : {}\n", .{ i, item });
        }
    }
};

test "empty stack" {
    const stack: Stack = Stack.init();
    try std.testing.expect(stack.len == 0);
}

test "stack push 1 item" {
    var stack: Stack = Stack.init();
    const allocator = std.testing.allocator;
    defer stack.deinit(allocator);

    try stack.push(allocator, 5);
    try std.testing.expect(stack.len != 0);
    try std.testing.expect(stack.items.items[0] == 5);
}

test "stack push many item" {
    var stack: Stack = Stack.init();

    const allocator = std.testing.allocator;
    defer stack.deinit(allocator);

    for (0..5) |i| {
        try stack.push(allocator, i);
    }
    try std.testing.expect(stack.len != 0);

    for (0..5) |i| {
        try std.testing.expect(stack.items.items[i] == i);
    }
}

test "stack pop 1 item" {
    var stack: Stack = Stack.init();

    const allocator = std.testing.allocator;
    defer stack.deinit(allocator);

    try stack.push(allocator, 1);
    stack.pop();
    try std.testing.expect(stack.len == 0);
}

test "stack pop many item" {
    var stack: Stack = Stack.init();

    const allocator = std.testing.allocator;
    defer stack.deinit(allocator);

    for (0..5) |i| {
        try stack.push(allocator, i);
    }

    for (0..4) |_| {
        stack.pop();
    }
    try std.testing.expect(stack.len == 1);
    try std.testing.expect(stack.items.items[0] == 0);
}

test "stack peek item" {
    var stack: Stack = Stack.init();
    const allocator = std.testing.allocator;
    defer stack.deinit(allocator);

    try stack.push(allocator, 5);
    const last = stack.peek();

    try std.testing.expect(stack.len == 1);
    try std.testing.expect(last == 5);
}
