unit module RW-TEST;

# for local test funcs
#my $debug = True;
my $debug = False;

sub get-desired-file-sizes(Str:D $s, UInt $chars-per-line = 100) returns List is export {
    # input is the desired file size in megabytes or gigabytes
    # file is
    my ($size, $size-modifier, $nlines );

    if $s ~~ /^ (\d+) (<[:i mg]>) $/ {
	$size          = +$0;
	$size-modifier = uc ~$1;
    }
    elsif $s ~~ /^ (\d+) $/ {
	$size          = +$0;
	$size-modifier = 'M';
    }
    else {
	die "FATAL: Unknown desired file size '$s'.";
    }

    #say "DEBUG: sz = '$sz'; sm = '$sm'";
    # need nlines
    if $size-modifier eq 'M' {
	$nlines = $size * 1_000_000 div $chars-per-line;
    }
    elsif $size-modifier eq 'G' {
	$nlines = $size * 1_000_000_000 div $chars-per-line;
    }
    else {
	die "FATAL: Unknown desired file size modifier '$size-modifier'.";
    }

    return $size, $size-modifier, $nlines;

} # get-desired-file-sizes

sub my-date-time() is export {
    my $date = DateTime.now(formatter => {
	    sprintf "%04d-%02d-%02d  %02d:%02d:%05.2f",
	    .year, .month, .day, .hour, .minute, .second});

    return $date;

} # my-date-time

sub my-date-time-stamp(:$short, :$shorter) is export {
    my $date;
    if $short {
	$date = DateTime.now(formatter => {
	# bzr-friendly format (no ':' used)
	sprintf "%04d%02d%02dT%02dh%02dm%02ds",
	.year, .month, .day, .hour, .minute, .second});
    }
    elsif $shorter {
	$date = DateTime.now(formatter => {
	# bzr-friendly format (no ':' used)
	sprintf "%04d-%02d-%02d",
	.year, .month, .day});
    }
    else {
	$date = DateTime.now(formatter => {
				    # bzr-friendly format (no ':' used)
				    sprintf "%04d-%02d-%02dT%02dh%02dm%05.2fs",
				    .year, .month, .day, .hour, .minute, .second});
    }
    return $date;

} # my-date-time-stamp
