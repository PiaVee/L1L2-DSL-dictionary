# L1L2-DSL-dictionary
Create L1-L2 dictionary files from the CLI.

## PREREQUISITES
* OS: Linux (the script might work elsewhere, too, but I haven't had the need to test it in other systems)
* 

## FIRST STEP
Create a plaintext file with the following header:
  #NAME "Dictionary name"
  #INDEX_LANGUAGE="L1"
  #CONTENTS_LANGUAGE="L2"
Save the file with UTF-16 encoding. Use file extension .dsl.

## USAGE
  "L1L2 "word in L1 : optional L1 definition : optional L1 source = word in L2 : optional L2 definition : optional L2 source"

Remember to use the "" signs around the expression!
Use [space]=[space] to separate the entry in L1 and L2 parts.
Use [space]:[space] to separate L1 and L2 parts in word, definition and source fields.
Definition and source fields are optional.
Words can contain parts in (parenthesis). These won't be displayed in GoldenDict search box.
Without the = separator, the entry is considered to be a monolingual L1 entry. (Wikipedia is searched in L1.)
Entries starting with = should end up as monolingual L2 entries (with Wikipedia searched in L2), but it seems not to be the case.
