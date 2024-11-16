const std = @import("std");
const ArrayList = std.ArrayList;
const AllocatorError = std.mem.Allocator.Error;
const tokens_imp = @import("tokens.zig");
const TokenTypes = tokens_imp.TokenTypes;
const newToken = tokens_imp.newToken;

const LexerError = error{IllegalCharacter} || AllocatorError;

const Lexer = struct {
    text: []const u8,
    idx: i64 = -1,
    ln: usize = 0,
    cchar: ?u8 = null,
    fn advance(self: *Lexer) void {
        self.idx += 1;
        if (self.idx < self.text.len) {
            self.cchar = self.text[@intCast(self.idx)];
        } else {
            self.cchar = null;
        }

        if (self.cchar == '\n') {
            self.ln += 1;
        }
    }

    pub fn lex(self: *Lexer) LexerError!ArrayList(tokens_imp.Token) {
        const allocator = std.heap.page_allocator;
        var tokens = ArrayList(tokens_imp.Token).init(allocator);

        while (self.cchar != null) {
            switch (self.cchar orelse 0) {
                ' ', '\n', '\t' => self.advance(),
                '+' => {
                    try tokens.append(newToken(TokenTypes.plus, &[_]u8{self.cchar.?}, @intCast(self.idx), @intCast(self.idx), @intCast(self.ln)));
                    self.advance();
                },
                '-' => {
                    try tokens.append(newToken(TokenTypes.hyphen, &[_]u8{self.cchar.?}, @intCast(self.idx), @intCast(self.idx), @intCast(self.ln)));
                    self.advance();
                },
                '*' => {
                    try tokens.append(newToken(TokenTypes.asterisk, &[_]u8{self.cchar.?}, @intCast(self.idx), @intCast(self.idx), @intCast(self.ln)));
                    self.advance();
                },
                '/' => {
                    try tokens.append(newToken(TokenTypes.forward_slash, &[_]u8{self.cchar.?}, @intCast(self.idx), @intCast(self.idx), @intCast(self.ln)));
                    self.advance();
                },
                '(' => {
                    try tokens.append(newToken(TokenTypes.opening_paren, &[_]u8{self.cchar.?}, @intCast(self.idx), @intCast(self.idx), @intCast(self.ln)));
                    self.advance();
                },
                ')' => {
                    try tokens.append(newToken(TokenTypes.closing_paren, &[_]u8{self.cchar.?}, @intCast(self.idx), @intCast(self.idx), @intCast(self.ln)));
                    self.advance();
                },
                else => return LexerError.IllegalCharacter,
            }
        }

        return tokens;
    }
};

pub fn newLexer(text: []const u8) Lexer {
    var l = Lexer{ .text = text };
    l.advance();
    return l;
}
