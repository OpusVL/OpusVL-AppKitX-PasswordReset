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

