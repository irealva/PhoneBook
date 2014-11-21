#!/usr/bin/perl

use strict;

my $option = "UNSPECIFIED";

my $name = "UNSPECIFIED" ;
my $state = "UNSPECIFIED" ;
my $area = "UNSPECIFIED" ;
my $phone = "UNSPECIFIED" ;

my $answerType = "UNSPECIFIED";

my $error = 0 ;
my $recursive1 = 0 ;
my $recursive2 = 0 ;

my @names = ("IRENE", "ANATOLIY", "JULIE", "DAVID", "MAX");
my @states = ("YORK", "MASSACHUSETTS", "TEXAS", "CALIFORNIA", "FLORIDA");
my @tlf = ("6 4 6 - 9 4 3 - 3 8 0 6", "6 1 7 - 8 2 3 - 3 0 7 3", "7 1 3 - 9 0 1 - 4 2 8 7", "6 1 9 - 2 6 7 - 9 0 8 4", "2 3 9 - 7 5 4 - 9 1 8 0") ;
my @areas = ("6 4 6", "6 1 7", "7 1 3", "6 1 9", "2 3 9");

my %numbers =  ("ONE", 1, "TWO", 2, "THREE", 3, "FOUR", 4, "FIVE", 5, "SIX", 6, 
	     "SEVEN", 7, "EIGHT", 8, "NINE", 9, "ZERO", 0);
my @numbers = ("ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ZERO");

my $wavCounter = 1 ;

open LOGFILE, ">", "log.txt" or die $! ;
print LOGFILE localtime() . "\n\n"; 

my $iterator = 0 ;


sub returnAnswer {
  
  $error = 0 ;
  
  if ($answerType eq "CONFIRMATION")
    {
      if ($name ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	{
	  my $i = 0;
	  my $index;
	  foreach my $n (@names){
	    if($n eq $name){
	      $index = $i;
	    }
	    $i++;
	  }
	  
	  if ($states[$index] eq $state)
	    {
	      return "YES" ;
	    }
	  else
	    {
	      return "NO" ;
	    }
	}
      elsif ($name ne "UNSPECIFIED" and $phone ne "UNSPECIFIED")
	{
	  my $i = 0;
	  my $index;
	  foreach my $n (@names){
	    if($n eq $name){
	      $index = $i;
	    }
	    $i++;
	  }
	  
	  if ($tlf[$index] eq $phone)
	    {
	      return "YES" ;
	    }
	  else
	    {
	      return "NO" ;
	    }
	  
	}
      elsif ($area ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	{
	  
	  my $i = 0;
	  my $index;
	  foreach my $n (@states){
	    if($n eq $state){
	      $index = $i;
	    }
	    $i++;
	  }
	  
	  if ($areas[$index] eq $area)
	    {
	      return "YES" ;
	    }
	  else
	    {
	      return "NO" ;
	    }
	  
	}
      elsif ($phone ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	{
	  my $i = 0;
	  my $index;
	  foreach my $n (@states){
	    if($n eq $state){
	      $index = $i;
	    }
	    $i++;
	  }
	  
	  if ($tlf[$index] eq $phone)
	    {
	      return "YES" ;
	    }
	  else
	    {
	      return "NO" ;
	    }
	}
    }
  else {
    if ($name ne "UNSPECIFIED")
      {
	my $i = 0;
	my $index;
	foreach my $n (@names){
	  if($n eq $name){
	    $index = $i;
	  }
	  $i++;
	}
	
	my $j = 0;
	my $jindex;
	foreach my $n (returnSentence()){
	  if($n eq $name){
	    $jindex = $j;
	  }
	  $j++;
	}
	
	if ($answerType eq "STATE"){
	  return $states[$index];
	}
	elsif ($answerType eq "PHONE"){
	  return $tlf[$index];
	}
      }
    
    elsif ($phone ne "UNSPECIFIED")
      {
	my $i = 0;
	my $index = "ERROR" ;
	foreach my $n (@tlf){
	  if($n eq $phone){
	    $index = $i;
	  }
	  $i++;
	}
	
	if ($index eq "ERROR")
	  {
	    system "play instructions/errorPhone.wav" ;
	    
            $name = "UNSPECIFIED" ;
      	    $phone = "UNSPECIFIED" ;
            $state = "UNSPECIFIED" ;
            $area = "UNSPECIFIED" ;
	    $error = 1 ;
	  }
	else {
	  if ($answerType eq "NAME"){
	    return $names[$index];
	  }
	  elsif ($answerType eq "STATE"){
	    return $states[$index];
	  }
	}
      }
    
    elsif ($state ne "UNSPECIFIED")
      {
	my $i = 0;
	my $index;
	foreach my $n (@states){
	  if($n eq $state){
	    $index = $i;
	  }
	  $i++;
	}
	
	return $areas[$index];
	
      }
    
    elsif ($area ne "UNSPECIFIED")
      {
	my $i = 0;
	my $index  = "ERROR";
	foreach my $n (@areas){
	  if($n eq $area){
	    $index = $i;
	  }
	  $i++;
	}
	
	if ($index eq "ERROR")
	  {
	    
	    system "play instructions/errorArea.wav" ;
	    $name = "UNSPECIFIED" ;
      	    $phone = "UNSPECIFIED" ;
            $state = "UNSPECIFIED" ;
            $area = "UNSPECIFIED" ;
            $error = 1 ;
	  }
	else
	  {
	    return $states[$index];
	  }
      }
  }
}

sub returnSentence {

  my $filename = "out.mlf" ;
 
  open( FILE, "< $filename" ) or die "Can't open $filename : $!";

  my @fileArray = <FILE>;

  my @wordArray ;

  pop(@fileArray) ;

  my @lineArray;
  my $s;

  do{
    @lineArray = split(' ',$fileArray[0]);
    $s = substr $lineArray[0], 0, 1 ;
    if($s ne "0"){ shift(@fileArray) ; }
  }
  while($s ne "0");

  @lineArray = split(' ',$fileArray[0]);
  if( $lineArray[-1] eq "SENT-START") { shift(@fileArray) ; }

  foreach my $line (@fileArray){
    @lineArray = split(' ',$line);
    $s = substr $lineArray[-1], 0, 1 ;
    
    if(!($s eq "-")){
      if(!($lineArray[-1] eq "SENT-END")) { 
	push(@wordArray, $lineArray[-1]);
      }
    }
  }

  close FILE;


  return @wordArray ;


}

sub saySentence {
  my $USERNAME = "ia2178,av2248";
  my $TOPIC = $_[0]; 
  my $sentence = $_[1];
  
  
  my $wav_file = $wavCounter . "answer.wav" ;
  $wavCounter++ ;
  
  # full path to the TTS: 
  # (update if necessary)
  my $BASEDIR = "/proj/speech/users/cs4706/proj3/".$USERNAME."/part1/".$TOPIC;
  
  
  # creates a Festival script
  my $filename = "/tmp/temp_".time().".scm";
  open OUTPUT, ">$filename" or die "Can't open '$filename' for writing.\n";
  
  print OUTPUT '(load "'.$BASEDIR.'/festvox/SLP_'.$TOPIC.'_xyz_ldom.scm")' . "\n";
  print OUTPUT '(voice_SLP_'.$TOPIC.'_xyz_ldom)' . "\n";
  print OUTPUT '(Parameter.set \'Audio_Method \'Audio_Command)' . "\n";
  print OUTPUT '(Parameter.set \'Audio_Required_Rate 16000)' . "\n";
  print OUTPUT '(Parameter.set \'Audio_Required_Format \'wav)' . "\n";
  print OUTPUT '(Parameter.set \'Audio_Command "cp $FILE '."../../".$wav_file.'")' . "\n";
  print OUTPUT '(SayText "'. $sentence .'")' . "\n";
  
  close OUTPUT;
  
  # tells Festival to execute the script we just created
  system "cd $BASEDIR; festival --batch $filename";
  
  
  # deletes the temporary script
  unlink $filename;

  system "play ../$wav_file >> output.txt" ;
  print LOGFILE "<" . $wav_file . ">\n\n" ;

}

sub mainMenu {
  
  print "\nState: Main Menu" ;

  system "play instructions/instruction.wav >> output.txt" ;
  print LOGFILE "\nState [Main]\n\nSYSTEM: If you know  a person's name say 'person', if you have a telephone number, say 'telephone', if you want information about a given state say 'state', and if you want information about an area code say 'area code', if you want to confirm any information say 'confirmation'." ;
  print LOGFILE "<instructions/instruction.wav>\n\n" ;

  my $wav = $wavCounter . "main.wav" ;
  $wavCounter++;

  
  #system "/proj/speech/tools/festival/speech_tools/bin/na_record -f 16000 -time 2 -o $wav" ;

   # tells Festival to execute the script we just created
  #system "./recognizePath.sh $wav /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;

	
  my $wav_file = "inputs/final/1main_16000.wav" ; # absolute path and name of the output wav file
  system "./recognizePath.sh $wav_file /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;

 



  my @options = ("PERSON", "STATE", "AREA", "TELEPHONE", "CONFIRMATION") ;


  my @wordArray = returnSentence() ;
  my $int = 0 ;
  foreach my $word (@options)
    {
      if ($wordArray[0] eq $word)
	{
	  $option = $word ;
	}
      
    }

  
  print "User: " . $option . "\n";
  print LOGFILE "User: " . $option . "\n" ;
  print LOGFILE "<" . $wav . ">\n" ;
  print LOGFILE "Semantics [Option = $option]\n\n" ;

  


  if ($option eq "PERSON")
  {
    personMenu() ;
  }


  elsif ($option eq "TELEPHONE")
    {
      telephoneMenu() ;
    }
  
  
  elsif ($option eq "AREA")
    {
      areaMenu() ;
    }
  
  
  elsif ($option eq "STATE")
    {
      stateMenu() ;
    }
  
  elsif ($option eq "CONFIRMATION")
    {
      confirmationMenu() ;
    }
  else
    {
      system "play instructions/unknown.wav" ;
      print LOGFILE "SYSTEM: Sorry, that option was not found.\n" ;
      print LOGFILE "<instructions/unknown.wav>\n\n" ;
      mainMenu() ;
    }
}

sub finalMenu()
{

  print "\nState: Final Menu" ;
  system "play instructions/finalInstr.wav" ;

  print LOGFILE "\nState [Final]\n\nSYSTEM: If you want to ask another question, simply say what type of question you would like to ask, it can be 'person', 'state', 'area code', or 'telephone'. If you want to go back to main menu say 'main', if you have no further questions say 'exit'.\n" ;
  print LOGFILE "<instructions/finalInstr.wav>\n\n" ;


  my $wav = $wavCounter . "final.wav" ;
  $wavCounter++;

  #system "/proj/speech/tools/festival/speech_tools/bin/na_record -f 16000 -time 2 -o $wav" ;
  #system "./recognizePath.sh $wav /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;

  if ($iterator == 0)
    {
      my $wav_file = "inputs/final/3telephone_16000.wav" ; # absolute path and name of the output wav file
      system "./recognizePath.sh $wav_file /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;
    }
  elsif ($iterator == 1)
    {
      my $wav_file = "inputs/final/5state_16000.wav" ; # absolute path and name of the output wav file
      system "./recognizePath.sh $wav_file /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;
    }
  elsif ($iterator == 2)
    {
      my $wav_file = "inputs/final/7area_16000.wav" ; # absolute path and name of the output wav file
      system "./recognizePath.sh $wav_file /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;
    }
  elsif ($iterator == 3)
    {
      my $wav_file = "inputs/final/9confirmation_16000.wav" ; # absolute path and name of the output wav file
      system "./recognizePath.sh $wav_file /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;
    }
  else
    {
      my $wav_file = "inputs/final/11exit_16000.wav" ; # absolute path and name of the output wav file
      system "./recognizePath.sh $wav_file /proj/speech/users/cs4706/pasr/HMM_G12 gramMain  >> output.txt" ;
    }

  $iterator++ ;
  
  

  my @options = ("PERSON", "STATE", "AREA", "TELEPHONE", "CONFIRMATION", "EXIT", "MAIN") ;


  my @wordArray = returnSentence() ;




  my $int = 0 ;
  foreach my $word (@options)
    {
      if ($wordArray[0] eq $word)
	{
	  $option = $word ;
	}
      
    }

  print "USER: " . "@wordArray" . "\n";
  print LOGFILE "User: " . "@wordArray" . "\n";
  print LOGFILE "<$wav>\n" ;
  print LOGFILE "Semantics [Option = $option]\n\n" ;

  $name = "UNSPECIFIED" ;
  $phone = "UNSPECIFIED" ;
  $state = "UNSPECIFIED" ;
  $area = "UNSPECIFIED" ;

  if ($option eq "PERSON")
  {
    personMenu() ;
  }


  elsif ($option eq "TELEPHONE")
    {
      telephoneMenu() ;
    }
  
  
  elsif ($option eq "AREA")
    {
      areaMenu() ;
    }
  
  
  elsif ($option eq "STATE")
    {
      stateMenu() ;
    }
  
  elsif ($option eq "CONFIRMATION")
    {
      confirmationMenu() ;
    }
  elsif ($option eq "MAIN")
    {
	mainMenu() ;
    }
  elsif ($option eq "EXIT")
   {
	system "play instructions/final.wav" ;
	print LOGFILE "SYSTEM: Thank you for using phonebook, we hope to hear from you again soon.\n" ;
	print LOGFILE "<instructions/final.wav>\n\n" ;
	exit 0 ;
   }
  else
    {
      system "play instructions/unknown.wav" ;
      print LOGFILE "SYSTEM: Sorry, that option was not found.\n" ;
      print LOGFILE "<instructions/unknown.wav>\n\n" ;
      finalMenu() ;
    }
}




sub personMenu {
  
  print "\nState: Person Menu" ;
  system "play instructions/personInstr.wav >> output.txt" ;
  system "play instructions/backRem.wav >> output.txt" ;

  print LOGFILE "\nState [Person]\n\nSYSTEM: To find more information about a person, you can ask for their telephone number, for example 'what is Irene's phone number?' or you can ask where the person lives, for example 'what state is Anatoliy from?'\n" ;
  print LOGFILE "<instructions/personInstr.wav>\n\n" ;

  print LOGFILE "SYSTEM: Remember, you can say 'go back' if you want to go back a step\n" ;
  print LOGFILE "<instructions/backRem.wav>\n\n" ;


  my $wav = $wavCounter . "person.wav" ;
  $wavCounter++;


  #system "/proj/speech/tools/festival/speech_tools/bin/na_record -f 16000 -time 4 -o $wav" ;
  #system "./recognizePath.sh $wav /proj/speech/users/cs4706/pasr/HMM_G12 gramPerson  >> output.txt" ;



  system "./recognizePath.sh inputs/final/2person_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramPerson  >> output.txt" ;
  #system "./recognizePath.sh inputs/back3_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramPerson  >> output.txt" ;

   
  my @wordArray = returnSentence() ;

  my $firstWord = $wordArray[0] ;
  my $secondWord = $wordArray[1] ;

  foreach my $word (@wordArray){
    foreach my $n (@names){
      if($word eq $n){
	$name = $n;
      }
    }
  }

  if($firstWord eq "BACK" or $firstWord eq "GO")
    { 
      $answerType = "BACK";
      $name = "UNSPECIFIED" ;
      $phone = "UNSPECIFIED" ;
      $state = "UNSPECIFIED" ;
      $area = "UNSPECIFIED" ;
    }
  
  elsif($firstWord eq "WHAT"){
    
    if ($secondWord eq "IS")
      {
	$answerType = "PHONE";
      }
    else
      {  
	$answerType = "STATE" ;
      }
  }
  else {
    
    $answerType = "STATE" ;
  }
  
  print "USER: " . "@wordArray" . "\n";

  print LOGFILE "USER: " . "@wordArray" . "\n";
  print LOGFILE "<$wav>\n" ;
  print LOGFILE "Semantics [AnswerType = $answerType, Name = $name]\n\n" ;

  if ($answerType eq "BACK")
    {
      mainMenu();
    }
  else {    
    if ($answerType eq "STATE")
      {
	my $sentence = $name . " lives in " . ((returnAnswer() eq "YORK") ? "New York" : ucfirst lc(returnAnswer())) ;
	print LOGFILE "SYSTEM: " . $sentence . "\n";
	print "SYSTEM: " . $sentence . "\n";
	saySentence("name", $sentence) ;
      }
    else
      {
	my $sentence = returnAnswer() . ", is " . ucfirst lc($name) . "s number" ;
	print LOGFILE "SYSTEM: " . $sentence . "\n";
	print "SYSTEM: " . $sentence . "\n";

	saySentence("telephone", $sentence) ;	
      }
  }


  finalMenu() ;

}

sub telephoneMenu {

  print "\nState: Telephone Menu" ;
  system "play instructions/telephoneInstr.wav" ;
  system "play instructions/backRem.wav" ;

  print LOGFILE "\nState [Telephone]\n\nSYSTEM: To find more information about a telephone number, you can ask to whom the telephone number belongs, for example, 'Whose phone number is 718-759-7340', or you can ask what state the telephone number is from, for example, 'Where is 646-943-3806 from?'\n" ;
  print LOGFILE "<instructions/telephoneInstr.wav>\n\n" ;

  print LOGFILE "SYSTEM: Remember, you can say 'go back' if you want to go back a step\n" ;
  print LOGFILE "<instructions/backRem.wav>\n\n" ;


  my $wav = $wavCounter . "telephone.wav" ;
  $wavCounter++;

  #system "/proj/speech/tools/festival/speech_tools/bin/na_record -f 16000 -time 6 -o $wav" ;
  #system "./recognizePath.sh $wav /proj/speech/users/cs4706/pasr/HMM_G12 gramTelephone  >> output.txt" ;


  system "./recognizePath.sh inputs/final/4telephone_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramTelephone  >> output.txt" ;
  #system "./recognizePath.sh inputs/back3_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramTelephone  >> output.txt" ;
 
  my @wordArray = returnSentence() ;

  my $firstWord = $wordArray[0] ;
  my $int = 0;

  foreach my $word (@wordArray){
    foreach my $temp (@numbers)
      {
	if ($temp eq $word)
	  {
	    if ($phone eq "UNSPECIFIED")
	      {
		$phone = $numbers{$word};
	      }
	    else
	      {
		if($int == 2){
		  $phone = $phone .  " " . $numbers{$word} . " -";
		}
		elsif($int == 6){
		  $phone = $phone . " - " . $numbers{$word} ;
		}
		else{
		  $phone = $phone .  " " . $numbers{$word} ;
		}
	      }
	    
	    $int++ ;
	  }	
      }
  }
  
  if($firstWord eq "BACK" or $firstWord eq "GO")
    { 
      $answerType = "BACK";
      $name = "UNSPECIFIED" ;
      $phone = "UNSPECIFIED" ;
      $state = "UNSPECIFIED" ;
      $area = "UNSPECIFIED" ;
    }
  
  elsif($firstWord eq "WHAT" or $firstWord eq "WHERE"){
  
	$answerType = "STATE";

  }
  else {
    
    $answerType = "NAME" ;
  }
  

  print "USER: " . "@wordArray" . "\n";

  print LOGFILE "USER: " . "@wordArray" . "\n";
  print LOGFILE "<$wav>\n" ;
  print LOGFILE "Semantics [AnswerType = $answerType, Telephone = $phone]\n\n" ;



  if ($answerType eq "BACK")
    {
      mainMenu();
    }
  else {    
    my $answer = returnAnswer() ;

    if ($error == 0)
    {    	
    	if ($answerType eq "STATE")
      	{
		my $sentence =  $phone . ", is a " . (($answer eq "YORK") ? "New York" : ucfirst lc($answer)) . " number" ;
		print LOGFILE "SYSTEM: " . $sentence . "\n";
		print "SYSTEM: " . $sentence . "\n";

		saySentence("telephone", $sentence) ;
      	}
    	else
      	{
		my $sentence = $phone . ", is " . ucfirst lc($answer) . "s number" ;
		print LOGFILE "SYSTEM: " . $sentence . "\n";
		print "SYSTEM: " . $sentence . "\n";

		saySentence("telephone", $sentence) ;	
      	}
     }
     else
	{
	$recursive1 = 1 ;
	telephoneMenu() ;
	
	}
  }

  if ($recursive1 == 0)
	{
  	finalMenu() ;
	}

}

sub stateMenu {

  print "\nState: State Menu" ;
  system "play instructions/stateInstr.wav" ;
  system "play instructions/backRem.wav" ;

  print LOGFILE "\nState [State]\n\nSYSTEM: To find more information about a state, you can ask what are its area codes, for example 'What is the area code of California'\n" ;
  print LOGFILE "<instructions/stateInstr.wav>\n\n" ;

  print LOGFILE "SYSTEM: Remember, you can say 'go back' if you want to go back a step\n" ;
  print LOGFILE "<instructions/backRem.wav>\n\n" ;


  my $wav = $wavCounter . "state.wav" ;
  $wavCounter++;


  #system "/proj/speech/tools/festival/speech_tools/bin/na_record -f 16000 -time 4 -o $wav" ;
  #system "./recognizePath.sh $wav /proj/speech/users/cs4706/pasr/HMM_G12 gramState  >> output.txt" ;


  system "./recognizePath.sh inputs/final/6state_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramState  >> output.txt" ;
  #system "./recognizePath.sh inputs/back3_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramState  >> output.txt" ;
 
  my @wordArray = returnSentence() ;


  my $firstWord = $wordArray[0] ;

  foreach my $word (@wordArray){
    foreach my $n (@states){
      if($word eq $n){
	$state = $n;
      }
    }
  }  


  if($firstWord eq "BACK" or $firstWord eq "GO")
    { 
      $answerType = "BACK";
      $name = "UNSPECIFIED" ;
      $phone = "UNSPECIFIED" ;
      $state = "UNSPECIFIED" ;
      $area = "UNSPECIFIED" ;
    }

  else {
    
    $answerType = "AREA CODE" ;
  }
  
  print "USER: " . "@wordArray" . "\n";

  print LOGFILE "USER: " . "@wordArray" . "\n";
  print LOGFILE "<$wav>\n" ;
  print LOGFILE "Semantics [AnswerType = $answerType, State = $state]\n\n" ;


  if ($answerType eq "BACK")
    {
      mainMenu();
    }
  else {
    my $sentence = "The area code of " . (($state eq "YORK") ? "New York" : ucfirst lc($state)) . " is " . returnAnswer() ;
    print LOGFILE "SYSTEM: " . $sentence . "\n";
    print "SYSTEM: " . $sentence . "\n";

    saySentence("areacode", $sentence) ;
  }

  finalMenu() ;

}


sub areaMenu {

  print "\nState: Area Menu" ;
  system "play instructions/areaInstr.wav" ;
  system "play instructions/backRem.wav" ;

  print LOGFILE "\nState [Area]\n\nSYSTEM: To find more information about an area code, you can ask what state is the area code from, for example 'What state is 6 4 6 from?'\n" ;
  print LOGFILE "<instructions/areaInstr.wav>\n\n" ;

  print LOGFILE "SYSTEM: Remember, you can say 'go back' if you want to go back a step\n" ;
  print LOGFILE "<instructions/backRem.wav>\n\n" ;


  my $wav = $wavCounter . "area.wav" ;
  $wavCounter++;


  #system "/proj/speech/tools/festival/speech_tools/bin/na_record -f 16000 -time 4 -o $wav" ;
  #system "./recognizePath.sh $wav /proj/speech/users/cs4706/pasr/HMM_G12 gramArea  >> output.txt" ;


  system "./recognizePath.sh inputs/final/8area_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramArea  >> output.txt" ;
  #system "./recognizePath.sh inputs/back3_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramArea  >> output.txt" ;
  

  my @wordArray = returnSentence() ;
  
  my $firstWord = $wordArray[0] ;
  my $int = 0;
  
  foreach my $word (@wordArray){
    foreach my $temp (@numbers)
      {
	if ($temp eq $word)
	  {
	    if ($area eq "UNSPECIFIED")
	      {
		$area = $numbers{$word};
	      }
	    else
	      {
		$area = $area .  " " . $numbers{$word} ;
	      }
	  }
	
	$int++ ;
      }	
  }
  
  
  if($firstWord eq "BACK" or $firstWord eq "GO")
    { 
      $answerType = "BACK";
      $name = "UNSPECIFIED" ;
      $phone = "UNSPECIFIED" ;
      $state = "UNSPECIFIED" ;
      $area = "UNSPECIFIED" ;
    }
  
  else {
    
    $answerType = "STATE" ;
  }
  

  print "USER: " . "@wordArray" . "\n";
  
  print LOGFILE "USER: " . "@wordArray" . "\n";
  print LOGFILE "<$wav>\n" ;
  print LOGFILE "Semantics [AnswerType = $answerType, Area = $area]\n\n" ;

  if ($answerType eq "BACK")
    {
      mainMenu();
    }
  else {
    #print returnAnswer() ;

    my $answer = returnAnswer() ;

    if($error == 0)
	{
		
		my $sentence = "The area code of " . (($answer eq "YORK") ? "New York" : ucfirst lc($answer)) . " is " . $area ;
		print LOGFILE "SYSTEM: " . $sentence . "\n";
	        print "SYSTEM: " . $sentence . "\n";

    		saySentence("areacode", $sentence) ;
	}
    else {
	$recursive2 = 1 ;
	areaMenu() ;
	
	}
  }


  if ($recursive2 == 0)
	{
  	finalMenu() ;
	}
}


sub confirmationMenu {

  print "\nState: Confirmation Menu" ;
  system "play instructions/confirmationInstr.wav" ;
  system "play instructions/backRem.wav" ;

  print LOGFILE "\nState [Confirmation]\n\nSYSTEM: To confirm if the information you have is correct, you can ask questions involving two different categories, for example, 'Is 6 4 6 an area code of new york?', 'Does Julie live in Texas?', or 'Is 646-943-3806 a New York number?'\n" ;
  print LOGFILE "<instructions/confirmationInstr.wav>\n\n" ;

  print LOGFILE "SYSTEM: Remember, you can say 'go back' if you want to go back a step\n" ;
  print LOGFILE "<instructions/backRem.wav>\n\n" ;


  my $wav = $wavCounter . "confirmation.wav" ;
  $wavCounter++;

  #system "/proj/speech/tools/festival/speech_tools/bin/na_record -f 16000 -time 5 -o $wav" ;
  #system "./recognizePath.sh $wav /proj/speech/users/cs4706/pasr/HMM_G12 gramConfirmation  >> output.txt" ;

  #system "./recognizePath.sh inputs/confirmation/con1_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramConfirmation  >> output.txt" ;
  system "./recognizePath.sh inputs/final/10confirmation_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramConfirmation  >> output.txt" ;
  #system "./recognizePath.sh inputs/back3_16000.wav /proj/speech/users/cs4706/pasr/HMM_G12 gramConfirmation  >> output.txt" ;
 
  my @wordArray = returnSentence() ;


  my $firstWord = $wordArray[0] ;
  my $int = 0;


  foreach my $word (@wordArray)
    {
 
      foreach my $n (@names){
	if($word eq $n){
	  $name = $n;
	}
      }
      
      foreach my $temp (@numbers)
	{
	  if ($temp eq $word)
	    {
	      if ($phone eq "UNSPECIFIED")
		{
		  $phone = $numbers{$word};
		  $area = $numbers{$word};
		}
	      else
		{
		  if($int == 3){
		    $phone = $phone .  " - " . $numbers{$word};		   
		  }
		  elsif($int == 6){
		    $phone = $phone . " - " . $numbers{$word} ;
		  }
		  else{
		    $phone = $phone .  " " . $numbers{$word} ;
		    $area = $area . " " . $numbers{$word} ;
		  }
		}
	      
	      $int++ ;
	    }	
	}
      
      foreach my $n (@states){
	if($word eq $n){
	  $state = $n;
	}
      }
    }  
  
  if ($phone eq $area)
    {
      $phone = "UNSPECIFIED" ;
    }
  else
    {
      $area = "UNSPECIFIED" ;
    }
  
  
  if($firstWord eq "BACK" or $firstWord eq "GO")
    { 
      $answerType = "BACK";
      $name = "UNSPECIFIED" ;
      $phone = "UNSPECIFIED" ;
      $state = "UNSPECIFIED" ;
      $area = "UNSPECIFIED" ;
    }

  else {
    
    $answerType = "CONFIRMATION" ;
  }
  
  
  print "USER: " . "@wordArray" . "\n";
  
  print LOGFILE "USER: " . "@wordArray" . "\n";
  print LOGFILE "<$wav>\n" ;
  print LOGFILE "Semantics [AnswerType = $answerType, Name = $name, Telephone = $phone, State = $state, Area = $area]\n\n" ;


  if ($answerType eq "BACK")
    {
      mainMenu();
    }
  else {    
    if (returnAnswer() eq "YES")
      {
	system "play instructions/yes.wav" ;
	print LOGFILE "SYSTEM: Yes\n" ;
	print LOGFILE "<instructions/yes.wav>\n\n" ;
	
	
	if ($name ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	  {
	    my $sentence = $name . " lives in " . (($state eq "YORK") ? "New York" : ucfirst lc($state)) ;
	    print LOGFILE "SYSTEM: " . $sentence . "\n";
	    	print "SYSTEM: " . $sentence . "\n";

	    saySentence("name", $sentence) ;
	    
	  }
	elsif ($name ne "UNSPECIFIED" and $phone ne "UNSPECIFIED")
	  {
	    my $sentence = $phone . ", is " . ucfirst lc($name) . "s number" ;
	    print LOGFILE "SYSTEM: " . $sentence . "\n";
	    	print "SYSTEM: " . $sentence . "\n";

	    saySentence("telephone", $sentence) ;
	    
	  }
	elsif ($area ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	  {
	    my $sentence = "The area code of " . (($state eq "YORK") ? "New York" : ucfirst lc($state)) . " is " . $area ;
	    print LOGFILE "SYSTEM: " . $sentence . "\n";
	    	print "SYSTEM: " . $sentence . "\n";

	    saySentence("areacode", $sentence) ;
	  }
	elsif ($phone ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	  {
	    my $sentence =  $phone . ", is a " . (($state eq "YORK") ? "New York" : ucfirst lc($state)) . " number" ;
	    print LOGFILE "SYSTEM: " . $sentence . "\n";
	    	print "SYSTEM: " . $sentence . "\n";

	    saySentence("telephone", $sentence) ;
	  }
      }
    else
      {
	system "play instructions/no.wav" ;
	print LOGFILE "SYSTEM: No\n" ;
	print LOGFILE "<instructions/no.wav>\n\n" ;
	
	if ($name ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	  {
	    my $i = 0;
	    my $index;
	    foreach my $n (@names){
	      if($n eq $name){
		$index = $i;
	      }
	      $i++;
	    }
	    
	    my $sentence = $name . " lives in " . (($states[$index] eq "YORK") ? "New York" : ucfirst lc($states[$index])) ;
	    print LOGFILE "SYSTEM: " . $sentence . "\n";
	    	print "SYSTEM: " . $sentence . "\n";

	    saySentence("name", $sentence) ;
	    
	  }
	elsif ($name ne "UNSPECIFIED" and $phone ne "UNSPECIFIED")
	  {
	    my $i = 0;
	    my $index;
	    foreach my $n (@names){
	      if($n eq $name){
		$index = $i;
	      }
	      $i++;
	    }

	    my $sentence = $tlf[$index] . ", is " . ucfirst lc($name) . "s number" ;
	    print LOGFILE "SYSTEM: " . $sentence . "\n";
	    	print "SYSTEM: " . $sentence . "\n";

	    saySentence("telephone", $sentence) ;
	    
	  }
	elsif ($area ne "UNSPECIFIED" and $state ne "UNSPECIFIED")
	  {
	    my $i = 0;
	    my $index;
	    foreach my $s (@states){
	      if($s eq $state){
		$index = $i;
	      }
	      $i++;
	    }

	    my $sentence = "The area code of " . (($state eq "YORK") ? "New York" : ucfirst lc($state)) . " is " . $areas[$index] ;
	    print LOGFILE "SYSTEM: " . $sentence . "\n";
	    	print "SYSTEM: " . $sentence . "\n";

	    saySentence("areacode", $sentence) ;
	  }
      }
  }
  
  finalMenu() ;
}


print "\nState: Greeting" ;
system "play instructions/greeting.wav >> output.txt" ;


print LOGFILE "\nState [Greeting]\n\nSYSTEM: Hello, welcome to PhoneBook . Here you can find information on a person, state, area code, and phone number.\n" ;
print LOGFILE "<instructions/greeting.wav>\n\n" ;

mainMenu() ;


close LOGFILE;

