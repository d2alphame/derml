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

#### Long values
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
Note the blank line between the long value and the next key. Also note the whitespace before `|=` as it is a must.

#### Multi-line values
If the value is a multi-line value, use colon-equals (`:=`) and follow with a delimiter. The delimiter starts from the first non-whitespace character after `:=` up to the end of the line. The delimiter on a line by itself (and possibly surrounded by whitespace) marks the end of the of the multi-line value.
```
	multi-line-value := end-value
			This is line 1
			This is line 2
			This is line 3
		end-value
```
Do not forget the whitespace around `:=`.

### Keys
The keys can be any combination of uppercase letters (A-Z), lowercase letters (a-z), numbers (0-9), dash, and underscore. So in regex that would be
```
	/[a-zA-Z0-9_-]+/
```

## Arrays
Append a pair of square brackets to indicate that the value would be an array. Specify each value on its own line. Start each value on its own line starting with a dash-space. The value begins from the first non-space character after the dash (-) up to the end of the line.
```
	array-value[] =
		- This is the first item in this array
		- This is the second item in this array
		- And this is the third item in this array
```
If an array item is too long to fit on a single line, use pipe-dash (|-) instead of just the dash. The spaces that surround are required.
```
	another-array-value[] =
		|-	This array element is very,
			very long and cannot fit on
			a single line. Sorry 'bout
			that
		-	This is another element
		-	This is a third element
```
If an array element is a multi-line value, use colon-dash (`:-`) instead and follow up with the delimiter. The delimiter is the first non-whitespace character after the `:-` up to the end of the line. The value ends on line that contains only the delimiter possibly surrounded by whitespaces.

```
	third-array[] =
		-	first element
		-	second element
		-:	end value
			This is the third element
			It is a multi-line value
			It has 3 lines
			end value
		-	This is the fourth element
		-	This is the fifth
```

### Single Line Arrays
Elements of an array can be specified on a single line. Specify the separator between between the square brackets. The separator _cannot_ be any of the characters allowed in names of keys except the letter s which is used to specify space as separator.

The default separator is comma-space. Put comma-space between the values.
```
	an-array-value[] = This, has, 4, values
```
Here are some arrays with different separators
```
	# Using forward slash as separator
	use-slash-as-separator[/] = This / one / has / five / elements
	
	# Using ampersand as separator
	use-ampersand-as-separator[&] = This & one & uses & ampersand and & has five elements
```
The spaces surrounding the separators are required. So
```
	# This, for example is not allowed. Separators should be surrounded by spaces
	use-at-separator[@] = This@is@not@allowed
```
The four brackets '()', '[]', '{}', '<>' can be used as seperators thus:
```
	parens-as-separators[()] = (first item) (this is the second) (and this is the third)
	square-brackets[[]] = [element number 1] [element number 2] [element number 3]
	use-braces[{}] = {this is the first} {this is the second} {this is the third}
	angular-bracket-separators[<>] = <Aang> <Katara> <Sokka> <Toph> <Zuko>
```
When using any of the 3 quoting characters - backtick(\`), apostrophe('), and double-quotes("), each array element must be surrounded by the quoting character _**and**_ seperated by comma-space. For example:
```
	use-backtick-as-separator[`] = `first`, `second`, `third`
	use-apostrophe-as-separator['] = 'first', 'second', 'third'
	use-double-quotes-separator["] = "first", "second", "third"
```
Finally, the space can be used as separator by specifying the lower-case letter 's' as the separator. 
```
	use-space-as-separator[s] = first-element second-element third-element
```
