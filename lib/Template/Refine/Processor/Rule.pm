package Template::Refine::Processor::Rule;
use Moose;

has 'selector' => (
    is      => 'ro',
    does    => 'Template::Refine::Processor::Rule::Select',
    lazy    => 1,
    builder => 'build_selector',
);

has 'transformer' => ( # <insert movie reference>
    is      => 'ro',
    does    => 'Template::Refine::Processor::Rule::Transform',
    lazy    => 1,
    builder => 'build_transformer',
);

sub BUILD {
    my $self = shift;
    confess 'need a selector and transfomer'
      unless $self->selector && $self->transformer;
}

# modifies DOM in place
sub process {
    my ($self, $dom) = @_;
    my @nodes = $self->selector->select($dom);
    $_->replaceNode($self->transformer->transform($_)) for @nodes;
    return;
}

1;
