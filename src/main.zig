const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var alloc = gpa.allocator();

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

pub fn day2() !void {
    // const data =
    //     \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    //     \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    //     \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    //     \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    //     \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    // ;
    const data = @embedFile("day2.txt");
    const max_red = 12;
    const max_green = 13;
    const max_blue = 14;
    var sum: usize = 0;
    var games_iter = std.mem.tokenizeScalar(u8, data, '\n');
    while (games_iter.next()) |game| {
        var game_and_draw_iter = std.mem.tokenizeSequence(u8, game, ": ");
        var game_id_iter = std.mem.tokenizeScalar(u8, game_and_draw_iter.next().?, ' ');
        _ = game_id_iter.next();
        var game_id = try std.fmt.parseInt(usize, game_id_iter.next().?, 10);
        var draws = std.mem.tokenizeSequence(u8, game_and_draw_iter.next().?, "; ");
        var possible: bool = true;
        while (draws.next()) |draw| {
            var cube_iter = std.mem.tokenizeSequence(u8, draw, ", ");
            while (cube_iter.next()) |cube| {
                var item_iter = std.mem.tokenizeScalar(u8, cube, ' ');
                const count_str = item_iter.next();
                const color = item_iter.next();
                const count = try std.fmt.parseInt(usize, count_str.?, 10);
                if (std.mem.eql(u8, color.?, "red")) {
                    if (count > max_red) possible = false;
                } else if (std.mem.eql(u8, color.?, "green")) {
                    if (count > max_green) possible = false;
                } else if (std.mem.eql(u8, color.?, "blue")) {
                    if (count > max_blue) possible = false;
                }
            }
        }
        if (possible) {
            sum += game_id;
        }
    }
    std.debug.print("part1: {d}\n", .{sum});
    games_iter = std.mem.tokenizeScalar(u8, data, '\n');
    sum = 0;
    while (games_iter.next()) |game| {
        var game_and_draw_iter = std.mem.tokenizeSequence(u8, game, ": ");
        var game_id_iter = std.mem.tokenizeScalar(u8, game_and_draw_iter.next().?, ' ');
        _ = game_id_iter.next();
        var game_id = try std.fmt.parseInt(usize, game_id_iter.next().?, 10);
        _ = game_id;
        var draws = std.mem.tokenizeSequence(u8, game_and_draw_iter.next().?, "; ");
        var min_red: usize = 0;
        var min_green: usize = 0;
        var min_blue: usize = 0;
        while (draws.next()) |draw| {
            var cube_iter = std.mem.tokenizeSequence(u8, draw, ", ");
            while (cube_iter.next()) |cube| {
                var item_iter = std.mem.tokenizeScalar(u8, cube, ' ');
                const count_str = item_iter.next();
                const color = item_iter.next();
                const count = try std.fmt.parseInt(usize, count_str.?, 10);
                if (std.mem.eql(u8, color.?, "red")) {
                    if (count > min_red) min_red = count;
                } else if (std.mem.eql(u8, color.?, "green")) {
                    if (count > min_green) min_green = count;
                } else if (std.mem.eql(u8, color.?, "blue")) {
                    if (count > min_blue) min_blue = count;
                }
            }
        }
        sum += min_red * min_green * min_blue;
    }
    std.debug.print("part2: {d}\n", .{sum});
}

pub fn day3() void {}

fn day4() !f64 {
    const data = @embedFile("day4.txt");
    // const data =
    //     \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    //     \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    //     \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    //     \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    //     \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    //     \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    // ;
    comptime var line_iter = std.mem.tokenizeScalar(u8, data, '\n');
    var i: u32 = 0;
    var total: f64 = 0;
    while (line_iter.next()) |line| : (i += 1) {
        var rest_iter = std.mem.tokenizeSequence(u8, line, ": ");
        _ = rest_iter.next();
        var hand_iter = std.mem.tokenizeScalar(u8, rest_iter.next().?, '|');
        var winning_cards_iter = std.mem.tokenizeScalar(u8, hand_iter.next().?, ' ');
        var my_cards_iter = std.mem.tokenizeScalar(u8, hand_iter.next().?, ' ');
        // var count = count_intersection_iter(u8, &winning_cards_iter, &my_cards_iter);

        var count: u32 = 0;
        var set = std.AutoHashMap(usize, void).init(alloc);
        defer set.deinit();
        while (my_cards_iter.next()) |e| {
            var num = try std.fmt.parseInt(usize, e, 10);
            try set.put(num, {});
        }
        while (winning_cards_iter.next()) |e| {
            var num = try std.fmt.parseInt(usize, e, 10);
            if (set.contains(num)) {
                count += 1;
            }
            try set.put(num, {});
        }
        const score: f32 = switch (count) {
            0 => 0,
            else => @exp2(@as(f32, @floatFromInt(count)) - 1),
        };
        std.debug.print("{d} -> {d}\n", .{ count, score });
        total += score;
    }
    return total;
}

fn day4p2() !u32 {
    const data = @embedFile("day4.txt");
    // const data =
    //     \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    //     \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    //     \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    //     \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    //     \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    //     \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    // ;
    comptime var line_iter = std.mem.tokenizeScalar(u8, data, '\n');
    var i: u32 = 0;
    var total: u64 = 0;
    var scores = std.ArrayList(u32).init(alloc);
    defer scores.deinit();
    while (line_iter.next()) |line| : (i += 1) {
        var rest_iter = std.mem.tokenizeSequence(u8, line, ": ");
        _ = rest_iter.next();
        var hand_iter = std.mem.tokenizeScalar(u8, rest_iter.next().?, '|');
        var winning_cards_iter = std.mem.tokenizeScalar(u8, hand_iter.next().?, ' ');
        var my_cards_iter = std.mem.tokenizeScalar(u8, hand_iter.next().?, ' ');

        var count: u32 = 0;
        var set = std.AutoHashMap(usize, void).init(alloc);
        defer set.deinit();
        while (my_cards_iter.next()) |e| {
            var num = try std.fmt.parseInt(usize, e, 10);
            try set.put(num, {});
        }
        while (winning_cards_iter.next()) |e| {
            var num = try std.fmt.parseInt(usize, e, 10);
            if (set.contains(num)) {
                count += 1;
            }
            try set.put(num, {});
        }

        try scores.append(count);
        total += count;
    }
    std.debug.print("{d}\n", .{total});
    // iterate a second time, add up number of cards
    var score_slice = try scores.toOwnedSlice();
    var temp = try std.BoundedArray(u32, 256).init(score_slice.len);
    var card_counts = temp.slice();

    for (card_counts, 0..) |_, k| {
        card_counts[k] = 1;
    }
    var total_cards: u32 = @intCast(score_slice.len);
    line_iter.reset();
    i = 0;
    std.debug.print("{d}\n", .{score_slice});
    std.debug.print("total_cards={d}\n", .{total_cards});
    while (line_iter.next()) |_| : (i += 1) {
        var start_idx = i + 1;
        var end_idx = i + score_slice[i] + 1;
        var len: u32 = @intCast(end_idx);
        if (end_idx > len) {
            end_idx = len;
        }
        if (start_idx > len) {
            start_idx = len;
        }
        for (start_idx..end_idx) |m| {
            card_counts[m] += card_counts[i];
        }

        std.debug.print("score: {d}\n", .{score_slice[i]});

        for (card_counts, 0..) |value, j| {
            std.debug.print("\t{d}:{d}\n", .{ j, value });
        }
    }
    total_cards = sum_slice(card_counts);
    return total_cards;
}

fn sum_slice(slice: []u32) u32 {
    var total: u32 = 0;
    for (slice) |s| {
        total += s;
    }
    return total;
}

fn iter_to_buffer(comptime T: type, buffer: [][]const T, iter: *std.mem.TokenIterator(T, .scalar)) void {
    var i: usize = 0; // heap who?
    while (iter.next()) |item| : (i += 1) {
        if (i >= buffer.len) break; // Prevent buffer overflow
        buffer[i] = item;
    }
}

fn count_intersection_iter(comptime T: type, iter1: *std.mem.TokenIterator(T, .scalar), iter2: *std.mem.TokenIterator(T, .scalar)) std.mem.Allocator.Error!usize {
    var result: usize = 0;
    var set = std.AutoHashMap([]const T, void).init(alloc);
    defer set.deinit();
    while (iter1.next()) |e| try set.put(e, {});
    while (iter2.next()) |e| {
        if (set.contains(e)) {
            result += 1;
        }
        try set.put(e, {});
    }
    return result;
}

fn count_intersection_arr(comptime T: type, comptime arr1: []const T, comptime arr2: []const T) std.mem.Allocator.Error!usize {
    var result: usize = 0;
    var set = std.AutoHashMap(T, void).init(alloc);
    defer set.deinit();
    for (arr1) |e| try set.put(e, {});
    for (arr2) |e| {
        if (set.contains(e)) {
            result += 1;
        }
        try set.put(e, {});
    }
    return result;
}

test "day 1" {
    day1();
    day1p2();
}

test "day 2" {
    try day2();
}

test "day 4" {
    const part1: u32 = try day4();
    const part2: u32 = try day4p2();
    std.debug.print("part1: {d}\n", .{part1});
    std.debug.print("part2: {d}\n", .{part2});
}

test "count intersection" {
    const count = try count_intersection_arr(usize, &[_]usize{ 1, 2, 3 }, &[_]usize{ 1, 2, 3 });
    std.debug.print("{d}\n", .{count});
}
