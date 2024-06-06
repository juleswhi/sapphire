const std = @import("std");
const saph = @import("../protocol/saph_request.zig");

const s_err = @import("server_error.zig").server_error;

const net = std.net;
const print = std.debug.print;

pub fn start() !void {
    print("INFO: Starting Server..\n", .{});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const loopback = try net.Ip4Address.parse("127.0.0.1", 2409);

    const localhost = net.Address{ .in = loopback };
    var server = try localhost.listen(.{
        .reuse_port = true,
    });
    defer server.deinit();

    const addy = server.listen_address;

    print("Listening on: {}\n", .{addy.getPort()});

    while (true) {
        var client = try server.accept();
        handle_conn(&client.stream, &allocator) catch {
            print("Error occured", .{});
            continue;
        };
    }
}

fn handle_conn(stream: *std.net.Stream, alloc: *const std.mem.Allocator) !void {
    defer stream.close();

    // TODO: refactor to read lengths first
    const message = try stream.reader().readAllAlloc(alloc.*, 1024);
    defer alloc.*.free(message);

    const sph = saph.saph_request.from_bytes(&message);
    if (sph) |s| {
        s.report();
    } else {
        std.debug.print("Could not parse the packet\n", .{});
    }
}
