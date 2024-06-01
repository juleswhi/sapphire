const std = @import("std");

// Build to send code over server?
// OR create server general and create custom impl?

pub const saph_request_type = enum {
    get,
    post,
};

pub const saph_content_type = enum {
    plaintext,
    code_,
    code_html,
    code_css,
    code_lua,
};

pub const saph_addy = struct {
    domain: []const u8,
    sub: [][]const u8,
};

pub const saph_msg = struct {
    version: u8,
    req_type: saph_request_type,

    addy: saph_addy,

    content_len: u32,
    content_type: saph_content_type,
};
