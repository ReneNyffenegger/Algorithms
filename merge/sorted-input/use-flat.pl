#!/usr/bin/perl
use warnings;
use strict;
use Sort::Merge::Flat;


my @fh_in;

open ($fh_in[0], '<', 'input-files/flat-a') or die;
open ($fh_in[1], '<', 'input-files/flat-b') or die;
open ($fh_in[2], '<', 'input-files/flat-c') or die;
open ($fh_in[3], '<', 'input-files/flat-d') or die;

open (my $fh_out, '>','output-files/flat') or die;


Sort::Merge::Flat::go(   
  
  [
    sub { read_key_value(0) },
    sub { read_key_value(1) },
    sub { read_key_value(2) },
    sub { read_key_value(3) },
  ],
  sub { $_[0] < $_[1] },
  sub { join ';', @_ },
  sub { my ($k, $vals) = @_; print $fh_out "$k: $vals\n" }

);


close $_ for @fh_in;


sub read_key_value {

# Sort::Merge::Flat->debug("read_key_value ");

  my $file_no = shift;

  my $line = readline $fh_in[$file_no];

  return () unless defined $line;

 (my $key   = $line ) =~ s/ .*//;
 (my $value = $line ) =~ s/^[^ ]+ +//;

 chomp $key;
 chomp $value;

 return ($key, $value);


}
