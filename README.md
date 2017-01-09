# intext beta 0.1.0
Fortran tool to extract integrals from GAMESS binary files

## Compile
Included in the repository is a make file compiling the binaries `aoints` and `dictnry`. Just enter your preferd compiler in the makefile (`gfortran` is dafault).

    $ make
      gfortran -o aoints aoints.f90
      gfortran -o dictnry dictnry.f90
      
## AOINTS
Use the `aoints` binary to extract the two electron integrals in the atomic basis from the AOINTS (`.F08`) file. The AOINTS (`.F08`) file is created by GAMESS whenever the integrals are calulated, however it is deleted after the run by default. You have to adjust your rungms script to fix that. 

If you have the AOINTS (`.F08`) file, simply run 

    $ ./aoints your_file.F08
      28697 unique integrals found
      Stored integrals in file ./dictnry_X.dat 

You will find the printed integrals in the corresponding `./aoints.dat` file. 

## DICTNRY
Use the `dictnry` file to extract information from the DICTNRY (`F10`) file. The DICTNRY (`.F10`) file is created by GAMESS on every run, however it is deleted after the run by default. You have to adjust your rungms script to fix that. 

If you have the DICTNRY (`.F10`) file and you want to extract the content number X, simply run

    $ ./dictnry your_file.F10
      Expecting N records in given file
      Stored result in file ./dictnry_X.dat 

Where `N` is the number of records written to the file by GAMESS. You find documentation on where to find what information in the `PROG.DOC` file of you copy of GAMESS. However it is up to you to interpret the stored information. The `dictnry` programm just converts the binary information at the given place to real values and prints them to the output file. 

## ISSUES
The programms `aoints` and `dictnry` have been tested for simple situations only. It has yet to show its robustness for complex situations.
