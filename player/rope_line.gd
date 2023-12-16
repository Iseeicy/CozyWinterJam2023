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

func _physics_process(_delta):
	points[1] = to_local(ropeOrigin.global_position)


func _on_grapple_a_shot_grapple():
	points[1] = Vector2.ZERO

func _on_grapple_a_unshot_grapple():
	points[1] = Vector2.ZERO
