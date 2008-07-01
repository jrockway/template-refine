use inc::Module::Install;

name 'Template-Refine';
all_from 'lib/Template/Refine.pm';

requires 'XML::LibXML';
requires 'HTML::Selector::XPath';
requires 'Moose';
requires 'Moose::Util::TypeConstraints';
requires 'MooseX::Types::Path::Class';
requires 'Path::Class';
build_requires 'Directory::Scratch';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
