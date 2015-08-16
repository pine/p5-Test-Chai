requires 'perl', '5.010000';

requires 'Mouse::Util::TypeConstraints';
requires 'Test::Deep::NoTest';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

