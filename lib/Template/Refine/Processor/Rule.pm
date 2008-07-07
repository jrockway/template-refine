package Template::Refine::Processor::Rule;
use Moose;

has 'selector' => (
    is       => 'ro',
    does     => 'Template::Refine::Processor::Rule::Select',
    required => 1,
);

has 'transformer' => ( # <insert movie reference>
    is       => 'ro',
    does     => 'Template::Refine::Processor::Rule::Transform',
    required => 1,
);

1;
