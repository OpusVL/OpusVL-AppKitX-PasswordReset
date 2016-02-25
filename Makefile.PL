use strict;
use warnings;
use inc::Module::Install 0.91;
use Module::Install::AuthorRequires;
use Module::Install::AuthorTests;

name 'OpusVL-AppKitX-PasswordReset';
all_from 'lib/OpusVL/AppKitX/PasswordReset.pm';
license  'perl';

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

build_requires 'Catalyst::Runtime' => '5.80015';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More' => '0.88';

author_requires 'Test::Pod::Coverage' => '1.04';
author_requires 'Test::Pod' => '1.14';

author_tests 't/author';

resources repository => 'ssh://git/srv/git/OpusVL-AppKitX-PasswordReset';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/OpusVL/AppKitX/PasswordReset.pm > README")
        and die $!;
}

WriteAll();
