# Demo

Clone this repo or unpack the zip from the releases tab, open a shell in the 'demo' directory and run either:

```bash
..\bren.ps1
```

And then enter 'jpg' and '2' in the requested inputs. OR for a faster approach:

```bash
..\bren.ps1 jpg 2
```
## Explanation
- In both examples, 'jpg' is the qualifier for the files to be renamed.
- '2' is the number of zeros to start naming from. (As it's '2', names will be starting from '00'. If it were 0 this would mean no zeros, so names would start from 1).

So, by running the above command the 3 unsorted '.jpg' files inside 'demo' should be renamed to '00.jpg', '01.jpg' and '02.jpg'.

The '.mp4' and '.pdf' files should still keep their original name, as by using 'jpg' as the qualifier any other extension is going to be ignored.

⚠️ **Note that the ordering of the renaming will be alphabetical.**
