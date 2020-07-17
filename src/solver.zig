const std = @import("std");
const expect = std.testing.expect;
const Position = @import("position.zig").Position;

pub const Solver = struct {
    nodes_explored: u64,

    pub fn init() Solver {
        return Solver{ .nodes_explored = 0 };
    }

    pub fn negamax(self: *@This(), p: Position) i8 {
        self.nodes_explored += 1;

        // Check for draw game
        if (p.numMoves() == Position.Width * Position.Height) return 0;

        // Check if current player can win next move
        var x: u8 = 0;
        while (x < Position.Width) : (x += 1) {
            if (p.canPlay(x) and p.isWinningMove(x))
                return @divTrunc((Position.Width * Position.Height + 1 - @intCast(i8, p.numMoves())), 2);
        }

        // Recursively explore the game tree
        var best_score: i8 = -Position.Width * Position.Height;
        x = 0;
        while (x < Position.Width) : (x += 1) {
            if (p.canPlay(x)) {
                var p2 = p;
                p2.play(x);
                const score = -self.negamax(p2);
                if (score > best_score) best_score = score;
            }
        }

        return best_score;
    }

    pub fn solve(self: *@This(), p: Position) i8 {
        self.nodes_explored = 0;
        return self.negamax(p);
    }
};

test "win next move" {
    const p = Position.fromSequence("121212");
    var solver = Solver.init();
    expect(solver.solve(p) == 18);
}
