const std = @import("std");
const tokens = @import("tokens.zig");
const lexer = @import("lexer.zig");

pub fn main() !void {
    var lexr = lexer.newLexer("(++/--/** (//+***--) (+/** (+)))");
    const toks: std.ArrayList(tokens.Token) = try lexr.lex();

    for (toks.items) |t| {
        std.debug.print("{s}", .{try t.str()});
    }
}
