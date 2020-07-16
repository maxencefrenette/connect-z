const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

pub const Position = struct {
    const Width = 7;
    const Height = 6;

    board: [Width][Height]u2,
    height: [Width]u8,
    moves: u8,

    pub fn start() Position {
        return Position{
            .board = [_][Height]u2{[_]u2{0} ** Height} ** Width,
            .height = [_]u8{0} ** Width,
            .moves = 0,
        };
    }

    pub fn fromSequence(seq: []u8) Position {
        return Position{
            .board = undefined,
            .height = undefined,
            .moves = undefined,
        };
    }

    pub fn canPlay(self: @This(), col: u8) bool {
        return self.height[col] < Height;
    }

    pub fn play(self: *@This(), col: u8) void {
        self.board[col][self.height[col]] = @truncate(u2, 1 + self.moves % 2);
        self.height[col] += 1;
        self.moves += 1;
    }

    pub fn isWinningMove(self: @This(), col: u8) bool {
        unreachable; // TODO
    }

    pub fn moves(self: @This()) u8 {
        return self.moves;
    }
};

test "start position" {
    _ = Position.start();
}

test "position from sequence" {
    _ = Position.fromSequence("");
}

test "can play" {
    const p = Position.start();
    expect(p.canPlay(0));
}

test "play" {
    var p = Position.start();
    p.play(0);
}
