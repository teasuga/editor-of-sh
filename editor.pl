#!/bin/perl

### use Curses;
# my $w = new Curses;

use AnyEvent;

my @states;

my @num = (30 .. 32);

foreach (@num) {
  $_ = sprintf "%s%s\n", $_ - shift, "m";
}

my ($r, $g, $l) = @num;

sub addstring {
  print @_;
}

sub insstring {
  1
}

sub color {
  $c = shift;
  unless (defined $c) {
    return "\e[0m"
  }
  sprintf "\e[0;". $c;
}

$w = 0;
sub kind {
   $u = eval { 
   if (/^("|')/) {
     $w ? 0 : (/"/ ? 3 : 4)
   }
   elsif (/\\\n/) {
     2
   }
   elsif (/^#/) {
      1
   }
 };
}

sub closed {
  $h = shift;
  1 while
     $h =~ s/("[^\\"]*|'[^']*|\\.|#.*)/kind $1; ""/g
    ;

  return $u;
}
sub color_and_append {
  # $c = encode "UTF-8", $c;

  if ($buf[$#buf] =~ /[\n;]/) {
    push @buf, "$c";
  } else {
    $buf[$#buf] .= $c;
  }
   $f = color(closed $buf[$#buf]);
   if ($f) {
     addstring($f)
   } elsif ($buf[$#buf] =~ /[;\s]$/) {
     addstring(color())
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
sub find { 
  $model = shift;
    for (my $m @ma) {
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
  if ($buf[$#buf] =~ /[\n;]$/) {
    1;
  if ($buf[$#buf] =~ /^$/) {
    return
  }

  chop $buf[$#buf];
  print ("\b");
}

my $wa1;
$wa1 = AnyEvent->signal (signal => "CHWIN", cb => sub { insstring(0, 0, $states[$#states]); }
);

my $wa;
$wa = AnyEvent->signal (signal => "INT", cb => sub { undef $wa; undef $wa1;
 exit; }
);

sub fork {
  threads->create (\&find, $model);
}
my $wa2 = AnyEvent->condvar;
$wa2->cb (sub {
  if (!(defined $c)) {
    exit
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


AnyEvent->io(fh => STDIN, cb => sub {
  $c = eval {
  local $/ = undef; # getting wide-char?
  my $c = <STDIN>;
  };
  $wa2->send;
});

AnyEvent::loop();
