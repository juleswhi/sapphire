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

    fn toa(self: *const saph_request_type) ?[]const u8 {
        return switch (self.*) {
            .get => "GET",
            .post => "POST",
            .none => "NONE",
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

    fn toa(self: *const saph_content_type) ?[]const u8 {
        return switch (self.*) {
            .plaintext => "Plaintext",
            .code_ => "Code/None",
            .code_html => "Code/HTML",
            .code_css => "Code/CSS",
            .code_lua => "Code/Lua",
            .none => "None",
        };
    }
};

pub const saph_msg = struct {
    version: u8,
    req_type: saph_request_type,

    client_addy: u32,
    incr: bool,

    path_len: u16,
    path: []const u8,

    content_len: u32,
    content_type: saph_content_type,
    content: []const u8,

    pub fn from_bytes(bytes: *const []const u8) ?saph_msg {
        // Refactor to use some sort of idx var
        var msg: saph_msg = undefined;

        if (bytes.*.len < 16) {
            return null;
        }

        if (bytes.*[0] != PROTOCOL_VERSION) {
            std.debug.print("Invalid Version Number\n", .{});
            return null;
        }

        msg.version = bytes.*[0];

        const srt = saph_request_type.itot(bytes.*[1]);
        msg.req_type = srt;

        msg.client_addy = bytesToU32be(bytes.*[2..6]);

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
        msg.content_type = saph_content_type.itot(bytes.*[13 + offset]);

        if (msg.content_len > 0) {
            msg.content = bytes.*[(14 + offset)..(14 + msg.content_len + offset)];
        }

        return msg;
    }

    pub fn report(self: *const saph_msg) void {
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
