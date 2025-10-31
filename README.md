# Derml
Derml  (Deji's Really Minimal Language) is a simple configuration file format.

## Comments
Lines that begin with the hash (#) are comments. Comments go on to the end of the line.
```
	# This is a comment
```
Comments may also be indented, so the (#) has to be the first non-whitespace character on the line to make the line a comment.

## Key-Value Pairs
In their most basic forms, key-value pairs are represented thus:
```
	key = value
```
Keys may be any combination of alphabets, numbers, dashes, underscores, or the period character and may not begin with a number or a dash.

Note the whitespace around the equals (=) sign. They are compulsory and **must** be added.
Also note that keys are case-sensitive. So `mykey` is different from `Mykey` which is different from `MyKey`, etc.

Used in the above form, the value starts from the first non-whitespace character after the '=' sign up to the end of the line.

### Values
Values begin from the first non-whitespace character after the equal sign up to the end of the line.
```
	intro = My name is Deji Adegbite
```
In the above example, the value begins from the letter 'M' up to the last character on that line.  
More simple examples:
```
	Avatar = Aang
	City = Ba Sing Se
	sacred_artifact = Sokka's boomerang
```

#### Quoting Values
Values may be quoted. There are 7 quoting mechanisms available - these are single-quotes ('), double-quotes ("), backticks (`), parentheses (()), braces({}),square-brackets ([]), or angular brackets(<>). A comment can be added after the quoted value.
```
	key = (This is the value) 	# Using parentheses as the quote
	a_second_key = 'This uses single-quotes'	# Comments may be added after quoted value
	angle-quote = <This value uses angular brackets as the quotes>
	dbl-quote = "Double quote"
	windows_path = {C:\Program Files}		# Uses braces to quote the value 
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
paragraph.

#### "Pythonic" values
Relative indentation of the values may be preserved. This is done by using `>` to assign the value and specifying a delimiter. End
the value with the delimiter on a line by itself possibly surrounded by spaces. The initial spaces on each line is stripped. The
number of indenting spaces on the first line of the value is stripped off from the remaining lines. This means python or yaml can
be stored. For example
```
	my-python-code > end-of-python
		if(x > 5):
			print("x is 5")
	end-of-python
```
The delimiter begins with the first non-whitespace character after the `>` up to the end of that line.

### Keys
The keys can be any combination of uppercase letters (A-Z), lowercase letters (a-z), numbers (0-9), dash, and underscore.
Keys cannot start with a dash or a number. This means the regex for keys would be
```
	/[a-zA-Z_][a-zA-Z0-9_-]+/
```

## Arrays
Elements of an array can be specified in one of two possible ways; Multiple line in which each element is on a line by itself
and Single line in which all elements of the array are specified on a single line

### Multiple Line Arrays
Append a pair of square brackets to indicate that the value would be an array. Specify each value on its own line. Start each value on its own line starting with indentation and followed by equals-space. The value begins from the first non-space character after the equals sign (=) up to the end of the line. End the array values with an empty element
```
	array-value[]
		= This is the first item in this array
		= This is the second item in this array
		= And this is the third item in this array
		=
```

If an array item is too long to fit on a single line, use the left angle (<) instead of equals. The surrounding spaces are required.
```
	another-array-value[]
		<	This array element is very,
			very long and cannot fit on
			a single line. Sorry 'bout
			that
		=	This is another element
		=	This is a third element
		=
```
The long line ends with either the next element of the array, or the end of the array

If an array element is a multi-line value, use the pipe (`|`) instead and follow up with the delimiter. The delimiter is the first non-whitespace character after the `|` up to the end of the line. The value ends on a line that contains only the delimiter possibly surrounded by whitespaces.

```
	third-array[]
		=	first element
		=	second element
		|	end value
			This is the third element
			It is a multi-line value
			It has 3 lines
			end value
		=	This is the fourth element
		=	This is the fifth
		=
```

### Single Line Arrays
By default, single line arrays are specified thus:
```
	my-single-line-array[] = element 1, element 2, this is element 3, and this is element 4
```
The elements of the array are simply separated with comma-space. Anything that is not comma-space belongs to an element.
Here are some other examples
```
	even-numbers[] = 2, 4, 6, 8, 10, 12
	the-gaang[] = Aang, Katara, Sokka, Toph, Zuko
```

#### Quoting Array Elements with Brackets
The four brackets '()', '[]', '{}', '<>' can be used to quote array elements
```
	parens-as-quotes[] = (first item) (this is the second) (and this is the third)
	square-brackets-as-quotes[] = [element number 1] [element number 2] [element number 3]
	use-braces[] = {this is the first} {this is the second} {this is the third}
	angular-brackets[] = <Aang> <Katara> <Sokka> <Toph> <Zuko>
```

#### Quoting Array Elements with Quotes.
When using any of backtick(\`), apostrophe('), and double-quotes("), each array element must be surrounded by the quoting character _**and**_ seperated by comma-space. For example:
```
	use-backtick-as-separator[] = `first`, `second`, `third`
	use-apostrophe-as-separator[] = 'first', 'second', 'third'
	use-double-quotes-separator[] = "first", "second", "third"
```

#### Separating array elements with spaces
There's a special case of assigning to an array while using the 'space' as the separator for the elements. Here's an
example of that. Prepend '@' to the name of the array to separate its elements with spaces. Everything not whitespace, would belong to an element. For example
```
	# This array has 4 elements in it
	@space-separated 1 2 3 elements

	# This is an array with 2 elements.
	@names toph beifong
```
Note the removal of the square brackets from the array's name.

## Sections
Surround section names with the section markers, i.e. open with 2 dashes and space/tab and
close with 2 space or tab followed by 2 spaces. Section names follow the same rules as variable
names. That is `[A-Za-z_][A-Za-z0-9_-]+`
```
	-- Section-1 --
		my-first-key = This is the first value
		my-second-key = This is the second value
		an-array[] = first, second, third, fourth
		races[]
			= air nomads
			= water tribe
			= earth kingdom
			= fire nation
			=
	-- Section-2 --
		song | END_SONG
			It's a long, long way to Ba Sing Se
			And girls in the city
			They're so pretty
		END_SONG

		therapy-section <
			Zuko, you must look within yourself,
			to find your true self. Oonly then
			will your true self find your other self

```
Arrays and key-value pairs are nested under sections. In derml, the beginning of a new section implies the ending of the
previous one. This means sections cannot be nested

## Percent Blocks and Strings
Percent Strings are lines that begin with the percent-space `% ` (there's a space after the '%' sign). These strings can contain anything programmers/authors of tools are free to make use of these strings as they see fit. 
```
	% This is a percent string.
```
Just like percent strings, there are also percent blocks which authors of tools can do anything they like with. The block is between a pair of `%%`.
```
	%%
		This is a percent block
		It begins with and ends with
		%% but does not include them
	%%
```
