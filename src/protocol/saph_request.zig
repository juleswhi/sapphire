const std = @import("std");
const saph_content_type = @import("saph_types.zig").saph_content_type;
const saph_request_type = @import("saph_types.zig").saph_request_type;
const print = std.debug.print;

// Build to send code over server?
// OR create server general and create custom impl?

const PROTOCOL_VERSION = 1;

pub const saph_request = struct {
    version: u8,
    req_type: saph_request_type,

    host: u32,
    incr: bool,

    path_len: u16,
    path: []const u8,

    content_len: u32,
    content_type: saph_content_type,
    content: []const u8,

    pub fn from_bytes(bytes: *const []const u8) ?saph_request {
        // Refactor to use some sort of idx var
        var msg: saph_request = undefined;

        if (bytes.*.len < 16) {
            return null;
        }

        if (bytes.*[0] != PROTOCOL_VERSION) {
            std.debug.print("Invalid Version Number\n", .{});
            return null;
        }

        msg.version = bytes.*[0];

        const request_type = saph_request_type.itot(bytes.*[1]);
        if (request_type) |type_| {
            msg.req_type = type_;
        } else {
            return null;
        }

        msg.host = bytesToU32be(bytes.*[2..6]);

        msg.incr = switch (bytes.*[6]) {
            1 => true,
            else => false,
        };

        msg.path_len = bytesToU16be(bytes.*[7..9]);

        const offset = msg.path_len;

        if (msg.path_len > 0) {
            msg.path = bytes.*[9..(9 + offset)];
        }

        const min = 9 + offset;
        const max = 13 + offset;
        msg.content_len = bytesToU32be(bytes.*[min..max][0..4]);
        const content_type = saph_content_type.itot(bytes.*[13 + offset]);

        if (content_type) |type_| {
            msg.content_type = type_;
        } else {
            return null;
        }

        if (msg.content_len > 0) {
            msg.content = bytes.*[(14 + offset)..(14 + msg.content_len + offset)];
        }

        return msg;
    }

    pub fn report(self: *const saph_request) void {
        std.debug.print("{s} at {s} -- Content: {s}\n", .{
            self.req_type.toa() orelse "None",
            self.path,
            self.content,
        });
    }
};

fn bytesToU16be(bytes: *const [2]u8) u16 {
    return (@as(u16, bytes.*[0]) << 8) | bytes.*[1];
}

fn bytesToU32be(bytes: *const [4]u8) u32 {
    return (@as(u32, bytes.*[0]) << 24) | (@as(u32, bytes.*[1]) << 16) | (@as(u32, bytes.*[2]) << 8) | bytes.*[3];
}
