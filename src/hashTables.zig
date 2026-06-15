const std = @import("std");

const hashtableErrors = error{
    RanOutOfSpace,
    InvalidKey,
};
// fixed size hashtable
pub const hashTable = struct {
    keys: *const []u8,
    values: *usize,
    len: usize,

    pub fn init(len: usize) hashTable {
        return hashTable{
            .len = len,
        };
    }

    //copied the std library hashing test function
    fn hash(key: *const u8) u64 {
        const Wyhash = std.hash.Wyhash;
        var hasher = Wyhash.init(0);
        hash(&hasher, key, .Shallow);
        return hasher.final();
    }

    fn getIndex(self: hashTable, key: *const u8) hashtableErrors!u64 {
        if (self.len == 0) {
            return hashtableErrors.RanOutOfSpace;
        }
        return hash(key) % self.len;
    }

    pub fn getValueByKey(self: hashTable) hashtableErrors!usize {
        @panic("TODO!");
    }

    pub fn checkKey(key: *const u8) hashtableErrors!bool {
        @panic("TODO!");
    }

    pub fn add(key: *const u8) hashtableErrors!bool {
        @panic("TODO!");
    }

    pub fn remove(key: *const u8) hashtableErrors!bool {
        @panic("TODO!");
    }

    pub fn replace(key: *const u8) hashtableErrors!bool {
        @panic("TODO!");
    }

    pub fn print(key: *const u8) hashtableErrors!bool {
        @panic("TODO!");
    }
};
