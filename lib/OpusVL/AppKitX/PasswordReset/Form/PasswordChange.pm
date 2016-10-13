package OpusVL::AppKitX::PasswordReset::Form::PasswordChange;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

with 'HTML::FormHandler::Widget::Wrapper::Bootstrap3';

has '+widget_wrapper' => (
    default => 'Bootstrap3'
);

has '+is_html5' => (
    default => 1
);

has_field password => (
    type => 'Password'
);

has_field confirm_password => (
    type => 'Password'
);

sub validate_confirm_password {
    my $self = shift;
    my $field = shift;

    unless ($field->value eq $self->field('password')->value) {
        $field->add_error("Passwords do not match");
    }
}

1;

=head1 NAME

OpusVL::AppKitX::PasswordReset::Form::PasswordChange - Change Password form

=head1 DESCRIPTION

Use this in your controller to display the change password form.

=head1 FIELDS

=head2 password

=head2 confirm_password

Two password inputs are displayed. They are automatically validated.

=head1 METHODS

=head2 validate_confirm_password

Ensures C<confirm_password> matches C<password> when the form is submitted.
