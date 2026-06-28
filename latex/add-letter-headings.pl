#!/usr/bin/env perl
# add-letter-headings.pl
# Post-process index.ain to insert \ailetterheading{X} before each letter group.
# Usage: perl latex/add-letter-headings.pl index.ain
#
# The authorindex Perl script groups entries by first letter and separates them
# with \indexspace, but inserts no letter labels.  This script adds them so the
# author index matches the style of the subject index (bold sans-serif box + rule).
#
# \ailetterheading must be defined in after-body.tex.
#
# Name arguments in index.ain may start with:
#   A-Z         plain letter  (Abbott, Baker, ...)
#   {Letter...} brace-quoted name starting with a letter ({IBM}, {D'Agostino ...})
#   {Digit...}  brace-quoted entry starting with a digit ({6140 Members})
# Only the last case goes under the "0--9" heading.

use strict;
use warnings;

my $file = shift // 'index.ain';

open(my $fh, '<', $file) or die "Cannot open $file: $!\n";
my $text = do { local $/; <$fh> };
close($fh);

$text =~ s/\r\n/\n/g;

# Derive the heading letter from the opening chars of an \item argument.
# $opener is the first 1-2 chars of the argument (e.g. "A", "{I", "{6").
sub heading_letter {
    my ($opener) = @_;
    if    ($opener =~ /^\{([A-Z])/i) { return uc($1) }
    elsif ($opener =~ /^\{/)         { return '0--9'  }
    else                              { return $opener }
}

# Pattern that matches the opening char(s) of an \item argument:
#   [A-Z]       plain capital letter
#   \{[A-Z]     brace + letter  ({IBM}, {D'Agostino ...})
#   \{[^A-Z]    brace + non-letter ({6140 Members})
my $OPENER = qr/([A-Z]|\{.)/;

# First group: entries before the first \indexspace (numeric / brace-quoted entries)
$text =~ s/\\begin\{theauthorindex\}\n((?:%[^\n]*\n)*)\\item\[$OPENER/
    my $letter = heading_letter($2);
    "\\begin{theauthorindex}\n$1\\ailetterheading{$letter}\n\\item[$2"/e;

# Subsequent groups: entries following each \indexspace
$text =~ s/\\indexspace\n((?:%[^\n]*\n)*)\\item\[$OPENER/
    my $letter = heading_letter($2);
    "\\indexspace\n$1\\ailetterheading{$letter}\n\\item[$2"/ge;

open($fh, '>', $file) or die "Cannot write $file: $!\n";
print $fh $text;
close($fh);
