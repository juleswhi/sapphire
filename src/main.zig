const std = @import("std");
const server = @import("server/server.zig");

pub fn main() !u8 {
    server.start() catch |e| {
        std.debug.print("Error running server: {}", .{e});
        return 1;
    };
    return 0;
}
