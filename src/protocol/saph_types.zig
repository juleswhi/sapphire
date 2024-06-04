pub const saph_request_type = enum {
    get,
    post,

    pub fn itot(i: u8) ?saph_request_type {
        return switch (i) {
            1 => .get,
            2 => .post,
            else => null,
        };
    }

    pub fn toa(self: *const saph_request_type) ?[]const u8 {
        return switch (self.*) {
            .get => "GET",
            .post => "POST",
        };
    }
};

pub const saph_content_type = enum {
    plaintext,
    code_,
    code_html,
    code_css,
    code_lua,
    code_json,

    pub fn itot(i: u8) ?saph_content_type {
        return switch (i) {
            0 => .plaintext,
            1 => .code_,
            2 => .code_html,
            3 => .code_css,
            4 => .code_lua,
            5 => .code_json,
            else => null,
        };
    }

    pub fn toa(self: *const saph_content_type) ?[]const u8 {
        return switch (self.*) {
            .plaintext => "Plaintext",
            .code_ => "Code/None",
            .code_html => "Code/HTML",
            .code_css => "Code/CSS",
            .code_lua => "Code/Lua",
            .code_json => "Code/Json",
            else => null,
        };
    }
};
