const std = @import("std");

fn print(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt, args);
}

fn println(comptime fmt: []const u8, args: anytype) void {
    std.debug.print(fmt ++ "\n", args);
}

fn input(prompt: []const u8, allocator: std.mem.Allocator) ![]u8 {
    print("{s}", .{prompt});

    var stdin_buf: [512]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&stdin_buf);
    const reader: *std.Io.Reader = &stdin_reader.interface;

    const line = reader.takeDelimiterExclusive('\n') catch |err| switch (err) {
        error.EndOfStream => return allocator.dupe(u8, ""),
        else => return err,
    };

    const trimmed = std.mem.trim(u8, line, " \r\n\t");
    return allocator.dupe(u8, trimmed);
}

fn inputf64(prompt: []const u8, allocator: std.mem.Allocator) f64 {
    const user_input = input(prompt, allocator) catch {
        println("Invalid input!", .{});
        return 0.0;
    };
    defer allocator.free(user_input);
    return std.fmt.parseFloat(f64, user_input) catch {
        println("Input is not a valid number!", .{});
        return 0.0;
    };
}

const Account = struct {
    balance: f64,
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator) Account {
        return Account{
            .balance = 0.0,
            .allocator = allocator,
        };
    }

    fn deposit(self: *Account) void {
        const deposit_amount = inputf64("Please enter your deposit amount: ", self.allocator);
        if (deposit_amount <= 0.0) {
            println("Deposit amount must be greater than 0!", .{});
            return;
        }
        self.balance += deposit_amount;
    }

    fn withdraw(self: *Account) void {
        const withdraw_amount = inputf64("Please enter your withdraw amount: ", self.allocator);
        if (withdraw_amount <= 0.0) {
            println("Withdraw amount must be greater than 0!", .{});
            return;
        }
        if (self.balance < withdraw_amount) {
            println("Insufficient balance!", .{});
            return;
        }
        self.balance -= withdraw_amount;
    }

    fn checkBalance(self: *Account) void {
        println("My Current Balance: {d:.2}", .{self.balance});
    }
};

const MenuOption = enum(u8) {
    deposit = 1,
    withdraw = 2,
    check_balance = 3,
    exit = 4,
};

fn inputMenu(prompt: []const u8, allocator: std.mem.Allocator) MenuOption {
    while (true) {
        const user_input = input(prompt, allocator) catch {
            println("Invalid input!", .{});
            continue;
        };
        defer allocator.free(user_input);
        const val = std.fmt.parseInt(u8, user_input, 10) catch {
            println("Input is not a valid number!", .{});
            continue;
        };

        if (val < 1 or val > 4) {
            println("Invalid choice!", .{});
            continue;
        }

        return @enumFromInt(val);
    }
}

pub fn main() !void {
    println("Welcome to the Bank!", .{});

    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var account = Account.init(allocator);

    while (true) {
        println("\nMenu:", .{});
        println("1. Deposit", .{});
        println("2. Withdraw", .{});
        println("3. Check Balance", .{});
        println("4. Exit", .{});

        const choice = inputMenu("\nPlease enter your choice: ", allocator);

        switch (choice) {
            .deposit => account.deposit(),
            .withdraw => account.withdraw(),
            .check_balance => account.checkBalance(),
            .exit => break,
        }
    }
}
