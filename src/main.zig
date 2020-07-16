const std = @import("std");
const Position = @import("position").Position;
const expect = std.testing.expect;

pub fn main() !void {
    std.debug.warn("{}", .{std.builtin.mode});

    const stdin = std.io.getStdIn().inStream();
    const stdout = std.io.getStdOut().outStream();
    var buf: [100]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |line| {
        try stdout.print("{}\n", .{line});
    }
}
