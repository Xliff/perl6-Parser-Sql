#!env perl6

use v6.c;

use Grammar::Tracer;
use Parser::SQL::Grammar::Tokens;
use Parser::SQL::Grammar::DDLGrammar;

my $test = qq:to/SQL/;
CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);
SQL

say DDLGrammar.subparse($test, :rule<CREATE_ST>);
