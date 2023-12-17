extends Node

var _current_checkpoint: Checkpoint = null

func flag_new_checkpoint(checkpoint: Checkpoint) -> void:
	if _current_checkpoint == checkpoint: return
	if _current_checkpoint: _current_checkpoint.set_flag_is_up(false)
	
	_current_checkpoint = checkpoint
	_current_checkpoint.set_flag_is_up(true)