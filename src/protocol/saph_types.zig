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

    pub fn toi(self: *const saph_request_type) u8 {
        return switch (self.*) {
            .get => 0,
            .give => 1,
            .incr => 2,
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

    pub fn toi(self: *const saph_content_type) u8 {
        return switch (self.*) {
            .plaintext => 0,
            .code_markdown => 1,
            .code_lua => 2,
        };
    }
};

pub fn bytesToU16be(bytes: *const [2]u8) u16 {
    return (@as(u16, bytes.*[0]) << 8) | bytes.*[1];
}

pub fn bytesToU32be(bytes: *const [4]u8) u32 {
    return (@as(u32, bytes.*[0]) << 24) | (@as(u32, bytes.*[1]) << 16) | (@as(u32, bytes.*[2]) << 8) | bytes.*[3];
}
