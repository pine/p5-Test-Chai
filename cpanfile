requires 'perl', '5.010000';

# alphabet order
requires 'Data::Structure::Util', '0.16';
requires 'Data::Printer', '0.36';
requires 'Exception::Tiny', '0.2.1';
requires 'List::MoreUtils', '0.413';
requires 'Mouse', '2.4.5';
requires 'Scalar::Util', '1.42';
requires 'Scalar::Util::Numeric', '0.40';
requires 'Test::Deep', '0.119';
requires 'Try::Lite', '0.0.3';

on 'test' => sub {
    requires 'Module::Find', '0.13';
    requires 'Perl::Critic', '1.125';
    requires 'Test::Deep', '0.117';
    requires 'Test::Deep::Matcher', '0.01';
    requires 'Test::Exception', '0.40';
    requires 'Test::MockObject', '1.20150527';
    requires 'Test::Mock::Guard', '0.10';
    requires 'Test::More', '0.98';
    requires 'Test::Perl::Critic', '1.03';
};

