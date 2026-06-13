//! By convention, root.zig is the root source file when making a package.
const std = @import("std");
const Io = std.Io;
pub const LinkedList = @import("linkedList.zig");

test {
    _ = @import("linkedList.zig");
    _ = @import("stack.zig");
    _ = @import("queue.zig");
    _ = @import("dynamicArray.zig");
}
