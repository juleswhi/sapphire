const std = @import("std");

const saph_content_type = @import("saph_types.zig").saph_content_type;
const saph_request_type = @import("saph_types.zig").saph_request_type;

pub const saph_response = struct {
    version: u8,
    request_type: saph_request_type,

    status_code: u8,

    incr: bool,
    incr_iden: u32,

    date_len: u16,
    date: []const u8,

    content_len: u32,
    content_type: saph_content_type,
    content: []const u8,

    pub fn from() saph_response {
        const res: saph_response = .{
            .version = 1,
            .request_type = saph_request_type.give,
            .status_code = 20,
            .incr = false,
            .incr_iden = 0,
            .date_len = 0,
            .date = "",
            .content_len = 0,
            .content_type = saph_content_type.plaintext,
            .content = "",
        };
        return res;
    }

    pub fn to_bytes(self: *const saph_response, alloc: std.mem.Allocator) ![]u8 {
        var _bytes = std.ArrayList(u8).init(alloc);
        defer _bytes.deinit();

        try _bytes.append(self.version);
        try _bytes.append(self.request_type.toi());
        try _bytes.append(self.status_code);
        try _bytes.append(@intFromBool(self.incr));
        try _bytes.append(self.status_code);
        try _bytes.appendSlice(&u32ToBytesBE(self.incr_iden));
        try _bytes.appendSlice(&u16ToBytesBE(@intCast(self.date.len)));
        try _bytes.appendSlice(self.date);

        try _bytes.appendSlice(&u32ToBytesBE(@intCast(self.content.len)));
        try _bytes.append(self.content_type.toi());
        try _bytes.appendSlice(self.content);

        return _bytes.toOwnedSlice();
    }
};

pub fn u32ToBytesBE(value: u32) [4]u8 {
    var bytes: [4]u8 = undefined;
    bytes[0] = @truncate(value >> 24);
    bytes[1] = @truncate(value >> 16 & 0xFF);
    bytes[2] = @truncate(value >> 8 & 0xFF);
    bytes[3] = @truncate(value & 0xFF);
    return bytes;
}

pub fn u16ToBytesBE(value: u16) [2]u8 {
    var bytes: [2]u8 = undefined;
    bytes[0] = @truncate(value >> 8);
    bytes[1] = @truncate(value & 0xFF);
    return bytes;
}
