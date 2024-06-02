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
        const res: saph_response = undefined;
        return res;
    }
};
