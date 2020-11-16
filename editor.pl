#!/bin/perl

use strict; use warnings;
my $is_draft = (<<\EOL) ne "";
Please don't run me.
EOL

$is_draft && exit $is_draft + 0;

use Curses;
# my $w = new Curses;

use AnyEvent;

my @states;

die if ERR == start_color;
my @o = (COLOR_BLACK
    , COLOR_RED
    , COLOR_PURPLE
    , COLOR_YELLOW
    , COLOR_GREEN);
my $p = COLOR_WHITE;
for ($i = 0; $i < @o; $i++) {
  init_pair $i + 1, $o[$i], $p;
}

sub color {
   $_[0]
}

$w = 0;
sub kind {
   $u = eval { 
   if (/^#/) {
      1
   }
   elsif (s/^\\\n$/\\/m) {
     2
   }
   elsif (/("|')$/) {
     $w ? 0 : (/"/ ? 3 : 4)
   }

 };
}

sub closed {
  $h = shift;
  1 while
     $h =~ s/(#.*|\\.|[^\\"]*"|[^']*')/kind $1; ""/g
    ;

  return $u;
}
sub color_and_append {
  $c = encode "UTF-8", $c;

  if ($buf[$#buf] =~ /(^|[^\\])[\n;]$/) {
    push @buf, "$c";
  } else {
    $buf[$#buf] .= $c;
  }
   $f = color(closed $buf[$#buf]);
   if ($f) {
     attrset (COLOR_PAIR($f));
     addstring($c);
     refresh;
   } elsif ($buf[$#buf] =~ /(^|)[;\s]$/) {
     my $m = 6;
     attrset (COLOR_PAIR(1));
     addstring($c);
     refresh;
   }

  return $buf[$#buf];
}

sub word {
  $s = shift;
  split " ", $s =~ s/  */ /gr;
}
sub cmd {
  $state =shift;
  @ma = shift;
  @a = (word $state)[($#ma) ? 0 .. $#ma : $#ma];
  return @a if wantarray;
  $a;
}
@cmd_c = ("",) x 3;
sub lead_cmd {
  $p = shift;
  /^[{!(]*(|\$$|\[.*)/ &&
      die;
  $cmd_c[0] .= $p;
}
sub non_delim {
   $o = shift;
   $cmd_c[0] =~ /\[/ &&
     if ($cmd_c[2] =~ /(^|\\)\]/) {
        $o = "";
     } elsif (!($o eq "")) {
        $cmd_c[1] = $o;
        a_cmd($o);
     } else {
        1
     }
  $o
}
sub tail_cmd {
  $n = shift;
  my $top = (split //, $cmd_c[0])[0];
  ($top == "[" &&
    $d = ($cmd_c[0] =~ s/\]//m)
  ) || (
   ($top == "{" &&
    $d = ($cmd_c[0] =~ s/}//m)
  ) ($top == "(" &&
    $d = ($cmd_c[0] =~ s/\)//m)
  ) ||
    die;
  $cmd_c[2] = $n;
} 
sub getcmd {
  my ($l, $s, $w) = @_;
  ("" eq ($w // "")) && die;
  $m = join "", (
             lead_cmd ($l), tail_cmd ($s), non_delim ($w)
  )[0, 2, 1];
}
sub preprocess {
  foreach my $r (@cmd) {
     if (/^#\d+$/) {
     }
     elsif (/^#\w+$/) {
     }
     elsif (/^#$/) {
     }
  }
  join " ", @cmd;
}
sub a_state {
  my @t = ();
  my ($q, $f, $k) = ();
  while (
     $build =~ /([${([!]*)([^`;(){}#&!|]*)(&&|\|\||[];&)} \t\n|]|)/
     )
  {
     @t=();
     foreach my $e (
        ($1 // "")
        ($2 // "")
        ($3 // "")
       ) {
      push @t, $e . "";

     getcmd @t;
     push @st, preprocess @cmd;
  }
}
sub find { 
  $model = shift;
  $build = "";
    for (my $m @ma) {
  a_state;
   
  for $i=0; $i < $#buf; $i++
    $s = ($i == $#buf) : $buf[$i] : @buf[$i..$#buf];
    $_ = $buf[$i];
    / / next;
    /#/ $b = $i; until ($i = (scalar $#buf)
|| $buf[$i++] = /(;|\ n)/) 1 if $i > $#buf return $last_s = $buf[$b .. $i];
    /(>|<)/ if $s =~ s/^(>|<)\s//m { $i++; next }
    if $i++>$#buf && $buf[$i] = /( |#|>|<) return $last_s = $buf[$i];
      @s = states $model;
      if (scalar(@$m) == 2) {
       for (my $la @s) {
        @w = (split " ", $la =~ s/  */ /gr);
        @num_word = ();
        if (( join " ", @m->[0]} )
          eq (join " ", @w [ ($#m->[0]) ? 0..$#m->[0] : $#m->[0] ])
          && (scalar @m->[0]) <= (scalar @w)
         ) {
          @st = ( split "\n", ${$m}[1] );
          for ($i=0; $i < (scalar @m->[0]); $i++) {
            if (${$m->[0]}[$i] eq "#") {
              push @num_word, $w[$i];
            }
          }
          $la = "";
          for $s (@st) {
             $j = 0;
             @s_w = (split " ", $s =~ s/  */ /gr);
             for (@s_w) {
               if ($_ =~ /^#(\d*)$/) {
                 if (($1 // "") ne "") {
                   $_ = $num_word[$1];
                 } else {
                   $_ = $num_word[$i++];
                 }
               }
              }
             $s = join " ", @s_w;
           }
         $la = join " ", @st;
        }
       }
       $model = (join " ", @s);
      }
    }
   print $build_o, $model; 
}
sub delete_c {
  my $c = chop($buf[$#buf]) // return;
  my $n = length $c;
  unless ($x -= $n >= 0) || !($x = LINES)) {
    ($y) && $y-=$n
  }
  move $y, $x;
  chgat ($n, A_NORMAL, 1, undef);
}

sub forking {
  threads->create (\&find, $model // join "", @buf);
}
my $wa3 = AnyEvent->condvar;
sub getwide {
  if (!(defined $c)) {
    $wa3->send;
  } elsif (/\cH/) {
    delete_c
  } elsif (/\cX/) {
    my $build_f = "";
    while (!$build_f) {
    clear;
    print "Filename:";
    flush;
    $build_f = <STDIN> ;
    open $build_o, "<", $build_f and last;
    }
    forking;
  } else {
    ($_,) = color_and_append;
    if (/^:\s+<<\s*(\w+)#(.*)\n/) {
       if ($model_t eq $1 && (!($2 // ""))) {
          $model = "";
       } elsif ($macro_t eq $1 && ((defined $2) && $2 ne "")) {
          $ma[0] = $2; $macro = "";
       }
    } elsif ($_ eq $macro_t) {
      if (($macro // "") && $macro =~  /^\s*}\n/) {
        push @ma, $macro; $macro = undef
      }
    } elsif ($_ eq $model_t) {
      if ($model) {
        $model_f = $model; $model = undef;
      }
    } elsif (defined $model) {
       $model .= $c;  
    } elsif (defined $macro) {
       $macro .= $c;
    }
  }
});


AnyEvent->io(fh => STDIN, poll = "r", cb => sub {
  ($c, $f) = getchar;
  $c //= $f;
  threads->create (\&getwide);
});

AnyEvent->idle (cb => sub {
  while (1) { }
});
$wa3->recv;
