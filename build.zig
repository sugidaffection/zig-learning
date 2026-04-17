const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Global test step
    const test_step = b.step("test", "Run all tests in the workspace");

    // --- Automatic Project Discovery ---
    // This block automatically finds every folder in projects/ and adds it as a build target.
    var projects_dir = std.fs.cwd().openDir("projects", .{ .iterate = true }) catch return;
    defer projects_dir.close();

    var iter = projects_dir.iterate();
    while (iter.next() catch null) |entry| {
        if (entry.kind == .directory) {
            const project_name = entry.name;
            
            // Generate the path to main.zig
            // We use b.dupe to ensure the string length is managed by the build allocator
            const project_path = std.fmt.allocPrint(b.allocator, "projects/{s}/main.zig", .{project_name}) catch continue;

            // Check if main.zig actually exists in that folder
            projects_dir.access(std.fmt.allocPrint(b.allocator, "{s}/main.zig", .{project_name}) catch continue, .{}) catch continue;

            // Add the project
            addProject(b, target, optimize, test_step, project_name, project_path);
        }
    }
}

fn addProject(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    global_test_step: *std.Build.Step,
    name: []const u8,
    path: []const u8,
) void {
    const exe = b.addExecutable(.{
        .name = name,
        .root_module = b.createModule(.{
            .root_source_file = b.path(path),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    // Allows users to run 'zig build <folder_name>'
    const run_step = b.step(name, b.fmt("Run {s}", .{name}));
    run_step.dependOn(&run_cmd.step);

    // Add a test step for each project
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step_name = b.fmt("test-{s}", .{name});
    const test_step = b.step(test_step_name, b.fmt("Run tests for {s}", .{name}));
    test_step.dependOn(&run_exe_tests.step);

    // Link it to the global 'zig build test' command
    global_test_step.dependOn(&run_exe_tests.step);
}
