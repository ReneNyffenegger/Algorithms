#!/usr/bin/perl
use warnings;
use strict;

die "two input files, one output file needed" unless @ARGV == 3;

my @filename_in;
my @cur_num;
my @cur_val;
my @fh_in;

$filename_in[0] = shift;
$filename_in[1] = shift;

my $filename_out    = shift;

die unless -e $filename_in[0];
die unless -e $filename_in[1];

open($fh_in[0], '<', $filename_in[0]) or die;
open($fh_in[1], '<', $filename_in[1]) or die;
open(my $fh_out  , '>', $filename_out  ) or die;

read_line(0);
read_line(1);

while (defined $cur_num[0] or defined $cur_num[1]) {

  if (defined $cur_num[0] and defined $cur_num[1]) {

    if ($cur_num[0] == $cur_num[1]) {

      write_line($cur_num[0], $cur_val[0], $cur_val[1]);
      read_line(0);
      read_line(1);

    }
    elsif ($cur_num[0] > $cur_num[1]) {
      write_line($cur_num[1], '', $cur_val[1]);
      read_line(1)
    }
    else {
      write_line($cur_num[0], $cur_val[0], '');
      read_line(0)
    }

  }
  elsif (defined $cur_num[0]) {
    write_line($cur_num[0], $cur_val[0], '');
    read_line(1)
  }
  elsif (defined $cur_num[1]) {
    write_line($cur_num[1], '', $cur_val[1]);
    read_line(1);
  }
  else {
    die "Must not happen!";
  }



}

sub read_line {

  my $file_no = shift;

  my $line = readline $fh_in[$file_no];

  if ($line) {
    ($cur_num[$file_no], $cur_val[$file_no]) = split ' ', $line;
  }
  else {
     undef $cur_num[$file_no];
     $cur_val[$file_no] = '';
  }

}

sub write_line {

  my $num   = shift;
  my $val_0 = shift;
  my $val_1 = shift;

  printf($fh_out  "%d %-5s %-5s\n", $num, $val_0, $val_1);

}
