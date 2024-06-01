const std = @import("std");
const print = std.debug.print;

// Build to send code over server?
// OR create server general and create custom impl?

const PROTOCOL_VERSION = 1;

pub const saph_request_type = enum {
    none,
    get,
    post,

    pub fn itot(i: u8) saph_request_type {
        return switch (i) {
            1 => .get,
            2 => .post,
            else => .none,
        };
    }
};

pub const saph_content_type = enum {
    plaintext,
    code_,
    code_html,
    code_css,
    code_lua,
    none,

    pub fn itot(i: u8) saph_content_type {
        return switch (i) {
            0 => .plaintext,
            1 => .code_,
            2 => .code_html,
            3 => .code_css,
            4 => .code_lua,
            else => .none,
        };
    }
};

pub const saph_msg = struct {
    version: u8,
    req_type: saph_request_type,

    // addy_len: u16,
    // addy: []const u8,

    content_len: u32,
    content_type: saph_content_type,
    content: []const u8,

    client_addy: u32,
    incr: bool,

    pub fn from_bytes(bytes: *const []const u8) ?saph_msg {
        // Refactor to use some sort of idx var
        var msg: saph_msg = undefined;

        if (bytes.*.len < 12) {
            return null;
        }

        std.debug.print("Version number recieved: {}\n", .{bytes.*[0]});
        std.debug.print("Recieved bytes: {}\n", .{bytes.*.len});
        if (bytes.*[0] != PROTOCOL_VERSION) {
            std.debug.print("Invalid Version Number\n", .{});
            return null;
        }

        msg.version = bytes.*[0];

        const srt = saph_request_type.itot(bytes.*[1]);
        msg.req_type = srt;

        // msg.addy_len = bytesToU16be(bytes.*[2..3]);
        // if (msg.addy_len > 0) {
        //    msg.addy = bytes.*[5..(4 + msg.addy_len)];
        //}

        msg.client_addy = bytesToU32be(bytes.*[2..6]);

        msg.incr = switch (bytes.*[6]) {
            1 => true,
            else => false,
        };

        msg.content_len = bytesToU32be(bytes.*[7..11]);
        msg.content_type = saph_content_type.itot(bytes.*[11]);

        if (msg.content_len > 0) {
            msg.content = bytes.*[12 .. 12 + msg.content_len];
        }

        return msg;
    }
};

fn bytesToU16be(bytes: *const [2]u8) u16 {
    return (@as(u16, bytes.*[0]) << 8) | bytes.*[1];
}

fn bytesToU32be(bytes: *const [4]u8) u32 {
    return (@as(u32, bytes.*[0]) << 24) | (@as(u32, bytes.*[1]) << 16) | (@as(u32, bytes.*[2]) << 8) | bytes.*[3];
}
