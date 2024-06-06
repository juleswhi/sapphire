pub const md_header = @import("md_header_gen.zig").md_header;

pub const md_styles = union(enum) {
    Header: md_header,
    Paragraph: []const u8,
    List: [][]const u8,
    CodeBlock: []const u8,
};
