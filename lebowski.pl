#!/usr/bin/env perl
# 2010, Drew Stephens <drew@dinomite.net>
use warnings;
use strict;

open(FH, '<', 'big.lebowski.html') or die $!;

my $dialogRegex = qr/^ {25}[^ ]/;
my $style = "
<style>
    body { width: 30em }
    p { width: 25em }
    blockquote { width: 20em }
</style>
";

my $count = 0;
my $blockquote = 0;
while (my $line = <FH>) {
    if ($line =~ m#</HEAD>#) {
        print $style;
    }

    if ($line =~ /^ {15}[A-Z][ :A-Z']+$/) {
        # Scene title
        $line =~ s/^ +//;
        $line =~ s/^/<a href='#$count' name='$count'>/;
        $line =~ s/$/<\/a>/;

        chomp $line;
        print "<h2>$line</h2>\n";

        $count++;
    } elsif ($blockquote == 0 && $line =~ /^ {37}[^ ]/) {
        # Character dialog
        $line =~ s/^ +//;
        chomp $line;
        print "<b>$line</b>\n";
    } elsif ($blockquote == 0 && $line =~ $dialogRegex) {
        # Start of a dialog section
        print "<blockquote>\n";
        print $line;

        $blockquote = 1;
    } elsif ($blockquote == 1 && $line !~ $dialogRegex) {
        # End of a dialog section
        print "</blockquote>\n";
        print $line;

        $blockquote = 0;
    } elsif ($line =~ /^$/) {
        print "</p>\n\n<p>\n";
        print $line;
    } else {
        print $line;
    }
}
