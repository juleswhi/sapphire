pub const md_header_type = enum {
    HeaderOne,
    HeaderTwo,
    HeaderThree,
    HeaderFour,
};

pub const md_header = struct {
    header: md_header_type,
    data: []const u8,

    pub fn to_header(s: []const u8) ?md_header {
        var hash_count: u8 = 0;
        var data: []const u8 = undefined;
        var idx: u8 = 0;
        for (s) |ch| {
            if (ch == '#') {
                hash_count += 1;
            } else {
                data = s[idx..];
                break;
            }
            idx += 1;
        }

        if (hash_count == 0) {
            return null;
        }

        return md_header{
            .header = switch (hash_count) {
                1 => md_header_type.HeaderOne,
                2 => md_header_type.HeaderTwo,
                3 => md_header_type.HeaderThree,
                else => md_header_type.HeaderFour,
            },
            .data = data,
        };
    }
};
