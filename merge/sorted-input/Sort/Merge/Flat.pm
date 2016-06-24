package Sort::Merge::Flat;

use strict;
use warnings;

our $VERSION = 0.01;

my $dbg;

my @curr_values;
my @inputs;


my $callback_cmp_key;
sub go {


  my $callbacks_key_value          = shift;
     $callback_cmp_key             = shift;  # must return true if first key < second key
  my $callback_merge_values_of_key = shift;
  my $callback_return_key_values   = shift;

  my $last_k;
  my $curr_k;

  @inputs = map { { cb_kv => $_, has_more_input => 1} } @$callbacks_key_value;

  request_input($_) for @inputs;

  $curr_k = determine_minimum_k();

  $last_k = $curr_k;

  while (grep {$_->{has_more_input}} @inputs) {

    for my $input (grep {$_->{has_more_input}} @inputs) {

      if ($input->{k} eq $curr_k) {
        advance_input($input);
      }

    }

    $last_k = $curr_k;

    $curr_k = determine_minimum_k();

    last unless $curr_k;

    next if $curr_k eq $last_k;

    my $ret = &$callback_merge_values_of_key(@curr_values);

    &$callback_return_key_values($last_k, $ret);
    @curr_values = ();

  }

}

sub request_input {

  my $input = shift;


  my @kv = &{$input->{cb_kv}}();


  if (@kv == 2) {
    ($input->{k}, $input->{v}) = @kv;
  }
  else {
     undef $input->{k};
     $input->{has_more_input} = 0;
  }

}

sub advance_input {

  my $input = shift;

  push @curr_values, $input->{v};
  request_input($input);

}

sub determine_minimum_k {

  my $k;

  for my $input (grep { defined $_->{k} } @inputs ) {

    if (defined $k) {

      if (  &$callback_cmp_key(  $input->{k}  , $k   )) {
        $k = $input->{k};
      }

    }
    else {
      $k = $input->{k};
    }
  }

  return $k;

}

1;
