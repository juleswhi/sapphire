pub const saph_request_type = enum {
    get,
    give,
    incr,

    pub fn itot(i: u8) ?saph_request_type {
        return switch (i) {
            0 => .get,
            1 => .give,
            2 => .incr,
            else => null,
        };
    }

    pub fn toa(self: *const saph_request_type) ?[]const u8 {
        return switch (self.*) {
            .get => "GET",
            .give => "GIVE",
            .incr => "INCR",
        };
    }
};

pub const saph_content_type = enum {
    plaintext,
    code_markdown,
    code_lua,

    pub fn itot(i: u8) ?saph_content_type {
        return switch (i) {
            0 => .plaintext,
            1 => .code_markdown,
            2 => .code_lua,
            else => null,
        };
    }

    pub fn toa(self: *const saph_content_type) ?[]const u8 {
        return switch (self.*) {
            .plaintext => "Plaintext",
            .code_markdown => "Code/Markdown",
            .code_lua => "Code/LUA",
            else => null,
        };
    }
};
