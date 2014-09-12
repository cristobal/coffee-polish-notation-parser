###
	Polish Pref	ix Notation Parser
###

# PPN Module
PPN = {}

# Parse string into a plain array ast
PPN.parse = (string) ->
	n      = string.length - 1
	ast    = []
	start  = 0
	flag   = off

	SPACE = " "
	PARENS_LEFT  = "("
	PARENS_RIGHT = ")"

	# loop until no more characters
	for i in [0 .. n]
		char = string.charAt(i)

		# if char is space or parenthesis right and the collect flag is on
		# we collect the last exp from the substring(start, i).
		# Finally turn off the collect flag
		if (char is SPACE or
			  char is PARENS_RIGHT) and (flag is on)
			ast.push(
				string.substring(start, i))
			flag = off

		# if char is either parens left or right collect the char and continue loop
		if (char is PARENS_LEFT or
			  char is PARENS_RIGHT)
			ast.push(char)
			continue

		# if char is space continue loop
		if char is SPACE
			continue

		# if char is not space and is the last char we collect either the
		# last started expression or the last char depending on the collect flag
		if (char isnt SPACE) and (i is n)
			ast.push(
				if flag then string.substring(start, i + 1) else char
			)
			continue

		# start of expression set the start position.
		if (flag is off)
			flag  = on
			start = i
			continue

	ast

# Run the ast array
PPN.run = (ast) ->
	ast

PPN.eval = (string) ->
	@run(@parse (string))

console.log(PPN.eval "- 3 +  1  22")
