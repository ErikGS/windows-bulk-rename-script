# Demo

Clone this repo, open a shell inside 'demo' and run:

```bash
..\bren.ps1 jpg 2
```

- In this example, 'jpg' is the qualifier for the files to be renamed.
- '2' is the number of zeros that should be in the name.

So, by running this command the 3 unsorted '.jpg' files inside 'demo' should be renamed to '00.jpg', '01.jpg' and '02.jpg'.

The '.mp4' and '.pdf' ones should still keep their original name, as by using 'jpg' as the qualifier any other extension is going to be ignored.

⚠️ **Note that the ordering of the renaming will be alphabetical.**
