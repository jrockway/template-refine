package Template::Refine::Utils;
use Moose;
use Template::Refine::Processor::Rule;
use Template::Refine::Processor::Rule::Select::CSS;
use Template::Refine::Processor::Rule::Select::XPath;
use Template::Refine::Processor::Rule::Transform::Replace;
use XML::LibXML;

use Sub::Exporter -setup => {
    exports => [qw/simple_replace replace_text xpath css/],
};

sub replace_text($$) {
    my $node = shift;
    my $text = shift;
    $node = $node->cloneNode;
    $node->removeChildNodes;
    $node->addChild( XML::LibXML::Text->new( $text ) );
    return $node;
}

sub simple_replace(&$) {
    my ($code, $selector) = @_;

    $selector = xpath($selector) unless ref $selector;

    return Template::Refine::Processor::Rule->new(
        selector    => $selector,
        transformer => Template::Refine::Processor::Rule::Transform::Replace->new(
            replacement => $code,
        ),
    );
}

sub css($){
    my $selector = shift;
    return Template::Refine::Processor::Rule::Select::CSS->new(
        pattern => $selector,
    );
}

sub xpath($){
    my $selector = shift;
    return Template::Refine::Processor::Rule::Select::CSS->new(
        pattern => $selector,
    );
}

1;

__END__

=head1 NAME

Template::Refine::Utils - sugar up some common C<Template::Refine> operations

=head1 SYNOPSIS

   use Template::Refine; # exports everything

   my $f = Template::Refine::Fragment->new_from_string('<p>Hello</p>');
   say $f->process(
       simple_replace {
           my $n = shift;
           replace_text $n, 'Goodbye'
       } css('p'),
   )->render; # prints <p>Goodbye</p>

=head1 EXPORT

None by default.  You can request any of the functions mentioned
below.  This module use L<Sub::Exporter|Sub::Exporter>, so you can
rename the imports if you like.

=head1 API STABILITY

I will probably add more utilities here in future releases.

=head1 FUNCTIONS

=head2 replace_text( $node, $text )

This makes a copy of C<$node> and replaces the copied node's children with a text
node containing C<$text>.

As an example, if you pass in a node that looks like C<< <p>Hello,
<b>world</b>.</p> >> and the text C<Foo>, the result will be C<<
<p>Foo</p> >>.

=head2 simple_replace BLOCK $pattern

Generates a
L<Template::Refine::Processor::Rule|Template::Refine::Processor::Rule>
that selects nodes matching the C<xpath> and transforms them with the
provided BLOCK.

This will save you a lot of typing.

C<$pattern> is a string representing an xpath expression, or an
instance of a class implementing the
C<Template::Refine::Processor::Rule::Select> role.  (C<css> and
C<xpath> below create suitable instances.)

=head1 xpath $pattern

Returns an instance of
C<Template::Refine::Processor::Rule::Select::XPath> that matches
C<$pattern>.

=head1 css $pattern

Returns an instance of
C<Template::Refine::Processor::Rule::Select::CSS> that matches
C<$pattern>.

=head1 SEE ALSO

L<Template::Refine::Fragment>

L<XML::LibXML>

L<XML::LibXML::Node>

L<XML::LibXML::Element>

L<XML::LibXML::Text>

