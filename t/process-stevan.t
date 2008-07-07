use strict;
use warnings;

use Test::More tests => 3;
use Test::Exception;
use Template::Refine::Fragment;
use Template::Refine::Processor::Rule::Stevan qw(compile);

use DateTime;

sub try_render($$$) {
    my ($template, $rules, $expected) = @_;
    
    my $t = Template::Refine::Fragment->new_from_string($template);
    my @rules = compile(%$rules);
    is $t->process(@rules)->render, $expected;
}

my $year = DateTime->now->year; # we want this test to work next year too :P

try_render 
  '<p>Hello, world!</p><div class="copyright">Copyleft</div>',
  { '.copyright' => sub {
        return "Copyright (c) " . DateTime->now->year
    },
  },
  qq{<p>Hello, world!</p><div class="copyright">Copyright (c) $year</div>};

try_render
  '<div class="username">Foo</div>',
  { '.username' => 'jrockway' },
  '<div class="username">jrockway</div>';

try_render 
  q{<div class="username">Foo</div><hr/><div class="username">Foo</div>},
  { '.username' => 'stevan' },
  q{<div class="username">stevan</div><hr/><div class="username">stevan</div>};
