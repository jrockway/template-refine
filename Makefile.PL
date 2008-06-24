use inc::Module::Install;

name 'Template-Refine';
all_from 'lib/Template/Refine.pm';

build_requires 'Test::More';
build_requires 'ok';

WriteAll();
