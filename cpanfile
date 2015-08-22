requires 'perl', '5.010000';

requires 'List::MoreUtils';
requires 'Scalar::Util';
requires 'Scalar::Util::Numeric';
requires 'Data::Structure::Util';
requires 'Test::Deep::NoTest';

requires 'DDP';

requires 'Mouse::Util::TypeConstraints';

on 'test' => sub {
    requires 'Module::Find', '0.13';
    requires 'Test::More', '0.98';
    requires 'Test::Mock::Guard';
    requires 'Test::MockObject', '1.20150527';
};

