package OpusVL::AppKitX::PasswordReset::RolesFor::Result;
use strict;
use warnings;
use Moose::Role;

sub passwordreset_init {
    my $class = shift;

    $class->add_columns(
        password_reset_hash => {
            data_type => 'text'
        },
        password_reset_expires => {
            data_type => 'timestamp'
        },
    );

    $class->load_components(qw/InflateColumn::DateTime/);
}

1;

__END__

=head1 NAME

OpusVL::AppKitX::PasswordReset::RolesFor::Result - Add the password reset
behaviour to a user object

=head1 DESCRIPTION

Adds the C<password_reset_hash> and C<password_reset_expires> columns to your
result class. Also adds the C<InflateColumn::DateTime> component.

    package MyUserObject;
    use base 'DBIx::Class';
    with 'OpusVL::AppKitX::PasswordReset::RolesFor::Result';

    __PACKAGE__->add_columns(...);
    __PACKAGE__->passwordreset_init;

Apply it to the user class you've configured Catalyst to use. Alternatively, add
the information manually.
