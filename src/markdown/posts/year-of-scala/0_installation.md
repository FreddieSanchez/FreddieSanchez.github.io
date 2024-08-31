%Year of Scala - SBT Installation
% Freddie Sanchez
% 2018-Jan-03

I prefer to work in the console using Ubuntu 16.04 - xmonad as my window manager. This will all be focused around my own workflow and preferences. I am going to start my Year of Scala by installing SBT - sbt is a build tool for Scala and Java. It provides a great way to manage your project, build and test straight from the console. 

sbt requires Java 1.8 or later.  Check to make sure you have Java 1.8 installed:

```bash
java -version

```
If you don't, grab it from the repos. If you have Ubuntu 14.04 see the relavent [stackoverflow answer](https://askubuntu.com/a/666481).

```bash
sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

To install sbt, I ran the following:

```bash
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt
```
Taken from [http://www.scala-sbt.org/download.html](http://www.scala-sbt.org/download.html).

sbt provides a command line interface, and menu driven interface to interact with Scala and the project.

```bash
$ sbt
[info] Loading project definition from <project directory>/project
[info] Set current project to <project name> (in build file:<project diretory>)
>help 

  help                                    Displays this help message or prints detailed help on requested commands (run 'help <command>').
  about                                   Displays basic information about sbt and the build.
  tasks                                   Lists the tasks defined for the current project.
  settings                                Lists the settings defined for the current project.
  reload                                  (Re)loads the project in the current directory
  projects                                Lists the names of available projects or temporarily adds/removes extra builds to the session.
  project                                 Displays the current project or changes to the provided `project`.
  set [every] <setting>                   Evaluates a Setting and applies it to the current project.
  session                                 Manipulates session settings.  For details, run 'help session'.
  inspect [uses|tree|definitions] <key>   Prints the value for 'key', the defining scope, delegates, related definitions, and dependencies.
  <log-level>                             Sets the logging level to 'log-level'.  Valid levels: debug, info, warn, error
  ; <command> (; <command>)*              Runs the provided semicolon-separated commands.
  ~ <command>                             Executes the specified command whenever source files change.
  last                                    Displays output from a previous command or the output from a specific task.
  last-grep                               Shows lines from the last output for 'key' that match 'pattern'.
  export <tasks>+                         Executes tasks and displays the equivalent command lines.
  exit                                    Terminates the build.
  --<command>                             Schedules a command to run before other commands on startup.
  show <key>                              Displays the result of evaluating the setting or task associated with 'key'.

More command help available using 'help <command>' for:
  !, +, ++, <, alias, append, apply, eval, iflast, onFailure, reboot, bash
```

For example, to get a scala REPL it's the command ``` $ sbt console ```

To exit the REPL supply the EOF character (CTRL+D) or type 'exit';

If you are in a project directory, you can specify the Scala version in ```build.sbt``` under the variable ```scalaVersion```

This is where I'll start my Scala adventure.

_2018-Jan-03_
