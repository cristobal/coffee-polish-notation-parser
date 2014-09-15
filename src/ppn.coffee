###
	Polish Prefix Notation Parser
###

# TODO: Support for ^, log, %
# TODO: Support for other extra math functions
# TODO: Throw errors on unterminated/not matching/missing parens in expr ()

# PPN Module
PPN = {}

# Parse string into a plain ast array
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
	OPERATORS = ///(
		\+|\-|\*|\/
	)///

	EXPR_START = "("
	EXPR_STOP  = ")"

	stack = []
	args  = []

	apply_operator = (op, args) ->
  	args.reduce (a, b) ->
  		eval("#{a} #{op} #{b}")

	n = ast.length - 1
	for i in [n .. 0]
		symbol = ast[i]

		if symbol is EXPR_START
			while (arg = stack.pop()) and (arg isnt EXPR_START)
				args.push(arg)

			stack.push(args[0])

		else if OPERATORS.test(symbol)
			while (arg = stack.pop()) and (arg isnt EXPR_STOP)
				args.push(arg)

			stack.push(arg) if (arg is EXPR_STOP)
			stack.push(
				apply_operator(symbol, args))

		else
			stack.push(symbol)

		while args.length
			args.pop()

	stack[0]

# Evualuate expression
PPN.eval = (string) ->
	@run(@parse (string))

