extends Area2D

signal player_entered()
signal player_exited()

var _body_stack: Array[Node2D] = []

#
#	Signals
#

func _on_body_exited(body: Node2D):
	var old_size = _body_stack.size()
	_body_stack.erase(body)
	
	if old_size != 0 and _body_stack.size() == 0:
		player_exited.emit()
	
func _on_body_entered(body: Node2D):
	var old_size = _body_stack.size()
	_body_stack.push_back(body)

	if old_size == 0 and _body_stack.size() != 0:
		player_entered.emit()
