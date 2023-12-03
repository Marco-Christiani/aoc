const std = @import("std");
const gpa = std.heap.GeneralPurposeAllocator(.{}){};
const alloc = gpa.allocator();

pub fn day1() void {
    var data = @embedFile("day1.txt");
    // var data =
    //     \\1abc2
    //     \\pqr3stu8vwx
    //     \\a1b2c3d4e5f
    //     \\treb7uchet
    // ;
    var data_iter = std.mem.tokenizeScalar(u8, data, '\n');
    var i: usize = 0;
    var sum: i32 = 0;
    while (data_iter.next()) |line| : (i += 1) {
        var first_num: i32 = -1;
        var last_num: i32 = -1;
        // find first number
        for (line) |char| {
            if (std.ascii.isDigit(char)) {
                first_num = @as(i32, char) - @as(i32, '0');
                break;
            }
        }
        for (line, 0..) |_, k| {
            var char = line[line.len - k - 1];
            if (std.ascii.isDigit(char)) {
                // last_num = @as(char, i32) - @as('0', i32);
                last_num = @as(i32, char) - @as(i32, '0');
                break;
            }
        }
        if (first_num < 0 and last_num < 0) {
            @panic("AHHHHHHH");
        }
        if (first_num < 0 and last_num > 0) {
            first_num = last_num;
        }
        if (last_num < 0 and first_num > 0) {
            last_num = first_num;
        }
        var row_number = 10 * first_num + last_num;
        sum += row_number;
        std.debug.print("({d}) {d} {d}\n", .{ sum, first_num, last_num });
    }
    std.debug.print("total sum: {d}\n", .{sum});
}

// Checks if something spells out a number
// If it does, returns the value of the number, otherwise null
pub fn day1p2_str_to_value(something: []const u8) ?usize {
    const nums = [_][]const u8{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    return for (nums, 0..) |num, i| {
        if (std.mem.startsWith(u8, something, num)) {
            return i;
        }
        if (std.mem.endsWith(u8, something, num)) {
            return i;
        }
    } else null;
}

pub fn day1p2() void {
    var data = @embedFile("day1.txt");
    // const data =
    //     \\two1nine
    //     \\eightwothree
    //     \\abcone2threexyz
    //     \\xtwone3four
    //     \\4nineeightseven2
    //     \\zoneight234
    //     \\7pqrstsixteen
    // ;
    var data_iter = std.mem.tokenizeScalar(u8, data, '\n');
    var sum: usize = 0;
    var i: usize = 0;
    while (data_iter.next()) |line| : (i += 1) {
        var first_num: usize = undefined;
        for (line, 0..) |char, j| {
            const substr = line[0..j];
            std.debug.print("{s}\n", .{substr});
            var maybe_num = day1p2_str_to_value(substr);
            if (maybe_num != null) {
                first_num = maybe_num.?;
                break;
            } else if (std.ascii.isDigit(char)) {
                first_num = @as(usize, char) - @as(usize, '0');
                break;
            }
        }
        var last_num: usize = undefined;
        for (line, 0..) |_, j| {
            const char = line[line.len - 1 - j];
            const substr = line[line.len - 1 - j .. line.len];
            var maybe_num = day1p2_str_to_value(substr);
            if (maybe_num != null) {
                last_num = maybe_num.?;
                break;
            } else if (std.ascii.isDigit(char)) {
                last_num = @as(usize, char) - @as(usize, '0');
                break;
            }
        }
        // std.debug.print("{d}: {?d} {?d}\n", .{ i, first_num, last_num });
        var row_number = 10 * first_num + last_num;
        sum += row_number;
        std.debug.print("({d}) {d} {d}\n", .{ sum, first_num, last_num });
    }
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "day 1" {
    day1();
    day1p2();
}
