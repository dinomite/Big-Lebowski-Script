open(FH, '<', 'big.lebowski.html') or die $!;

$dialogRegex = qr/^ {25}[^ ]/;
$style = "
<style>
    body { width: 30em }
    p { width: 25em }
    blockquote { width: 20em }
</style>
";

$count = 0;
$blockquote = 0;
while (<FH>) {
    if (m#</HEAD>#) {
        print $style;
    }

    if (/^ {15}[A-Z][ :A-Z']+$/) {
        # Scene title
        s/^ +//;
        s/^/<a href='#$count'>/;
        s/$/<\/a>/;

        chomp $_;
        print "<h2>$_</h2>\n";

        $count++;
    } elsif ($blockquote == 0 && /^ {37}[^ ]/) {
        # Character dialog
        s/^ +//;
        chomp $_;
        print "<b>$_</b>\n";
    } elsif ($blockquote == 0 && $_ =~ $dialogRegex) {
        # Start of a dialog section
        print "<blockquote>\n";
        print $_;

        $blockquote = 1;
    } elsif ($blockquote == 1 && $_ !~ $dialogRegex) {
        # End of a dialog section
        print "</blockquote>\n";
        print $_;

        $blockquote = 0;
    } elsif (/^$/) {
        print "</p>\n\n<p>\n";
        print $_;
    } else {
        print $_;
    }
}
