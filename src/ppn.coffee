###
	Polish Prefix Notation Parser
###

# TODO: Throw errors on unterminated/not matching/missing parens in expr ()
# TODO: Add functions defined in Wikipedia negation, conj etc...

# PPN Module
PPN = {}
PPN.__functions = {}

# Parse string into a plain ast array
PPN.parse = (string) ->
	n      = string.length - 1
	ast    = []
	start  = 0
	flag   = off

	PARENS_LEFT  = "("
	PARENS_RIGHT = ")"

	# delimiters
	# space, tab, carriage return(cr), newline(lf), cr+lf
	DELIMITERS = ///(
		\s|\t|\r|\n|\r\n
	)///

	# loop until no more characters
	for i in [0 .. n]
		char = string.charAt(i)
		isDelimiter = DELIMITERS.test(char)

		# if char is a delimiter or parenthesis right and the collect flag is on
		# we collect the last exp from the substring(start, i).
		# Finally turn off the collect flag
		if (isDelimiter or
			  char is PARENS_RIGHT) and (flag is on)
			ast.push(
				string.substring(start, i))
			flag = off

		# if char is either parens left or right collect the char and continue loop
		if (char is PARENS_LEFT or
			  char is PARENS_RIGHT)
			ast.push(char)
			continue

		# if char is a delimiter continue loop
		if isDelimiter
			continue

		# if char is not a delimiter and is the last char we collect either the
		# last started expression or the last char depending on the collect flag
		if (not isDelimiter) and (i is n)
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
	# Only base aritmetich math operators +-*/
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

	apply_function = (fun, args) ->
		args.reduce (a, b) ->
			fun(a, b)

	n = ast.length - 1
	for i in [n .. 0]
		symbol = ast[i]

		if symbol is EXPR_START
			while (arg = stack.pop()) and (arg isnt EXPR_START)
				args.push(arg)

			stack.push(args[0])

		# TODO: optimize below when all logic in place
		else if @__functions[symbol]?

			while (arg = stack.pop()) and (arg isnt EXPR_STOP)
				args.push(arg)

			stack.push(arg) if (arg is EXPR_STOP)

			stack.push(
				apply_function(@__functions[symbol], args))

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

# Define function by name
PPN.defun = (name, fun) ->
	@__functions[name] = fun

# Undefine function by name
PPN.undefun = (name) ->
	results = {}
	for key, fun of @__functions when key isnt name
		results[key] = fun

	@__functions = null
	@__functions = results
