#!/usr/bin/env perl6

# notes:
#   a run on juvat2 (2016-01-31) with 10 Gb input file was 22m25s
#   a run on bigtom (2016-01-31) with 10 Gb input file was 23m11s
#   the time for 'wc' on juvat2 was 1m57s
#   the time for 'wc' on bigtom was 1m30s

my $prog = $*PROGRAM.basename;
if !@*ARGS.elems {
  say "Usage: $prog <input file> [lines | split | slurp]" ~ "\n";
  say "Options:";
  say "  lines - uses 'IO.lines' (default)";
  say "  split - uses 'IO.split(\"\\nl\")'";
  say "  slurp - uses 'IO.slurp'" ~ "\n";
  exit;
}

my $ifil = shift @*ARGS;

die "FATAL: file '$ifil' not found.\n"
    if !$ifil.IO.f;

my $fsiz = $ifil.IO.s;

my $method = shift @*ARGS;
$method = 'lines' if !$method;
if $method ~~ /^li/ {
  $method = 'lines';
}
elsif $method ~~ /^sp/ {
  $method = 'split';
}
elsif $method ~~ /^sl/ {
  $method = 'slurp';
}
 
say "  Method: IO.$method";
say "  File '$ifil' size: $fsiz bytes";

my $nlines = 0;
my $nchars = 0;
if $method ~~ /lines/ {
  for $ifil.IO.lines -> $line {
    ++$nlines;
    $nchars += $line.chars;
    #say "line: '$line'";
  }
  # adjust for newlines being removed
  $nchars += $nlines;
}
elsif $method ~~ /slurp/ {
  # suggested by Timo
  my @str = split "\n", $ifil.IO.open.slurp-rest;
  for @str -> $line {
    ++$nlines;
    $nchars += $line.chars;
    #say "line: '$line'";
  }
  # adjust for newlines being removed
  $nchars += $nlines;
}
elsif $method ~~ /split/ {
  # suggested by Liz
  for $ifil.IO.open.split("\n") -> $line {
    ++$nlines;
    $nchars += $line.chars;
    #say "line: '$line'";
  }
  # adjust for newlines being removed
  $nchars += $nlines;
}

say "  Normal end.";
say "  For input file '$ifil':";
say "    Number lines: $nlines";
say "    Number chars: $nchars";
