###
	Polish Pref	ix Notation Parser
###

# PPN Module
PPN = {}

# Parse string into a plain array ast
PPN.parse = (string) ->
	ast    = []
	start  = 0
	flag   = off

	# loop until no more characters
	for i in [0 .. string.length]
		char = string.charAt(i)

		# if either `(` or `)`
		if (char is "(" or char is ")") and (not flag)
			ast.push(char)
			continue

		if (flag is on) and char is " "
			ast.push(
				string.substring(start, i))
			flag = off

		if (flag is off) and char is ""
			continue

		if (flag is off)
			flag  = on
			start = i

	ast

# Run the ast array
PPN.run = (ast) ->
	ast

PPN.eval = (string) ->
	@run(@parse (string))

console.log(PPN.eval "(- 3 (+  1  2))")
