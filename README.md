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

⚠️ **Note that the ordering of the renaming will be alphabetical in relation to the original names.**

# Installing
- To install, just run 'install.ps1'. It will present you with relevant information and ask for the required steps.
  - The installer places the script in 'C:/bren/' and adds this directory to the user PATH variable, so the script can be accessed as a command from a shell.
  - It will also save a backup copy of the PATH variable from before adding bren, as well as a log of the operation.

# Uninstalling
- You can just run the 'install.ps1' script again, if bren is installed you will be prompted with a uninstall dialog. 
  - In case you don't have the installer script anymore, when you install bren through 'install.ps1', the installer places a copy of itself in 'C:/bren/', so you can navigate there to run it.
  - By confirming to uninstall, bren will be removed from the user PATH variable and its files in 'C:/bren/' will be deleted. There will remain only a log of the operation and the backup copy of the PATH variable
