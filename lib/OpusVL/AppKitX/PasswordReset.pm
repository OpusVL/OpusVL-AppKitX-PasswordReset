package OpusVL::AppKitX::PasswordReset;
use Moose::Role;
use CatalystX::InjectComponent;
use File::ShareDir qw/module_dir/;
use namespace::autoclean;

with 'OpusVL::AppKit::RolesFor::Plugin';

our $VERSION = '0.03';

after 'setup_components' => sub {
    my $class = shift;
   
    $class->add_paths(__PACKAGE__);
    
    # .. inject your components here ..
    CatalystX::InjectComponent->inject(
        into      => $class,
        component => 'OpusVL::AppKitX::PasswordReset::Controller::PasswordReset',
        as        => 'Controller::Modules::PasswordReset'
    );
};

1;

=head1 NAME

OpusVL::AppKitX::PasswordReset - Provides a password reset URL, with defaults

=head1 DESCRIPTION

Create a Login controller that extends
C<OpusVL::AppKitX::PasswordReset::Controller::PasswordReset>.

This extends from L<CatalystX::SimpleLogin::Controller::Login>, so you can
replace your login controller with one of these.

You can't use C<+OpusVL::AppKitX::PasswordReset> in your Builder, because this creates inaccessible paths.

AppKit itself allows full access to C</login/*>; if you use this module as a
Catalyst plugin, your paths become C</modules/passwordreset/*>. This means that
you get a redirect loop when AppKit denies access to
C</modules/passwordreset/not_required>.

=head1 AUTHOR

Alastair McGowan-Douglas

=head1 COPYRIGHT and LICENSE

Copyright (C) 2015 OpusVL

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

If you require assistance, support, or further development of this software, please contact OpusVL using the details below:

=over 4

=item *

Telephone: +44 (0)1788 298 410

=item *

Email: community@opusvl.com

=item *

Web: L<http://opusvl.com>

=back

=cut

