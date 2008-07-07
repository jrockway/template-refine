package Template::Refine::Processor::Rule::Transform::Replace;
use Moose;
use Moose::Util::TypeConstraints;

with 'Template::Refine::Processor::Rule::Transform';

has 'replacement' => sub {
    
}

sub transform {
    my ($self, $node) = @_;
    
}

1;
