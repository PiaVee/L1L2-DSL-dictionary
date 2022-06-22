#!/bin/bash

# Create a DSL file first, with the following header:
# #NAME "Dictionary name"
# #INDEX_LANGUAGE="L1"
# #CONTENTS_LANGUAGE="L2"
# Save with encoding UTF-16 and file extension .dsl

# USAGE:
# L1L2 "word in L1 : optional L1 definition : optional L1 source = word in L2 : optional L2 definition : optional L2 source"
# Remember to use the "" signs around the expression!
# Use [space]=[space] to separate the entry in L1 and L2 parts.
# Use [space]:[space] to separate L1 and L2 parts in word, definition and source fields.
# Definition and source fields are optional.
# Words can contain parts in (parenthesis). These won't be displayed in GoldenDict search box.
# Without the = separator, the entry is considered to be a monolingual L1 entry. (Wikipedia is searched in L1.)
# Entries starting with = should end up as monolingual L2 entries (with Wikipedia searched in L2), but it seems not to be the case.


L1L2=$1


# files to work with
origDict="/path/to/the-existing.dsl"  # path to your existing DSL file
workingDict="/path/to/a-temporary-file.txt" # path to a temporary text file


# often used comments
dmy=$(echo $(date +'%A %d.%m.%Y at %H:%M')) # strftime format
citedSourceL1="Source"
citedSourceL2="Quelle"
dateWhenAdded="Entry added to the dictionary:"


# messages for the user
L1wordExists="The dictionary file already contains the L1 word."
L2wordExists="The dictionary file already contains the L2 word."
checkDef="Check if you need to change the word, translation or information about the source."
checkSrc="Check whether you need to add information about the source."
newPair="This new word pair was added to the dictionary."
newL1word="This new L1 word and its definition were added to the dictionary."
newL2word="This new L2 word and its definition were added to the dictionary."


# DSL-file is encoded with UTF-16. It needs to be changed to UTF-8 for grep to work.
iconv -f UTF-16LE -t UTF-8 $origDict -o $workingDict


# word, definition and source in L1
L1word=$(echo "$L1L2" | awk 'BEGIN { FS = " = " } ; { print $1 }' | awk 'BEGIN { FS = " : " } ; { print $1 }')
L1headword=$(echo "$L1word" | sed -r 's/(.*) \((.*)\)/\1\{ [p]\2[\/p]\}/') # headword (search term) in GoldenDict
L1articleWord=$(echo "$L1word" | sed -r 's/(.*) \((.*)\)/\1\ [p]\2[\/p]/') # article (translation) in GoldenDict
myL1definition=$(echo "$L1L2" | awk 'BEGIN { FS = " = " } ; { print $1 }' | awk 'BEGIN { FS = " : " } ; { print $2 }')
L1src=$(echo "$L1L2" | awk 'BEGIN { FS = " = " } ; { print $1 }' | awk 'BEGIN { FS = " : " } ; { print $3 }')


# word, definition and source in L2
L2word=$(echo "$L1L2" | awk 'BEGIN { FS = " = " } ; { print $2 }' | awk 'BEGIN { FS = " : " } ; { print $1 }')
L2headword=$(echo "$L2word" | sed -r 's/(.*) \((.*)\)/\1\{ [p]\2[\/p]\}/') # headword (search term) in GoldenDict
L2articleWord=$(echo "$L2word" | sed -r 's/(.*) \((.*)\)/\1\ [p]\2[\/p]/') # article (translation) in GoldenDict
myL2definition=$(echo "$L1L2" | awk 'BEGIN { FS = " = " } ; { print $2 }' | awk 'BEGIN { FS = " : " } ; { print $2 }')
L2src=$(echo "$L1L2" | awk 'BEGIN { FS = " = " } ; { print $2 }' | awk 'BEGIN { FS = " : " } ; { print $3 }')


# If you want to incorporate information from Wikipedia in your dictionary, uncomment this part and the corresponding if clauses:

# read -p "ISO language code for your L1: " L1
# L1wiki=$(echo $(wikit --lang $L1 $L1word))
# L1wikiSrc=$(echo $(wikit --lang $L1 $L1word --link) | awk 'BEGIN { FS = "://" } ; { print $2 }')
# read -p "ISO language code for your L2: " L2
# L2wiki=$(echo $(wikit --lang $L2 $L2word))
# L2wikiSrc=$(echo $(wikit --lang $L2 $L2word --link) | awk 'BEGIN { FS = "://" } ; { print $2 }')

# If you will use the script for one specific L1-L2 pair, delete the read-lines and replace $L1 and $L2 with corresponding ISO language codes.


# case number for the word pair
numeral=0
if [[ -n $L1word ]]; then # word in L1
L=100000
else
L=0
fi
if [[ -n $myL1definition ]]; then # definition in L1
E=10000
else
E=0
fi
if [[ -n $L1src ]]; then # $citedSourceL1
M=1000
else
M=0
fi
if [[ -n $L2word ]]; then # word in L2
C=100
else
C=0
fi
if [[ -n $myL2definition ]]; then # definition in L2
B=10
else
B=0
fi
if [[ -n $L2src ]]; then 
A=1
else
A=0
fi
numeral=$(($L + $E + $M + $C + $B +$A))


# word pair cases
f111111() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f111110() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f111101() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f111100() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f110111() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f110110() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f110101() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f110100() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "$myL1definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n\t\ \n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f101111() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f101110() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL1definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f101101() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f101100() {
printf "\n\n%s\n" "$L1headword"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex][b]$citedSourceL1[/b]: $L1src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f100111() {
printf "\n\n%s\n" "$L1headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f100110() {
printf "\n\n%s\n" "$L1headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex]$myL2definition[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "$myL2definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f100101() {
printf "\n\n%s\n" "$L1headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
printf "\t%s\n" "[m4][ex][b]$citedSourceL2[/b]: $L2src[/ex][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f100100() {
printf "\n\n%s\n" "$L1headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkred]$L2articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L2wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL2[/b]: $L2wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
printf "\n\n%s\n" "$L2headword"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]※ [b][c darkblue]$L1articleWord[/c][/b][/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "[m4][ex]$L1wiki[/ex][/m]"
# printf "\t%s\n" "[m5][ex][b]$citedSourceL1[/b]: $L1wikiSrc[/ex][/m]"
# fi
printf "\t%s\n" "\ "
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f111000() {
printf "\n\n%s\n" "$L1headword *" # the asterisk is there to mark that this headword has no translation
printf "\t%s\n" "$myL1definition"
printf "\t%s\n" "[m1][b]$citedSourceL1[/b]: $L1src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f110000() {
printf "\n\n%s\n" "$L1headword *" # the asterisk is there to mark that this headword has no translation
printf "\t%s\n" "$myL1definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L1wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L1wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL1[/b]: $L1wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f000111() {
printf "\n\n%s\n" "$L2headword *" # the asterisk is there to mark that this headword has no translation
printf "\t%s\n" "$myL2definition"
printf "\t%s\n" "[m1][b]$citedSourceL2[/b]: $L2src[/m]"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}

f000110() {
printf "\n\n%s\n" "$L2headword *" # the asterisk is there to mark that this headword has no translation
printf "\t%s\n" "$myL2definition"
# If you want to use information from Wikipedia, uncomment this if clause:
# if [[ ! "$L2wiki" == ".*not found :^(" ]]; then
# printf "\t%s\n" "\ "
# printf "\t%s\n" "$L2wiki"
# printf "\t%s\n\t\ \n" "[m1][b]$citedSourceL2[/b]: $L2wikiSrc[/m]"
# fi
printf "\t%s\n" "[m1]($dateWhenAdded $dmy)[/m]"
}


case $numeral in

111111)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f111111)" >> $workingDict
echo "$newPair"
fi
fi
;;

111110)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f111110)" >> $workingDict
echo "$newPair"
fi
fi
;;

111101)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkSrc"
else
echo "$(f111101)" >> $workingDict
echo "$newPair"
fi
fi
;;

111100)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists"
else
echo "$(f111100)" >> $workingDict
echo "$newPair"
fi
fi
;;

110111)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f110111)" >> $workingDict
echo "$newPair"
fi
fi
;;

110110)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f110110)" >> $workingDict
echo "$newPair"
fi
fi
;;

110101)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkSrc"
else
echo "$(f110101)" >> $workingDict
echo "$newPair"
fi
fi
;;

110100)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists"
else
echo "$(f110100)" >> $workingDict
echo "$newPair"
fi
fi
;;

101111)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkSrc"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f011111)" >> $workingDict
echo "$newPair"
fi
fi
;;

101110)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkSrc"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f10110)" >> $workingDict
echo "$newPair"
fi
fi
;;

101101)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkSrc"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkSrc"
else
echo "$(f101101)" >> $workingDict
echo "$newPair"
fi
fi
;;

101100)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkSrc"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists"
else
echo "$(f101100)" >> $workingDict
echo "$newPair"
fi
fi
;;

100111)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f100111)" >> $workingDict
echo "$newPair"
fi
fi
;;

100110)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f100110)" >> $workingDict
echo "$newPair"
fi
fi
;;

100101)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkSrc"
else
echo "$(f100101)" >> $workingDict
echo "$newPair"
fi
fi
;;

100100)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists"
else
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists"
else
echo "$(f100100)" >> $workingDict
echo "$newPair"
fi
fi
;;


111000)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
echo "$(f111000)" >> $workingDict
echo "$newL1word"
fi
;;

110000)
if [[ $(cat $workingDict | grep -c "^$L1word") > 0 ]]; then # in case L1 word already exists in the dictionary
echo "$L1wordExists $checkDef"
else
echo "$(f110000)" >> $workingDict
echo "$newL1word"
fi
;;

000111)
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f000111)" >> $workingDict
echo "$newL2word"
fi
;;

000110)
if [[ $(cat $workingDict | grep -c "^$L2word") > 0 ]]; then # in case L2 word already exists in the dictionary
echo "$L2wordExists $checkDef"
else
echo "$(f000110)" >> $workingDict
echo "$newL2word"
fi
;;

esac


# At the end the working dictionary needs to be changed back to a dictionary file in UTF-16
iconv -f UTF-8 -t UTF-16LE $workingDict -o $origDict
rm $workingDict
