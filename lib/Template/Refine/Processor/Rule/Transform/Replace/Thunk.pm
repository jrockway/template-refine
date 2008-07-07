package Template::Refine::Processor::Rule::Transform::Replace::Thunk;
use Moose;

with 'Template::Refine::Processor::Rule::Transform';

has 'replacement' => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

sub transform {
    my ($self, $node) = @_;

    my $replacement = XML::LibXML::Text->new($self->replacement->($node));
    return $replacement if $node->isa('XML::LibXML::Text');
    
    my $copy = $node->cloneNode(0);
    $copy->removeChildNodes;
    $copy->addChild($replacement);
    return $copy;
}

1;
