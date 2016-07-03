# ultimate-shell-template
The ultimate shell template with optional GUI support

----

When you like it and have created something with this template, let me know and I will link it here :-)

----

## How to use it for coding

1. rename `ultimate-shell-template.sh` to whatever you want
2. Change all the credit variables `MY_*`
3. Add your stuff to `$REQUIRED_CUS_BIN` variable
4. Edit `my_custom_action()` function
5. Like it :-)


## How to use it
```shell
Usage: ./ultimate-shell-template.sh [-g] [-r <num>] -f <file> [<file2> [<directory>]...]
       ./ultimate-shell-template.sh [-g] -c <file> [<file2> [<directory>]...]
       ./ultimate-shell-template.sh --version
       ./ultimate-shell-template.sh --help
       ./ultimate-shell-template.sh --check

Required options
   -f <file> [<dir>]   This option processes each file separately!

                       You can specify as many files and/or directories as you like.
                       Prior executing, all files are gathered and then the action is applied.
                       If you also specified directories, they will be traversed
                       to a level as specified by '-r' (see below) and all found files will
                       be gathered as well.
                       Note: You must really specify '-r' to actually recurse into directories.


   -c <file> [<dir>]   This option compressed everything first and then processes the final *.tar.gz!

                       Specify one or more files and/or directories.


Optional
   -g                  Use gui version instead of cli.
                       Must be specified before -f to take effect.
                       Requires zenity.

   -r <num>            Be recursive (only works with '-f' option).
                       If you do not specify '-r X', no directories are being traversed.
                       Examples:
                       '-r 0' will recurse into all subdirectories indefinitely.
                       '-r 1' all files inside the directory.
                       '-r 2' all files inside this and all files inside subdirectories.
                       '-r 3' Three levels of recursion.

Other
   --version           Show version information (cli-only)

   --help              Show this help screen (cli-only)

   --check             Check requirements and exit (cli-only)

Documentation and more info at:
https://github.com/cytopia/ultimate-shell-template
```

