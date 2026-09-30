#!/bin/bash
# box-empty.sh [--machine M] PANE
# box-empty.sh - < screen     when the screen is already captured
# Exit 0: the prompt box is empty; you may type.
# Exit 1: someone typed in the box.
# Exit 2: unknown; do not type (failed read, no prompt box, another composer, a dialog).
# Dim text (ESC[2m) is a suggestion, not typed text, so it is dropped.
set -o pipefail
m=()
if [ "$1" = --machine ]; then
  m=(--machine "$2")
  shift 2
fi
if [ -z "$1" ]; then
  echo "usage: box-empty.sh [--machine M] PANE" >&2
  exit 2
fi
if [ "$1" = - ]; then
  screen=$(cat) || exit 2
else
  if ! command -v herdr >/dev/null 2>&1; then
    echo "herdr is not installed; pass a screen on stdin with: box-empty.sh -" >&2
    exit 2
  fi
  screen=$(herdr "${m[@]}" pane read "$1" --source visible --format ansi 2>/dev/null) || exit 2
fi
[ -n "$screen" ] || exit 2
printf '%s' "$screen" | perl -CSD -e '
  my @l = map { s/\r//gr } split /\n/, do { local $/; <STDIN> };
  sub plain { my $s = shift;
    $s =~ s/\e\[7m[^\e]*\e\[0m(?=\e\[2m)//g;
    $s =~ s/\e\[2m.*?(?:\e\[0m|\e\[22m|$)//g;
    $s =~ s/\e\[[0-9;?]*[A-Za-z]//g; $s =~ s/\x{a0}/ /g; return $s }
  sub trimmed { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s }
  my $border = qr/^\s*[\x{2500}\x{2501}]{8,}\s*$/;
  my ($i) = grep { $l[$_] =~ /\x{276f}/ } reverse 0..$#l;
  exit 2 unless defined $i && $i > 0;
  my $top = plain($l[$i-1]);
  exit 2 unless $top =~ $border;
  my $width = length(trimmed($top));
  my ($below) = grep { my $p = plain($l[$_]); $p =~ $border && abs(length(trimmed($p)) - $width) <= 2 }
                reverse grep { $_ <= $#l } $i+1 .. $i+11;
  exit 2 unless defined $below;
  my $first = plain($l[$i]);
  exit 2 unless $first =~ /\x{276f}/;
  my $typed = (split /\x{276f}/, $first, 2)[1] . join("", map { plain($l[$_]) } $i+1 .. $below-1);
  $typed =~ s/\s+//g;
  exit(length($typed) ? 1 : 0)'
