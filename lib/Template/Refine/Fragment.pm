package Template::Refine::Fragment;
use Moose;
use XML::LibXML;
use Path::Class qw(file);
use namespace::clean -except => ['meta'];

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
    $_->process($dom) for @rules;
    return $self->new_from_dom($dom);
}

sub render {
    my $self = shift;
    return $self->fragment->toString;
}

1;

__END__

=head1 NAME

Template::Refine::Fragment - represent and refine a fragment of HTML

=head1 SYNOPSIS

    use Template::Refine::Fragment;
    use Template::Refine::Processor::Rule;
    use Template::Refine::Processor::Rule::Select::XPath;
    use Template::Refine::Processor::Rule::Transform::Replace::WithText;

    my $frag = Template::Refine::Fragment->new_from_string(
        '<p>Hello, <span class="world"/>.' # invalid HTML ok
    );

    my $refined = $frag->process(
        Template::Refine::Processor::Rule->new(
            selector => Template::Refine::Processor::Rule::Select::XPath->new(
                pattern => '//*[@class="world"]',
            ),
            transformer => Template::Refine::Processor::Rule::Transform::Replace::WithText->new(
                replacement => sub {
                    return 'world';
                },
            ),
        ),
    );

    return $refined->render; # "<p>Hello, <span class="world">world</span>.</p>"

=head1 METHODS

=head2 new( fragment => $fragment )

Accepts one argument, fragment, which is the
XML::LibXML::DocumentFragment that you want to operate on.

The constructors below are more useful.

=head2 new_from_dom( $dom )

Accepts an XML::LibXML::DOM object

=head2 new_from_string( $html_string )

Accepts an HTML string

=head2 new_from_file( $filename )

Accepts a filename containing HTML

=head2 fragment

Return the C<XML::LibXML::DocumentFragment> that backs this object.

=head2 process( @rules )

Apply C<Template::Refine::Process::Rule>s in C<@rules> and return a
new C<Template::Refine::Fragment>.

=head2 render

Return the fragment as valid HTML

=head1 BUGS

Report to RT.

=head1 VERSION CONTROL

You can browse the repository at:

L<http://git.jrock.us/?p=Template-Refine.git;a=summary>

You can clone the repository by typing:

    git clone git://git.jrock.us/Template-Refine

Please e-mail me any patches.  Thanks in advance for your help!

=head1 AUTHOR

Jonathan Rockway C<< <jrockway@cpan.org> >>

=head1 COPYRIGHT

    Copyright (c) 2008 Infinity Interactive. All rights reserved This
    program is free software; you can redistribute it and/or modify it
    under the same terms as Perl itself.

