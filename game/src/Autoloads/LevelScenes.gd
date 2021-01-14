extends Node

const LEVELS = {
	"level0" : "res://src/Scenes/debug.tscn"
}

func get_level_by_id(id):
	return LEVELS[id]
