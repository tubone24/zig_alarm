const std = @import("std");

fn countChars(chars: [*:0]u8) usize {
    var i: usize = 0;
    while (true) {
        if (chars[i] == 0) {
            return i;
        }
        i += 1;
    }
}

fn convertArgToConstU8(slice: [*:0]u8) []const u8 {
    const constU8: []const u8 = slice[0..countChars(slice)];
    return constU8;
}

fn convertArgToU64(slice: [*:0]u8) u64 {
    const constU8: []const u8 = convertArgToConstU8(slice);
    const n: u64 = std.fmt.parseInt(u64, constU8, 10) catch return 0;
    return n;
}

fn convertSeconds(n: u64, unit: []const u8) u64 {
    var seconds: u64 = n;
    if (std.mem.eql(u8, unit, "s") or std.mem.eql(u8, unit, "seconds") or std.mem.eql(u8, unit, "second") or std.mem.eql(u8, unit, "sec")) {
        // pass
    } else if (std.mem.eql(u8, unit, "m") or std.mem.eql(u8, unit, "minutes") or std.mem.eql(u8, unit, "minute") or std.mem.eql(u8, unit, "min")) {
        seconds = seconds * 60;
    } else if (std.mem.eql(u8, unit, "h") or std.mem.eql(u8, unit, "hours") or std.mem.eql(u8, unit, "hour") or std.mem.eql(u8, unit, "hrs")) {
        seconds = seconds * 60 * 60;
    } else if (std.mem.eql(u8, unit, "d") or std.mem.eql(u8, unit, "days") or std.mem.eql(u8, unit, "day")) {
        seconds = seconds * 60 * 60 * 24;
    }
    return seconds;
}

pub fn main() !void {
    const args: [][*:0]u8 = std.os.argv;
    var unit: []const u8 = undefined;

    if (args.len < 2) {
        @panic("need number");
    } else if (args.len < 3) {
        unit = "s";
    } else {
        const arg2: [*:0]u8 = args[2];
        unit = convertArgToConstU8(arg2);
    }
    const arg1: [*:0]u8 = args[1];

    if (std.mem.eql(u8, convertArgToConstU8(arg1), "help") or std.mem.eql(u8, convertArgToConstU8(arg1), "-h") or std.mem.eql(u8, convertArgToConstU8(arg1), "--help")) {
        std.debug.print("{s}\n\n{s}\n\n{s}\n\n{s}\n\n{s}\n", .{ "Usage: zig_alarm <int> [unit]", "Commands: ", "  int     Integer you want to measure (default: seconds)\n  unit    unit for integer such as sec, min, hrs, day", "General Options:", "  -h, --help       Print command-specific usage" });
        return;
    }

    const n: u64 = convertArgToU64(arg1);
    std.debug.print("Start Timer {d}{s}\n", .{ n, unit });
    const seconds = convertSeconds(n, unit);
    std.log.info("{d} seconds", .{seconds});
    var t = try std.time.Timer.start();
    std.time.sleep(std.time.ns_per_s * seconds);
    std.debug.print("{}\n", .{std.fmt.fmtDuration(t.read())});
}

test "convertSeconds: sec to sec" {
    const actual: u64 = 20;
    try std.testing.expect(convertSeconds(actual, "s") == 20);
}

test "convertSeconds: min to sec" {
    const actual: u64 = 20;
    try std.testing.expect(convertSeconds(actual, "m") == 1200);
}

test "convertSeconds: hrs to sec" {
    const actual: u64 = 20;
    try std.testing.expect(convertSeconds(actual, "h") == 72000);
}

test "convertSeconds: day to sec" {
    const actual: u64 = 20;
    try std.testing.expect(convertSeconds(actual, "d") == 1728000);
}
