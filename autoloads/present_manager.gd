extends Node


var _collection: Dictionary = {}

#
#	Public Functions
#

func collect_present(type: String) -> void:
	_collection[type] = _collection.get(type, 0) + 1

func reset() -> void:
	_collection.clear()