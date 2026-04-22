# Represents a response which includes its text, the line that it goes to, and if it exits
class_name Response
var Text: String
var LineId: int
var Exits: bool

func _init(text, line, exits):
	Text = text
	LineId = line
	Exits = exits
