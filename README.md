# yamlmerge

Merges multiple yaml files according to the following algorithm:

  * Objects are merged, key-wise
  * Arrays are concatenated
  * Attempts to merge all other datatypes fail

Usage:

```
$ yamlmerge file1 file2 ...
```
