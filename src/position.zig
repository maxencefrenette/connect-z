const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

pub const Position = struct {
    pub const Width = 7;
    pub const Height = 6;

    board: [Width][Height]u2,
    height: [Width]u8,
    moves: u8,

    pub fn init() Position {
        return Position{
            .board = [_][Height]u2{[_]u2{0} ** Height} ** Width,
            .height = [_]u8{0} ** Width,
            .moves = 0,
        };
    }

    pub fn fromSequence(seq: []const u8) Position {
        var pos = Position.init();

        for (seq) |c| {
            if (c < '1' or '1' + Width <= c) {
                std.debug.warn("Invalid character: #{}#", .{c});
                @panic("Invalid Sequence Error");
            }
            pos.play(c - '1');
        }

        return pos;
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
        const current_player = @truncate(u2, 1 + self.moves % 2);

        if (self.height[col] >= 3 and self.board[col][self.height[col] - 1] == current_player and self.board[col][self.height[col] - 2] == current_player and self.board[col][self.height[col] - 3] == current_player) {
            return true;
        }

        inline for ([_]i8{ -1, 1, 0 }) |dy| {
            var nb: u8 = 0;

            inline for ([_]i8{ -1, 0 }) |dx| {
                var x = @intCast(i8, col) + dx;
                var y = @intCast(i8, self.height[col]) + dx * dy;
                while (x >= 0 and x < Width and y >= 0 and y < Height and self.board[@intCast(u8, x)][@intCast(u8, y)] == current_player) {
                    x = @intCast(i8, x) + dx;
                    y = @intCast(i8, y) + dx * dy;
                    nb += 1;
                }
            }

            if (nb >= 3) return true;
        }

        return false;
    }

    pub fn numMoves(self: @This()) u8 {
        return self.moves;
    }
};

test "start position" {
    _ = Position.init();
}

test "position from sequence" {
    _ = Position.fromSequence("1234567");
}

test "can play" {
    const p = Position.init();
    expect(p.canPlay(0));
}

test "play" {
    var p = Position.init();
    p.play(0);
}

test "start position is not winning move" {
    const p = Position.init();
    expect(p.isWinningMove(0) == false);
}

test "vertical winning move" {
    var p = Position.fromSequence("121212");
    expect(p.isWinningMove(0) == true);
}

test "horizontal winning move" {
    var p = Position.fromSequence("112233");
    expect(p.isWinningMove(3) == true);
}
