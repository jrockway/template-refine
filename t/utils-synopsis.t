use strict;
use warnings;
use Test::More tests => 3;
use Test::Exception;

use Template::Refine;

my $f = Template::Refine::Fragment->new_from_string('<p>Hello</p>');
isa_ok $f, 'Template::Refine::Fragment';

my $out;

lives_ok {
    $out = $f->process(
        simple_replace {
            my $n = shift;
            replace_text $n, 'Goodbye'
        } css('p'),
    )->render;
} 'process / replace / text / render stage lives';

is $out, '<p>Goodbye</p>', 'replace worked';
