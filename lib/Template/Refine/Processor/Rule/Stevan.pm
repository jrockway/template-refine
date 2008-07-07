package Template::Refine::Processor::Rule::Stevan;
use strict;
use warnings;
use Template::Refine::Processor::Rule;
use Template::Refine::Processor::Rule::Select::CSS;
use Template::Refine::Processor::Rule::Transform::Replace::Thunk;

use Sub::Exporter -setup => {
    exports => [ qw/compile/ ],
};

sub compile {
    my (%definitions) = @_;
    my @rules;
    while(my ($select, $replace) = each %definitions) {
        my $transform = ref $replace eq 'CODE' ? $replace : sub { $replace } ;
        push @rules,
          Template::Refine::Processor::Rule->new(
              selector => 
                Template::Refine::Processor::Rule::Select::CSS->new(
                    pattern => $select,
                ),
              transformer => 
                Template::Refine::Processor::Rule::Transform::Replace::Thunk->new(
                    replacement => $transform,
                ),
          );
    }
    return @rules;
}

1;
