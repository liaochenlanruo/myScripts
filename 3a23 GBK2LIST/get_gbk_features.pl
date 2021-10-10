use strict; 
use warnings; 
use feature 'say'; 
use Bio::GenBankParser; 

my $file = shift; 
my $parser = Bio::GenBankParser->new(file => $file); 
while (my $seq = $parser->next_seq) { 
    my $feat = $seq->{'FEATURES'}; 
    for my $f (@$feat) { 
     my $tag = $f->{'feature'}{'locus_tag'}; 
     my $prod = $f->{'feature'}{'product'}; 
     if (defined $tag and defined $prod) { 
      say join "\t", $tag, $prod; 
     } 
    } 
} 