#!/usr/bin/perl -w
use strict;
use Test::More;
use Test::Exception;
use Test::XML;

use aliased 'XML::Toolkit::Config::Container' => 'XMLTK::App';

use aliased 'XML::Toolkit::Generator';

my $xml = <<'END_XML';
<?xml version="1.0"?>
<note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Don't forget me this weekend!</body>
</note>
END_XML
ok( my $builder = XMLTK::App->new->builder, 'Build XML::Toolkit::Builder' );
lives_ok { $builder->parse_string($xml) } 'parsed the xml';
ok( my $code = $builder->render(), 'render code' );

eval $code;
if ($@) {
    diag "Couldn't EVAL code $@";
    done_testing;
    exit;
}

ok( my $loader = XMLTK::App->new->loader, 'Build XML::Toolkit::Loader' );
$loader->parse_string($xml);
ok( my $root = $loader->root_object, 'extract root object' );

ok( scalar @{ $root->to_collection } > 0, 'have entries' );

ok( my $generator = XMLTK::App->new(namespace => '')->generator, 'Build XML::Toolkit::Loader' );
$generator->render_object($root);
is_xml( $xml, join( '', $generator->output ), 'XML compares' );

done_testing;
