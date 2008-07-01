package Template::Refine::HTML::Header;
use Moose;

has 'css' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

has 'javascript' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
);

has 'title' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

# has DOM => ( ... )
# XXX: this is just for testing, will do real XML later
sub toString {
    my $self = shift;
    my $title = $self->title;
    return "<head><title>$title</title></head>"
}

1;
