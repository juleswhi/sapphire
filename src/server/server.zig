const std = @import("std");

const s_err = @import("server_error.zig").server_error;

const net = std.net;
const pr = std.debug.print;

pub fn start() !void {
    pr("INFO: Starting Server..\n", .{});

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

    pr("Listening on: {}\n", .{addy.getPort()});

    while (true) {
        var client = try server.accept();
        pr("Connection received from: {}: handling.\n", .{client.address});

        handle_conn(&client.stream, &allocator) catch {
            pr("Error occured", .{});
            continue;
        };
    }
}

fn handle_conn(stream: *std.net.Stream, alloc: *const std.mem.Allocator) !void {
    defer stream.close();

    const message = try stream.reader().readAllAlloc(alloc.*, 1024);
    defer alloc.*.free(message);

    pr("Message received: {s}\n", .{message});
}
