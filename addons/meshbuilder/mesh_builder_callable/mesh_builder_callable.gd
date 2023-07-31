tool
extends Node

class_name Callable

var object :Node
var function_name :String
var args :Array

func setup(object, function_name, args = []):
	self.object = object
	self.function_name = function_name
	self.args = args

func run(args = []):
	if not self.args.empty():
		object.callv(function_name, self.args)
	else:
		object.callv(function_name, args)
