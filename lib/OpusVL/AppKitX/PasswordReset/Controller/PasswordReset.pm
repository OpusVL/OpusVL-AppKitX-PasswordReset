package OpusVL::AppKitX::PasswordReset::Controller::PasswordReset;

use Moose;
use namespace::autoclean;
BEGIN {extends 'CatalystX::SimpleLogin::Controller::Login';}
with 'OpusVL::AppKit::RolesFor::Controller::GUI';

use MooseX::Types::LoadableClass qw/ LoadableClass /;
use DateTime;
use Data::UUID;
use Digest::SHA1 qw/sha1_hex/;

__PACKAGE__->config
(
    appkit_name                 => 'PasswordReset',
    # appkit_icon                 => 'static/images/flagA.jpg',
    appkit_myclass              => 'OpusVL::AppKitX::PasswordReset',
    # appkit_method_group         => 'Extension A',
    # appkit_method_group_order   => 2,
    # appkit_shared_module        => 'ExtensionA',
);

has reset_password_form => (
    is => 'ro',
    isa => 'Object',
    builder => '_build_reset_password_form',
    lazy_build => 1,
);

has change_password_form => (
    is => 'ro',
    isa => 'Object',
    builder => '_build_change_password_form',
    lazy_build => 1,
);

has user_username_field => (
    is => 'ro',
    isa => 'Str',
    default => 'username',
);

has user_email_field => (
    is => 'ro',
    isa => 'Str',
    default => 'email_address',
);

has user_name_field => (
    is => 'ro',
    isa => 'Str',
    default => 'full_name',
);

has reset_password_form_class => (
    is => 'ro',
    isa => LoadableClass,
    default => 'OpusVL::AppKitX::PasswordReset::Form::PasswordReset',
);

has change_password_form_class => (
    is => 'ro',
    isa => LoadableClass,
    default => 'OpusVL::AppKitX::PasswordReset::Form::PasswordChange',
);

sub _build_reset_password_form {
    my $self = shift;

    my $form = $self->reset_password_form_class->new(
        name => "reset_password_form",
        field_list => [
            submit => {
                type => 'Submit',
                value => 'Reset Password',
            }
        ]
    );

    return $form;
}

sub _build_change_password_form {
    my $self = shift;

    my $form = $self->change_password_form_class->new(
        name => "change_password_form",
        field_list => [
            submit => {
                type => 'Submit',
                value => 'Change Password',
            }
        ]
    );

    return $form;
}


sub reset_password 
    : Chained('not_required')
    : PathPart('reset_password')
    : Public
    : Args(0)
{
    my ($self, $c) = @_;

    my $form = $self->reset_password_form;

    if ($form->process(ctx => $c, params => scalar $c->req->parameters)) {
        my $user = $c->find_user({
            $self->user_username_field => $form->value->{username}
        });

        if ($user) {
            my $uuid = Data::UUID->new->create_str;
            my $email = $user->${\ $self->user_email_field };

            my $reset_hash = sha1_hex($email . $uuid);

            # TODO: Parameterise duration
            my $expires_at = DateTime->now->add(days => 3);
            $user->update({
                password_reset_hash => $reset_hash,
                password_reset_expiry => $expires_at,
            });
            $c->stash->{password_reset_hash} = $reset_hash;
            $c->stash->{user_name} = $user->${\ $self->user_name_field };

            $c->stash->{no_wrapper} = 1;
            $c->stash->{template} = 'modules/passwordreset/email.tt';
            $c->forward($c->view('AppKitTT'));
            my $email_body = $c->res->body;

            ## TT view tends to leave a bunch of newlines
            $email_body =~ s/(?:^\s*$)+//m;

            $c->log->debug($email_body);

            $c->stash->{email} = {
                to => $email,
                from => $c->config->{system_email_address},
                subject => "Code4Health Password Reset",
                body => $email_body,
            };

            $c->forward($c->view('Email'));
        }


        # Confirm the request whether or not it was a valid address.
        # This avoids sharing information about which email addresses are in
        # use.
        if (@{ $c->error }) {
            $c->flash->{error_msg} = "Email failed to send";
        }
        else {
            $c->flash->{status_msg} = "An email with a password reset link has been sent."
        }
        return $c->res->redirect($c->req->uri);
    }

    $c->stash(
        render_form => $form->render
    );
}

sub reset
    : Chained('not_required')
    : PathPart('reset')
    : Args(0)
    : Public
{
    my ($self, $c) = @_;

    my $query = $c->req->query_params;
    my $reset_hash = delete $query->{h};

    # FIXME : This doesn't seem to work in the CMS
    $c->detach('/not_found') if not $reset_hash;
    $c->detach('/not_found') if %$query;

    my $user = $c->find_user({
        password_reset_hash => $reset_hash,
        password_reset_expiry => {
            '>' => \'NOW()'
        }
    });

    $c->detach('/not_found') if not $user;

    my $form = $self->change_password_form;

    if ($form->process(ctx => $c, params => scalar $c->req->body_params)) {
        $user->update({
            password => $form->value->{password}
        });
        $user->save();

        $c->set_authenticated($user);

        $c->stash->{status_msg} = "Your password has been updated successfully and you are now logged in.";
        $c->res->redirect('/profile');
    }

    $c->stash(
        render_form => $form->render
    );
}
1;

__END__

=head1 NAME

OpusVL::AppKitX::PasswordReset::Controller:PasswordReset - Password reset controller

=head1 DESCRIPTION

=head1 METHODS

=head1 BUGS

=head1 AUTHOR

=head1 COPYRIGHT and LICENSE

Copyright (C) 2015 OpusVL

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

