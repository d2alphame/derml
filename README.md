# Derml
Derml  (Deji's Really Minimal Language) is a simple configuration file format.

## Comments
Lines that begin with the hash (#) are comments. Comments go on to the end of the line.
```
	# This is a comment
```
Comments may also be indented, so the (#) has to be the first non-whitespace character on the line to make the line a comment.
One final thing about comments is that they sit on a line on their own.

## Key-Value Pairs
In their most basic forms, key-value pairs are represented thus:
```
	key = value
```
Note the whitespace around the equals (=) sign. They are compulsory and **must** be added.

### Values
Values begin from the first non-whitespace character after the equal sign up to the end of the line.
```
	intro = My name Deji Adegbite
```
In the above example, the value begins from the letter 'M' up to the last character on that line.

Keys are case-sensitive so `mykey` is different from `myKey`, which is different from `MYKEY`, which is different from `MyKey`,
you get the picture.

Sometimes values are too long to fit on a single line, for example:
```
	long-value = This is a value that is really, really long and which we would like to break down into multiple lines because who wants to read this?
```
Use pipe-equals (|=) instead of just equals (=) sign and end the value with a blank line. So the above could be re-written thus:
```
	long-value |=
		This is a value
		that is really,
		really long and
		which we would
		like to break
		down into
		multiple lines
		because who
		wants to read
		this?
					
	another_key = another value
```
Note the blank line between the long value and the next key.

