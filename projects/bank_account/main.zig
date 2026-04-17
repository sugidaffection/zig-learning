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

fn inputInt(prompt: []const u8, allocator: std.mem.Allocator) u8 {
    const user_input = input(prompt, allocator) catch {
        println("Invalid input!", .{});
        return 0;
    };
    defer allocator.free(user_input);
    return std.fmt.parseInt(u8, user_input, 10) catch {
        println("Input is not a valid number!", .{});
        return 0;
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
        self.balance += deposit_amount;
    }

    fn withdraw(self: *Account) void {
        const withdraw_amount = inputf64("Please enter your withdraw amount: ", self.allocator);
        if (self.balance < withdraw_amount) {
            println("Insufficient balance!", .{});
            return;
        }
        self.balance -= withdraw_amount;
    }

    fn checkBalance(self: *Account) void {
        println("My Current Balance: {d}", .{self.balance});
    }
};

const MenuOption = enum {
    deposit,
    withdraw,
    check_balance,
    exit,
};

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

        const choice = inputInt("\nPlease enter your choice: ", allocator);

        switch (choice) {
            1 => account.deposit(),
            2 => account.withdraw(),
            3 => account.checkBalance(),
            4 => break,
            else => {
                println("\nInvalid choice!", .{});
                std.Thread.sleep(1 * std.time.ns_per_s);
            },
        }
    }
}
