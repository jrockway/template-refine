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

__END__

=head1 NAME

Template::Refine::Fragment - represent a refine-able fragment of HTML

=head1 SYNOPSIS

   my $frag = Template::Refine::Fragment->new_from_string('This is <i>HTML</i>.');
   $frag->process( ... );
   print $frag->render;

=head1 METHODS

=head2 new( fragment => $fragment )

Accepts one argument, fragment, which is the
XML::LibXML::DocumentFragment that you want to operate on.  The
constructors below are more useful.

=head2 new_from_dom( $dom )

Accepts an XML::LibXML::DOM object

=head2 new_from_string( $html_string )

Accepts an HTML string

=head2 new_from_file( $filename )

Accepts a filename containing HTML

=head2 fragment

Return the XML::LibXML::DocumentFragment that backs this object

=head2 process

Apply C<Template::Refine::Rule>s

=head2 render

Return the fragment as valid HTML

=head1 BUGS

=head1 AUTHOR

=head1 COPYRIGHT
