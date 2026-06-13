const std = @import("std");

pub const DynamicArray = struct {
    items: ?[]usize,
    len: u8,
    capacity: u8,
    pub fn init() DynamicArray {
        return DynamicArray{
            .items = null,
            .len = 0,
            .capacity = 0,
        };
    }

    pub fn initWithCapacity(allocator: *std.mem.Allocator, capacity: u8) !DynamicArray {
        const items = try allocator.alloc(usize, capacity);

        return DynamicArray{
            .items = items,
            .len = 0,
            .capacity = capacity,
        };
    }

    pub fn deinit(self: *DynamicArray, allocator: *std.mem.Allocator) void {
        if (self.items != null) {
            allocator.free(self.items.?);
        }
    }

    pub fn append(self: *DynamicArray, allocator: *std.mem.Allocator, val: usize) !void {
        if (self.len < self.capacity) {
            self.items.?[self.len] = val;
            self.len += 1;
            return;
        }
        if (self.capacity == 0) {
            self.capacity = 1;
            self.items = try allocator.alloc(usize, self.capacity);
            self.items.?[self.len] = val;
            self.len += 1;
            return;
        }
        self.capacity = self.capacity * 2;
        self.items = try allocator.realloc(self.items.?, self.capacity);
        self.items.?[self.len] = val;
        self.len += 1;
    }
};

test "init array" {
    var allocator = std.testing.allocator;
    var array = DynamicArray.init();
    defer array.deinit(&allocator);
    try std.testing.expect(array.len == 0);
    try std.testing.expect(array.capacity == 0);
}

test "init array with capacity" {
    var allocator = std.testing.allocator;
    var array = try DynamicArray.initWithCapacity(&allocator, 10);
    defer array.deinit(&allocator);
    try std.testing.expect(array.len == 0);
    try std.testing.expect(array.capacity == 10);
}

test "append to array with capacity" {
    var allocator = std.testing.allocator;
    var array = try DynamicArray.initWithCapacity(&allocator, 10);
    defer array.deinit(&allocator);
    try array.append(&allocator, 8);
    try std.testing.expect(array.items.?[0] == 8);
    try std.testing.expect(array.len == 1);
    try std.testing.expect(array.capacity == 10);
}

test "append to array without capacity" {
    var allocator = std.testing.allocator;
    var array = DynamicArray.init();
    defer array.deinit(&allocator);
    try array.append(&allocator, 8);
    try std.testing.expect(array.items.?[0] == 8);
    try std.testing.expect(array.len == 1);
    try std.testing.expect(array.capacity == 1);
}
