requires 'perl', '5.010000';

requires 'Scalar::Util';
requires 'Data::Structure::Util';
requires 'Test::Deep::NoTest';

requires 'DDP';

requires 'Mouse::Util::TypeConstraints';

on 'test' => sub {
    requires 'Test::More', '0.98';
requires 'Test::Mock::Guard';
};

