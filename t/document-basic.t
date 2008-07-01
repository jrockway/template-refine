use strict;
use warnings;
use Test::More tests => 7;
use Test::Exception;

use Template::Refine::Fragment;
use Template::Refine::Document;
use Template::Refine::HTML::Header;

my $h = Template::Refine::HTML::Header->new(
    css        => [],
    javascript => [],
    title      => 'Hello, world!',
);
isa_ok $h, 'Template::Refine::HTML::Header';

my $t = Template::Refine::Document->new( header => $h );
isa_ok $t, 'Template::Refine::Document';

is $t->render, '<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>Hello, world!</title></head><body/></html>
';

my @frags = map { Template::Refine::Fragment->new( template => $_ ) } (
    '<p>This is a test</p>',
    '<p>of the document!</p>',
);

isa_ok $frags[0], 'Template::Refine::Fragment';
isa_ok $frags[1], 'Template::Refine::Fragment';


lives_ok {
    $t->add_fragment(@frags);
} 'adding fragments lives';

is $t->render, '<?xml version="1.0" encoding="utf-8"?>
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>Hello, world!</title></head><body><p>This is a test</p><p>of the document!</p></body></html>
';
