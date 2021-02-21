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
Keys may be any combination of alphabets, numbers, dashes or underscores and may not begin with a number or a dash.

Note the whitespace around the equals (=) sign. They are compulsory and **must** be added.
Also note that keys are case-sensitive. So `mykey` is different from `Mykey` which is different from `MyKey`, etc.

Used in the above form, the value starts from the first non-whitespace character after the '=' sign up to the end of the line

To use quoted values instead, use the colon (:) in place of the equals sign. The values may then be quoted with single-quotes ('), double-quotes ("), backticks (`), parentheses (()), braces({}), square-brackets ([]), or angular brackets(<>). A comment
can be added after the quoted value
```
	key : (This is the value) 	# Using parentheses as the quote
	a_second_key : 'This uses single-quotes'	# Comments may be added
	angle-quote : <This value uses angular brackets as the quotes>

```

### Values
Values begin from the first non-whitespace character after the equal sign up to the end of the line.
```
	intro = My name Deji Adegbite
```
In the above example, the value begins from the letter 'M' up to the last character on that line.  
In the case of quoted values, The values will be within the selected quotes. For example
```
	executables_dir = {C:/Program Files}	# Quoted with braces
```

#### Long values
Sometimes values are too long to fit on a single line, for example:
```
	long-value = This is a value that is really, really long and which we would like to break down into multiple lines because who wants to read this?
```
Use the left-angle (<) instead of equals (=) sign and end the value with a blank line. So the above could be re-written thus:
```
	long-value <
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
Note the blank line between the long value and the next key. Also note the whitespace before `<` as it is a must.  
The initial indentation on the first line of the value will be stripped off while the initial indentation for the
remaining lines will be concatenated into one space.

#### Multi-line values
If the value is a multi-line value, use the pipe (`|`) and follow with a delimiter. The delimiter starts from the first non-whitespace character after `|` up to the end of the line. The delimiter on a line by itself (and possibly surrounded by whitespace) marks the end of the of the multi-line value.
```
	multi-line-value | end-value
			This is line 1
			This is line 2
			This is line 3
		end-value
```
Do not forget the whitespace around `|`. All initial whitespace is removed. This implies that you end up with a left-aligned
paragraph

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
## References
Use (`<=`) to assign the value of a previously assigned key to another.
```
	my-first-key = This is the value of 'my-first-key'
	
	# Assign the value of 'my-first-key' to 'my-second-key'
	my-second-key <= my-first-key
```
## Sections
Specify sections by using two equals signs followed by the name of the section and ending with 2 equals.
```
	== Section 1 ==
		my-first-key = This is the first value
		my-second-key = This is the second value
		my-third-key = This is the third value
```
Note the space after the first pair of equals (`==`) just before the second one. Those spaces must be added.
