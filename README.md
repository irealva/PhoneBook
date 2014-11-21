PhoneBook
=========

PhoneBook is a spoken telephone directory (Automatic Speech Recognition - ASR and text-to-speech - TTS) with a few extra features. A regular telephone directory can give you the phone number associated to a person or the person associated to a number. On top of this functionality, PhoneBook allows you to ask what state a person is from, what state is associated to an area code, or what area code is associated to a state. The system also allows the user to confirm data he or she may already have. 

Our TTS system allows for 4 different types of grammar corresponding to names/numbers, states/area codes, name/states, state/numbers.

PhoneBook can go into five different categories, depending on the type of question the user is asking. Possible questions in each category are:

Person Menu:
-------
* “What is $name [phone | telephone] number” 
* “What is $name telephone”
* “what is $name phone”
* “what is the phone number of $name”
* “where does $name live” 
* “where is $name from”
* “what state is $name from” 
* “what state does $name live in”

State Menu:
-------
* “What is the area code [of|for] $state”
* "What are the area codes [of|for] $state” 
* “What is a $state area code”

Telephone Menu
-------
-“Whose [phone| telephone] number is $number”
-“to whom does $number belong”
-“who owns the [telephone| phone] number $number”
-“what state is $number from” -“where is $number from”

Area Code Menu:
-------
* “what state is $area [from|for|of]” 
* “where is $area [from|for|of]”

Confirmation Menu:
-------
* “Does $name [live|reside] in $state” 
* “Is $name from $state”
* “Is $state where $julie lives”
* "is $name [phone|telephone] number $phone"
* "is $phone $name [phone|telephone] number"
* "Is $area a $state area code"
* "is $area an area code of $state" 
* "is $state are code $area"
* "is the area code of $state $area" 
* "does $state have a $area code"
* "is $phone a $state [phone | telephone] number"
* "is the [phone |telephone] number $phone a $state number"
* "is $phone a [phone|telephone] number of $state"

Other comments
-------
* The user has the option to say the phrase “go back” allowing him to backtrack through the menus or exit the program.
* Each system state includes implicit confirmation, since the answer to a question includes information that was asked. In the confirmation menu, where all answers are either “yes” or “no” we have included either a repetition of the correct answer or a corrected version of the question.
* The phone and area code menu allow the user to input a phone or area code not in the system. In this case, if the phone or area code does not correspond to an existing state or user, the system allows the user to input another number. 

Code
======

Part1 - includes all files for the TTS component. 
Part 2 - includes all folders for the ASR component.
The grammars are in /part2. They are: gramTelephone, gramState, gramPerson, gramArea, gramConfirmation, gramMain

The program "phoneBook.sh" can be found in the /part2 folder.
