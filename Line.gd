# Represents a line of dialogue including its text and a list of responses
class_name Line
var TextList: Array
var Responses: Array[int]

func _init(text_list, responses):
	TextList = text_list
	Responses = responses
