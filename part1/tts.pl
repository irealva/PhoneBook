#!/usr/bin/perl

use strict;

my $USERNAME = "ia2178av2248";
my $TOPIC    = "TOPIC";

# arguments 
my $input = shift;    # input string
my $wav_file = shift; # absolute path and name of the output wav file

# checks the parameters, printing an error message if anything is wrong.
if (!$input || !$wav_file) {
	die  "This script transforms an input string into an English sentence, \n"
		."synthesizes it and saves the\n"
		."results as a wav file. \n"
		
		." ***COMPLETE THE DESCRIPTION OF WHAT THIS SCRIPT DOES*** \n"
		
		."Usage: tts.pl INPUT WAVFILE \n"
		."Where: \n"
		." INPUT:   ***COMPLETE: INPUT DESCRIPTION AND FORMAT***\n"
		." WAVFILE: absolute path and name of the output wav file.\n";
}

# transforms the string $input into an English sentence
my $sentence = generate_sentence($input);


# full path to the TTS: partc
# (update if necessary)
my $BASEDIR = "/proj/speech/users/cs4706/".$USERNAME."/partc";


# creates a Festival script
my $filename = "/tmp/temp_".time().".scm";
open OUTPUT, ">$filename" or die "Can't open '$filename' for writing.\n";

print OUTPUT '(load "'.$BASEDIR.'/festvox/SLP_'.$TOPIC.'_xyz_ldom.scm")' . "\n";
print OUTPUT '(voice_SLP_'.$TOPIC.'_xyz_ldom)' . "\n";
print OUTPUT '(Parameter.set \'Audio_Method \'Audio_Command)' . "\n";
print OUTPUT '(Parameter.set \'Audio_Required_Rate 16000)' . "\n";
print OUTPUT '(Parameter.set \'Audio_Required_Format \'wav)' . "\n";
print OUTPUT '(Parameter.set \'Audio_Command "cp $FILE '.$wav_file.'")' . "\n";
print OUTPUT '(SayText "'. $sentence .'")' . "\n";

close OUTPUT;


# tells Festival to execute the script we just created
system "cd $BASEDIR; festival --batch $filename";


# deletes the temporary script
unlink $filename;


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

# transforms the input ($string) into an English sentence and
# returns it.
sub generate_sentence {
	my $string = shift;
	my $sentence;

	my %areacode = (212, "New York",
  		718, "New York",
       		339, "Massachusetts",
		413, "Massachusetts",
         	209, "California",
		323, "California",
         	609, "New Jersey",
		201, "New Jersey",
		307, "Wyoming",
		385, "Utah",
		210, "Texas",
		214, "Texas",
		239, "Florida",
		305, "Florida");

	#@number = split(/)/, $string);
	#$areaCode = substr($number[0], 1);
	
	my @temp = split(/ /, $string);
	my $name = $temp[0];
	my $number = $temp[1];

	my $areaCode = substr $number, 0, 3;		
	
	$sentence = $name . "'s";
	$sentence .= " phone number ";

	my @nums = split(//, $number);


	$sentence .= (join(" ", @nums));

	$sentence .= ",";

	foreach my $temp (keys %areacode)
	{
		if ($temp == $areaCode)
		{
			$sentence .= (" is a " . $areacode{$areaCode} . " number");		
		}
	}
	
	print $sentence . "\n";

	return $sentence;
}

# *** Define any auxiliary functions here ***
