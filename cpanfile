requires 'Moose';
requires 'namespace::autoclean';
requires 'OpusVL::AppKit';
requires 'HTML::FormHandler';
requires 'Catalyst::Model::DBIC::Schema';
requires 'MooseX::Types::LoadableClass';
requires 'DateTime';
requires 'Data::UUID';
requires 'Digest::SHA1';
requires 'Moose::Role';
requires 'CatalystX::InjectComponent';
requires 'File::ShareDir';
requires 'Crypt::URandom';

on build => sub {
    requires 'Catalyst::Runtime' => '5.80015';
    requires 'Test::WWW::Mechanize::Catalyst';
    requires 'Test::More' => '0.88';
};

on test => sub {
    requires 'Test::Pod::Coverage' => '1.04';
    requires 'Test::Pod' => '1.14';
};
