package Template::Refine::Fragment;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Path::Class qw(File);

use XML::LibXML;
use HTML::Selector::XPath;

subtype Template => as 'Str';
coerce Template => from File() => via { $_->slurp };

has template => (
    is       => 'ro',
    isa      => 'Template',
    required => 1,
    coerce   => 1,
);

has fragment => (
    init_arg => undef,
    isa      => 'XML::LibXML::DocumentFragment',
    is       => 'ro',
    lazy     => 1,
    builder  => '_parse_html',
);

sub _parse_html { # should be called _work_around_broken_fucking_api
    my ($self) = @_;
    my $parser = XML::LibXML->new;
    my $doc = $parser->parse_html_string($self->template);

    my $xc = XML::LibXML::XPathContext->new($doc);
    my (@nodes) = $xc->findnodes('//body/*');

    return $parser->parse_balanced_chunk(join '', map { $_->toString } @nodes);
}

sub process { return shift }

sub render {
    my $self = shift;
    return $self->fragment->toString;
}

1;
