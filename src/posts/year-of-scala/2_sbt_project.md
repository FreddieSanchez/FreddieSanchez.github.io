% Year of Scala - Project structure

sbt uses the same directory structure as Maven for source files by default (all paths are relative to the base directory):

```
src/
  main/
    resources/
       <files to include in main jar here>
    scala/
       <main Scala sources>
    java/
       <main Java sources>
  test/
    resources
       <files to include in test jar here>
    scala/
       <test Scala sources>
    java/
       <test Java sources>
project/
    build.properties
```

Source files can be in main/scala or in the base project directory.

The ```project/build.properties``` file can be used to specify the sbt version of your project. If the required version is not available locally, the sbt launcher will download it for you. 

I've been using 0.13.1. 

```
$ cat project/build.properties
sbt.version=0.13.1
```

### sbt 

_2018-Jan-05_
