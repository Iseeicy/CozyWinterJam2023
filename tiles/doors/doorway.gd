extends Node2D
class_name Doorway

@export var currency_type: String = ""
@export var required_currency: int = 5
@export var collider: CollisionShape2D = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	PresentManager.collected_updated.connect(_on_present_collection_updated.bind())

func _on_present_collection_updated(held: Dictionary, saved: Dictionary):
	var count = held.get(currency_type, []).size() + saved.get(currency_type, []).size()
	call_deferred("_set_open", count >= required_currency)

func _set_open(is_open: bool):
	animated_sprite.animation = "open" if is_open else "closed"
	collider.disabled = is_open
