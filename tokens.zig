const std = @import("std");

pub const TokenTypes = enum(u16) { plus, hyphen, asterisk, forward_slash, opening_paren, closing_paren };

pub const Token = struct {
    type: TokenTypes,
    lit: []const u8,
    start: u64,
    end: u64,
    ln: u64,
    pub fn istype(self: Token, _type: TokenTypes) bool {
        return self.type == _type;
    }
    pub fn islit(self: Token, lit: []const u8) bool {
        return self.lit == lit;
    }
    pub fn str(self: Token) std.fmt.AllocPrintError![]u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "Token[{any}, {s}, {d}..{d}, {d}]\n", .{ self.type, self.lit, self.start, self.end, self.ln });
    }
};

pub fn newToken(_type: TokenTypes, lit: []const u8, start: u32, end: u32, ln: u32) Token {
    return .{ .type = _type, .lit = lit, .start = start, .end = end, .ln = ln };
}
