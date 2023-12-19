extends Area2D

@export var text: String = ""
var _body_stack: Array[Node2D] = []



#
#	Signals
#

func _on_body_exited(body: Node2D):
	_body_stack.erase(body)
	
func _on_body_entered(body: Node2D):
	_body_stack.push_back(body)
	print("mar")

	if _body_stack.size() == 1:
		AreaTitleManager.show_title(text)
