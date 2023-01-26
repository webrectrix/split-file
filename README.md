### Overview
This script breaks a large file into smaller chunks. By default it is designed
to break a CSV file and add a header row to each sub-file; however, this can be
turned off by specifying an **-h** flag with **no** value `-h no`.

### Usage

```
./split-file.sh -f filename -n rows [ -p prepend ] [ -h header ]
```

**-f**, file to split  

**-n**, max number of rows per file  

**-p**, if files need to be renamed on split specify the name they should be renamed to  

Example: 
```
./split-file.sh -f sample.csv -n 20000 -p example-

ls -l
example-00.csv
example-01.csv
example-02.csv
sample.csv
split-file.sh
```

**-h**, if present with value 'no' then header row will not be appended to split files. The 1st file will keep the header row if it had one. Not modifications will be done besides splitting. 

Without this parameter (`default behavior`) header row is appended to all split files