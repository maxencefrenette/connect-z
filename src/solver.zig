const std = @import("std");
const expect = std.testing.expect;
const mem = @import("std").mem;
const Position = @import("position.zig").Position;

pub const Solver = struct {
    const MinScore = @divTrunc(-Position.Width * Position.Height, 2);
    const MaxScore = @divTrunc(Position.Width * Position.Height, 2);

    nodes_explored: u64,
    column_order: [Position.Width]i8,

    pub fn init() Solver {
        // initialize the column exploration order, starting with center columns
        var column_order: [Position.Width]i8 = undefined;
        var i: u7 = 0;
        while (i < Position.Width) : (i += 1) {
            const i_i8: i8 = i;
            const i_mod2: i8 = i % 2;
            column_order[i] = Position.Width / 2 + (1 - 2 * i_mod2) * @divTrunc(i_i8 + 1, 2);
        }

        return Solver{ .nodes_explored = 0, .column_order = column_order };
    }

    pub fn negamax(self: *@This(), p: Position, alpha_arg: i8, beta_arg: i8) i8 {
        var alpha = alpha_arg;
        var beta = beta_arg;

        std.debug.assert(alpha < beta);
        self.nodes_explored += 1;

        // Check for draw game
        if (p.numMoves() == Position.Width * Position.Height) return 0;

        // Check if current player can win next move
        var x: u8 = 0;
        while (x < Position.Width) : (x += 1) {
            if (p.canPlay(x) and p.isWinningMove(x))
                return @divTrunc((Position.Width * Position.Height + 1 - @intCast(i8, p.numMoves())), 2);
        }

        // upper bound of our score as we cannot win immediately
        const max: i8 = @divTrunc((Position.Width * Position.Height - 1 - @intCast(i8, p.numMoves())), 2);
        if (beta > max) {
            // there is no need to keep beta above our max possible score.
            beta = max;

            // prune the exploration if the [alpha;beta] window is empty.
            if (alpha >= beta) return beta;
        }

        // Recursively explore the game tree
        x = 0;
        while (x < Position.Width) : (x += 1) {
            const column = @intCast(u8, self.column_order[x]);
            if (p.canPlay(column)) {
                var p2 = p;
                p2.play(column);
                const score = -self.negamax(p2, -beta, -alpha);

                // prune the exploration if we find a possible move better than what we were looking for.
                if (score >= beta) return score;

                // reduce the [alpha;beta] window for next exploration
                if (score > alpha) alpha = score;
            }
        }

        return alpha;
    }

    pub fn solve(self: *@This(), p: Position) i8 {
        self.nodes_explored = 0;
        return self.negamax(p, MinScore, MaxScore);
    }
};

test "win next move" {
    const p = Position.fromSequence("121212");
    var solver = Solver.init();
    expect(solver.solve(p) == 18);
}

test "column order" {
    const s = Solver.init();
    expect(mem.eql(i8, &s.column_order, &[_]i8{ 3, 2, 4, 1, 5, 0, 6 }));
}
