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

Either:

=over

=item Add C<+OpusVL::AppKitX::PasswordReset> to your Builder to use the defaults

=item Extend C<OpusVL::AppKitX::PasswordReset::Controller::PasswordReset> to alter the defaults.

=back

The aforementioned controller extends from
L<CatalystX::SimpleLogin::Controller::Login>, so you can replace your login
controller with one of these.

=head1 AUTHOR

Alastair McGowan-Douglas

=head1 COPYRIGHT and LICENSE

Copyright (C) 2015 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

