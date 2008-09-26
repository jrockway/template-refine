package Template::Refine;
use strict;
use warnings;

our $VERSION = '0.02';

use Template::Refine::Utils;
use Template::Refine::Fragment;

sub import {
    @_ = ('Template::Refine::Utils', ':all');
    goto \&Template::Refine::Utils::import;
}

1;

__END__

=head1 NAME

Template::Refine - refine HTML

=head1 DESCRIPTION

See L<Template::Refine::Fragment>, it's currently the main entry
point.  You can also read the L<Template::Refine::Cookbook>.

If you C<use> this module, everything in C<Template::Refine::Utils> will
be imported into your namespace.  Sugary!

=head1 AUTHOR

Jonathan Rockway C<< <jrockway@cpan.org> >>

=head1 COPYRIGHT

    Copyright (c) 2008 Infinity Interactive. This program is free
    software; you can redistribute it and/or modify it under the same
    terms as Perl itself.

