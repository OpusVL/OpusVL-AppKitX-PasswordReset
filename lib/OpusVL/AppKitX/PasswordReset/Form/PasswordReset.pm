package OpusVL::AppKitX::PasswordReset::Form::PasswordReset;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

with 'HTML::FormHandler::Widget::Wrapper::Bootstrap3';

has '+widget_wrapper' => (
    default => 'Bootstrap3'
);

has '+is_html5' => (
    default => 1
);

has_field username => (
    type => 'Text'
);

1;

