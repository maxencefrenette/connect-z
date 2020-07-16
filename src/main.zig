const std = @import("std");

pub fn main() !void {
    std.debug.warn("{}", .{std.builtin.mode});

    const stdin = std.io.getStdIn().inStream();
    const stdout = std.io.getStdOut().outStream();
    var buf: [100]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |line| {
        try stdout.print("{}\n", .{line});
    }
}
