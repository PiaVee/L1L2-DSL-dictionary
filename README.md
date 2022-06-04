# L1L2-DSL-dictionary
Add entries to a (multilingual) DSL dictionary file from the CLI. Append both L1-L2 and L2-L1 term pairs in your dictionary by typing just one command. Add information from Wikipedia to your terms.

## PREREQUISITES
* Linux OS (the script might work elsewhere, too, but I haven't had the need to test it in other systems)
* GoldenDict
* ``wikit`` for adding stuff from Wikipedia (the script works fine without!)
  * check whether you already have it installed: ``which wikit``
  * if not, check also these: ``which nodejs`` and ``which node``
    * if these are not in your system, install them first
  * install ``wikit``: ``sudo npm install wikit -g``

## FIRSTLY
* Create a plaintext file with the following header:
  ``#NAME "Dictionary name"``
  ``#INDEX_LANGUAGE="L1"``
  ``#CONTENTS_LANGUAGE="L2"``
* Save the file with UTF-16 encoding and with the file extension ``.dsl``.

## SECONDLY
* Adjust the script to suit your reality:
 * write the path to the existing DSL dictionary file
 * write the path to a temporary working file

## USAGE
  ``L1L2-sh "word in L1 (headword) : optional L1 definition : optional L1 source = word in L2 (article) : optional L2 definition : optional L2 source"``

## WHAT THE SCRIPT DOES
The script uses ``[space]=[space]`` to separate the entry in L1 and L2 parts, then ``[space]:[space]`` to separate L1 and L2 parts in word, definition and source fields. Definition and source fields are optional.

The script adds two entries in the given DSL file: one with L1 part as a headword (search term) and L2 part as an article (translation), and one with L2 part as a headword (search term) and L1 part as an article (translation). In this way, you get a bilingual dictionary by typing just one command.

Words can contain parts in (parenthesis). These won't be displayed in GoldenDict search box. In this way, you can add (grammatical) information to search terms that doesn't interfere with how the terms are sorted or displayed. This hidden information is visible when the whole article is being read.

Without the ``=`` separator, the entry is considered to be a monolingual L1 entry. This enables you to create monolingual entries. These are marked with an additional asterisk, so that when searching for a word in GoldenDict, one easily can recognize the bilingual terms (words with a translation) and terms that have only monolingual information connected to them. It is possible to add Wikipedia information to monolingual entries, but do note that as of today, Wikipedia is searched in L1. 

Entries starting with = should end up as monolingual L2 entries (with Wikipedia searched in L2), but it seems not to be the case.

Dictionary entries can be enriched with Wikipedia articles. This function is per default switched off. In order to make the script add information from Wikipedia, you need to un-comment certain parts in the script.

## GRRRR (aka "Why doesn't this work?")
A list of easy fixes (I've tried them all...):
* Do create a DSL file first, so that you have a file to add stuff into.
* Save the dictionary file with UTF-16 encoding.
* Use the extension ``.dsl`` for your dictionary file.
* Make the script executable (``chmode +x L1L".sh``)
* Check the proper file path.
* Remember to use the "" signs around the entry expression.
* Check your spelling.
* There's nothing the script can do for it. Different Wikipedia articles just work in different ways.
