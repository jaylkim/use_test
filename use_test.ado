*! version 0.0.0.9000 Jay Kim 28jan2021
/***

use_test
========

Description
-----------

This command creates a do-file to test the current ado file under development.

Syntax
------

> __use_test__ _filename_ [, _replace_]

> where _filename_ is the name of the ado-file currently under development.

Options
-------

- _replace_ : If there exists a test file already, replace it with a new one.

Author
------

Jay (Jongyeon) Kim

Johns Hopkins University

jay.luke.kim@gmail.com

[https://github.com/jaylkim](https://github.com/jaylkim)

[https://jaylkim.rbind.io](https://jaylkim.rbind.io)

License
-------

MIT License

Copyright (c) 2021 Jongyeon Kim


_This help file was created by the_ __markdoc__ _package written by Haghish_

***/


program define use_test

  syntax anything(name=filename id="ado filename") [, replace] 

  // Make a folder for test files, if not exist
  cap mkdir tests

  // Some values to be used
  local clen = strlen("Tests for  command in ")

  // Detect the command name in the ado file
  file open myprog using "`filename'", read
  file read myprog line
  while r(eof) == 0 {
    if regexm(`"`line'"', "program define ") {
      qui cd tests
      local cmd = regexr(`"`line'"', "program define ", "")
      qui file open testdo using "tests-`cmd'.do", write `replace'
      file write testdo "/***" _n
      file write testdo _n
      file write testdo "Tests for `cmd' command in `filename'" _n
      file write testdo ("=" * (strlen("`cmd'") + strlen("`filename'") + `clen')) _n
      file write testdo _n
      file write testdo "***/" _n 
      file write testdo _n
      file write testdo _n
      file write testdo "cap program drop `cmd'" _n
      file write testdo _n
      file write testdo "do `filename'" _n
      file write testdo _n
      file write testdo "// Test 1" _n
      file write testdo `"disp as text "Test 1 started : ""'
      file write testdo _n
      file write testdo _n
      file write testdo _n
      file close testdo
      disp as res "tests-`cmd'.do written in tests/"
      qui cd ..
    }
    file read myprog line
  }
  file close myprog

end
