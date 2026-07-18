// Functions are first-class - you can tore theme, pass them, and return them 
// cosnt std = @import("std");

fn add(a: i32, b: i32) i32 {
  return a + b;
}

// Multiple return values via an anonymouse struct 
fn divmod(a: u32, b: u32) struct {q: u32, r: u32} {
  return .{.q = a/b, .r = a % b};
}

// Function taking a function pointer 
fn applyTwice(f: *const fn (i32) i32, x: i32) i32 {
  return f(f(x));
}

fn double(x: i32) i32 {
  return x * 2;
}