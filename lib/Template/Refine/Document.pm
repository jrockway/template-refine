package Template::Refine::Document;
use Moose;
use XML::LibXML;
use Template::Refine::HTML::Header;

my $HTML = 'http://www.w3.org/1999/xhtml';

has header => (
    is       => 'ro',
    isa      => 'Template::Refine::HTML::Header',
    required => 1,
);

has document => (
    init_arg => undef,
    is       => 'ro',
    isa      => 'XML::LibXML::Document',
    lazy     => 1,
    builder  => '_initial_doc',
);

sub _initial_doc {
    my $self = shift;
    my $doc = XML::LibXML->new->parse_string(
        qq{<?xml version="1.0" encoding="utf-8"?>}.
        qq{<html xmlns="$HTML">}.
        $self->header->toString.
        qq{<body></body></html>}
    );
    
    return $doc;
}

sub add_fragment {
    my ($self, @fragments) = @_;
    my $doc = $self->document;
    my ($body) = $doc->getElementsByTagName('body');
    $body->appendChild($_->fragment) for @fragments;
    return;
}

sub render {
    my $self = shift;
    return $self->document->toString;
}

1;
