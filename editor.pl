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

sub delim_or_begin {
  my $x = shift;
  my $y = shift;
  my ($z, $w) = "",) x2;
  until ($$x =~ /([A-Za-z_0-9[({`})\]"'#\n=:-+? \t>&<|;]|.)/g) {
    $z = $1 . "";
    if ($z =~ /\w/) { # maybe: A-Za-z_0-9
         if ($w =~ /([^0-9A-Za-z_]|^)([A-Za-z_]|)$/m
             && $z =~ /[0-9]/
           ) {
               ($2 // "") ?
                 $u = 0
                 : $u = 2
               ;
		 } elsif ($w =~ /(([<>]&)|(\$({|))$/m) {
			($2 // "") ?
              $u = 3
                  : (($4 // "") ?
                        $u = 0
                        : $u = 3
                    )
               ;
		 }
         $w .= $z;
         $u == 0 ? $w =~ s/\s(echo|if|case|while|for|in|do|done|test|read|export|set|reset|clear|unset|fi|esac)$/
           $u = 3
         /em
           : 1
         ;
    }
    elsif ($w =~ /(\${|(([<>]|;|\|\||\&\&|\&)\s*))\w+([:=?+-]*)$/m) {
	   if ($1 =~ '${' &&) {
	   if ($z =~ /[=-+?]/) {
          unless ($4 // "") {
           $u = 1;
          } elsif ($4 eq ":") {
             $u = 1;
          }
       }
       } else {
         unless (($4 // "")
            if ( $z =~ /[;\s|]/) {
              $u = 3;
            }
            elsif ( $z =~ /\w/ ) {
              $u = 0;
            }
         }
       }
    }
    if ($z =~ /[\`"]/g) {
       my $t = 1;
       $t += 1 while /([^\\]|^)["\`]/g;
       $u = $t % 2;
       $u = $u ? 2 : 3;
    }
    if ($z =~ /'/g) {
       my $t = 1;
       $t += 1 while /([^\\]|^)["\`]/g;
       $u = $t % 2;
       $u = $u ? 2 : 3;
    }
		  while ($w =~ /([[{(])(.*)([[{(]?)/g) {
                 if ($1 eq '[') {
					unless ($u == 1) {
                    if ($2 =~ /([^\\]|^)\]/m) {
                       $u = 0;
                    }
					}
                 }
                 elsif ($1 eq '{') {
                 	unless ($u =~ /[12]/) {
                    if ($2 =~ /}/m) {
                       $u = 0;
                    }
					}
                 }
                 elsif ($1 eq '(') {
                 	unless ($u =~ /[13]/) {
                    if ($2 =~ /)/m) {
                       $u = 0;
                    }
					}
                 }
		}
    unless (!($u =~ /[145]/)) {
       if ($z =~ /[\n;|&]/) {
		   $u = 0;
       }
    }
  }
  return $u;
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
  my $u = "";
  1 while
     $h =~ s/(#.*|\\.|[^\\"]*"|[^']*')/$u = kind $1; ""/g
    ;

  return $u;
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
  my $build = shift;
  my $ref = shift;
  while (
     $build =~ /([${([!]*)([^`;(){}&!|]*)(&&|\|\||[];&)} \t\n|]|)/g
     )
  {
     @t=();
     foreach my $e (
        ($1 // "")
        ($2 // "")
        ($3 // "")
       ) {
      push @t, $e . "";

      &{$ref} @t;
  }
}
my $buf = ""; my $g = "";
sub color_and_append {
  $c = encode "UTF-8", $c;
  my $u = 1;

#  if ($buf[$#buf] =~ /(^|[^\\])[\n;]$/) {
#    push @buf, "$c";
#  } else {
#    $buf[$#buf] .= $c;
#  }
   a_states sub { @t = @_;
$g = join "", @t;
$u = closed($g);
if ($u) {
  if ($u == 1) {
	if ($g =~ /\n$/m) {
      $u = 1;
	} else {
	  $u += 1;
    }
  }
  elsif ($u =~ /[34]) {
    my $f = "";
#    $g =~ s/(([[{(`])|([]})]))/
#      $u = is_delim \$f, ($2 // $3 // "")
#    /ge;
    $u = delim_or_begin \$f . ($2 // $3 // "");
       while $g =~ /(([[{(`])|([]})]))/#!;
    $u += 1;
  }
}

 attrset (COLOR_PAIR($u));
 addstring($c);
 refresh;
}

  return $g;
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
