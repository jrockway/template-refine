use strict;
use warnings;
use Test::More tests => 4;

use Template::Refine::Fragment;
use Directory::Scratch;
use Path::Class qw(file);

my $template = 'this is a template';
my $tmp = Directory::Scratch->new;
$tmp->touch('foo', $template);

my $t1 = Template::Refine::Fragment->new( template => file($tmp->exists('foo')));
isa_ok $t1, 'Template::Refine::Fragment';
is $t1->template, "$template\n";

my $t2 = Template::Refine::Fragment->new( template => $template );
isa_ok $t2, 'Template::Refine::Fragment';
is $t2->template, $template;
