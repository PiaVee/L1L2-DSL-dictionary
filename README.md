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

## FIRST STEP
* Create a plaintext file with the following header:
  ``#NAME "Dictionary name"``
  ``#INDEX_LANGUAGE="L1"``
  ``#CONTENTS_LANGUAGE="L2"``
* Save the file with UTF-16 encoding. Use file extension ``.dsl``.
* Remember where you saved the file as you will need to adjust the file path in the file.

## USAGE
  ``L1L2-sh "word in L1 (headword) : optional L1 definition : optional L1 source = word in L2 (article) : optional L2 definition : optional L2 source"``

## WHAT IT DOES
The script uses ``[space]=[space]`` to separate the entry in L1 and L2 parts, then ``[space]:[space]`` to separate L1 and L2 parts in word, definition and source fields. Definition and source fields are optional.

The script adds two entries in the given DSL file: one with L1 part as a headword (search term) and L2 part as an article (translation), and one with L2 part as a headword (search term) and L1 part as an article (translation). In this way, you get a bilingual dictionary by typing just one command.



Words can contain parts in (parenthesis). These won't be displayed in GoldenDict search box.
* Without the = separator, the entry is considered to be a monolingual L1 entry. (Wikipedia is searched in L1.)
* Entries starting with = should end up as monolingual L2 entries (with Wikipedia searched in L2), but it seems not to be the case.



## GRR (aka Why doesn't this work?)
* Have you given (``chmode +x L1L".sh``)
* Remember to use the "" signs around the expression.
