const std = @import("std");
const expect = std.testing.expect;
const parseInt = std.fmt.parseInt;
const Position = @import("position.zig").Position;
const Solver = @import("solver.zig").Solver;

pub fn main() !void {
    const stdin = std.io.getStdIn().inStream();
    const stdout = std.io.getStdOut().outStream();
    var buf: [100]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |line| {
        const seq = trimEol(line);
        var position = Position.fromSequence(seq);
        var solver = Solver.init();
        const score = solver.solve(position);

        try stdout.print("{} {} {} {}\n", .{ seq, score, solver.nodes_explored, "1000" });
    }
}

fn trimEol(line: []const u8) []const u8 {
    var s = line;
    if (s[s.len - 1] == '\n') s = s[0 .. s.len - 1];
    if (s[s.len - 1] == '\r') s = s[0 .. s.len - 1];
    return s;
}

test "connect-z" {
    _ = @import("position.zig");
    _ = @import("solver.zig");
}

test "trim eol \\n" {
    expect(std.mem.eql(u8, trimEol("foo\n"), "foo"));
}

test "trim eol \\r\\n" {
    expect(std.mem.eql(u8, trimEol("foo\r\n"), "foo"));
}
