use 5.010;
use strict;
use warnings;
use utf8;

package Neo4j::Driver::SummaryCounters;
# ABSTRACT: Statement statistics


sub new {
	my ($class, $stats) = @_;
	
	return bless $stats, $class;
}


my @counters = qw(
	constraints_added
	constraints_removed
	contains_updates
	indexes_added
	indexes_removed
	labels_added
	labels_removed
	nodes_created
	nodes_deleted
	properties_set
	relationships_created
);
no strict 'refs';  ##no critic (ProhibitNoStrict)
for my $c (@counters) { *$c = sub { shift->{$c} } }

# relationships_deleted is not provided by the Neo4j server versions 2.3.3, 3.3.5, 3.4.1
# (a relationship_deleted [!] counter is provided, but always returns zero)


1;

__END__

=head1 SYNOPSIS

 use Neo4j::Driver;
 my $driver = Neo4j::Driver->new->basic_auth(...);
 
 my $transaction = $driver->session->begin_transaction;
 $transaction->{return_stats} = 1;
 my $query = 'MATCH (n:Novel {name:"1984"}) SET n.writer = "Orwell"';
 my $result = $transaction->run($query);
 
 my $counters = $result->summary->counters;
 my $database_modified = $counters->contains_updates;
 die "That didn't work out." unless $database_modified;

=head1 DESCRIPTION

Contains counters for various operations that a statement triggered.

=head1 ATTRIBUTES

L<Neo4j::Driver::SummaryCounters> implements the following read-only
attributes.

 my $constraints_added     = $counters->constraints_added;
 my $constraints_removed   = $counters->constraints_removed;
 my $contains_updates      = $counters->contains_updates;
 my $indexes_added         = $counters->indexes_added;
 my $indexes_removed       = $counters->indexes_removed;
 my $labels_added          = $counters->labels_added;
 my $labels_removed        = $counters->labels_removed;
 my $nodes_created         = $counters->nodes_created;
 my $nodes_deleted         = $counters->nodes_deleted;
 my $properties_set        = $counters->properties_set;
 my $relationships_created = $counters->relationships_created;

There is no C<relationships_deleted> attribute because this value is
not provided by the Neo4j server.

=head1 SEE ALSO

L<Neo4j::Driver>,
L<Neo4j Java Driver|https://neo4j.com/docs/api/java-driver/current/index.html?org/neo4j/driver/v1/summary/SummaryCounters.html>

=cut
