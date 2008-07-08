package Template::Refine::Fragment;
use Moose;
use XML::LibXML;

has fragment => (
    isa      => 'XML::LibXML::DocumentFragment',
    is       => 'ro',
    required => 1,
);

sub new_from_dom {
    my ($class, $dom) = @_;
    return $class->new(fragment => _extract_body($dom));
}

sub new_from_string {
    my ($class, $template) = @_;
    return $class->new(fragment => _parse_html($template));
}

sub new_from_file {
    my ($class, $file) = @_;
    return $class->new_from_string(file($file)->slurp);
}

sub _parse_html {
    my $template = shift;
    return _extract_body(XML::LibXML->new->parse_html_string($template));
}

sub _extract_body {
    my $doc = shift;
    my $xc = XML::LibXML::XPathContext->new($doc);
    my (@nodes) = $xc->findnodes('/html/body/*');

    return XML::LibXML->new->parse_balanced_chunk(join '', map { $_->toString } @nodes);
}

sub _to_document {
    my $frag = shift;
    # XXX: HACK: fix this
    return XML::LibXML->new->parse_html_string($frag->toString);
}

sub process {
    my ($self, @rules) = @_;

    my $dom = _to_document($self->fragment); # make full doc so that "/" is meaningful

    for my $rule (@rules){
        my @nodes = $rule->selector->select($dom);
        $_->replaceNode($rule->transformer->transform($_)) for @nodes;
    }
    
    return $self->new_from_dom($dom);
}

sub render {
    my $self = shift;
    return $self->fragment->toString;
}

1;
