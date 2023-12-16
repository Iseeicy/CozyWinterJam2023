extends Line2D

#
#	Exports
#

## Where the rope should originate from.
@export var ropeOrigin: Node2D = null

#
#	Godot Functions
#

func _ready():
	points.clear()

func _process(_delta):
	points[1] = to_local(ropeOrigin.global_position)
