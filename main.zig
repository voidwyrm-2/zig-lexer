const std = @import("std");
const tokens = @import("tokens.zig");
const lexer = @import("lexer.zig");

pub fn main() void {
    var lexr = lexer.newLexer("(++/--/** (//+***--) (+/** (+)))");
    const toks = lexr.lex().items;
    for (toks) |t| {
        t.str();
    }
}
