#! /bin/bash

export MAIN_DIR=/proj/speech/users/cs4706/pasr
export HTK_TOOLS=/proj/speech/users/cs4706/tools/htk/htk/HTKTools
export HELPERS=/proj/speech/users/cs4706/pasr

# input arguments
export WAV_FILE=$1
export HMM=$2
export GRAM=$3

$HTK_TOOLS/HParse $GRAM wdnet

echo $WAV_FILE ${WAV_FILE%.wav}.mfc > codetr.scp

echo "extract mfcc features using 16KHz wave files"
$HTK_TOOLS/HCopy -T 1 -C $HELPERS/config16KHz -S codetr.scp

echo ${WAV_FILE%.wav}.mfc > test.scp

echo "run Viterbi"
$HTK_TOOLS/HVite -m -H  $HMM/macros -H $HMM/hmmdefs -S test.scp -l '*' -i  out.mlf -w wdnet -q s -z s -p 0.0 -s 5.0 ./dict $HELPERS/tiedlist

echo;
echo "output is out.mlf"

