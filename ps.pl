#!/usr/bin/perl

my $opt = $ARGV[0];
my $psfiledate = $ARGV[1];
my $psfilepath = "/cicsdump/ibmscript/logs/CollectPsInfo/ps_aux_info";
my $psfile = "$psfilepath.$psfiledate";
my $isheader = 1;
my $regionName = "";
my $regionMem = "";
my $totalcount = 0;
my $totalmem = 0;

sub printheader {
  my($hash1) = (shift);
  while(my($k,$v) = each %$hash1){
    print "$k ";
  }
}

sub printvalue {
  my($hash1) = (shift);
  while(my($k,$v) = each %$hash1){
    print "$v ";
  }
}

sub printall {
  my($hash1, $hash2) = (shift, shift);
  while(my($k,$v) = each %$hash1){
    print "$k $v $hash2->{$k} \n";
  }
}


open(PSFILE,$psfile) || die("Can't open file $psfile: $!");
while($line=<PSFILE>) {
  if($line =~ /START/){
    $d = substr($line,32,10);
    $t = substr($line,43,8);
  }
  if($line =~ /grep/) {
    next;
  }
  if($line =~ / cicsas /) {
   @items = split(/\s+/,$line);
   if(@items <= 16){
    $regionName = $items[11];
    $regionMem = $items[5];
   }
   if(@items > 16 && @items < 18) {
    $regionName = $tiems[12];
    $regionMem = $items[5];
   }
   if(@items > 18) {
    $regionName = $items[15];
    $regionMem = $items[10];
   }
   $count{$regionName}++;
   $mem{$regionName} += $regionMem;
   $totalcount++;
   $totalmem += $regionMem;
  }
  
  if($line = ~ / END ===/) {
    if($opt eq "-c") {
     if($isheader == 1) {
       print "Date Time ";
       printheader(\%count);
       printheader(\%mem);
       print "\n";
       $isheader = 0;
     }
     print "$d $t ";
     printvalue(\%count);
     printvalue(\%mem);
     print "\n";
   }
   if($opt eq "-s") {
     print "$d $t\n";
     printall(\%count,\%mem);
     print "Total $totalcount $totalmem\n";
   }
   %count = ();
   %mem = ();
   $totalcount = 0; 
   $totalmem = 0;
 }
}
close(PSFILE);


 
