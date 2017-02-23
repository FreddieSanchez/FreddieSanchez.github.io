%Directory Versioning in Bash

One problem that I face often is I have to create a directory with new version of files based on a previous directory. The convesion is to use the current date 20141125 followed by an letter 'a'. I wanted to script this out instead of doing it manually.

Obtaining the current date is easy:

```date "+%Y%m%d"``` 

This should yield the date of the form YYYYMMDD.

The next part is obtaining incrementing a letter. Here are two ways of doing it. The first uses the 'tr' command. The second uses bash's [Brace Expansion](http://www.gnu.org/software/bash/manual/bashref.html#Brace-Expansion).
```
version=a
dir=SomeDir
while [[ -d $dir/$version ]]; do 
  version=`echo $version` | tr 'a-z' 'b-za'
done
mkdir $dir/$version
```

or

```
dir=SomeDir
 for x in $dir{a..zA..Z}; do 
    if [[ ! -d $x ]]; then 
      mkdir $x; 
      break; 
    fi;
  done
```
