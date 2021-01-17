extends Node

const LEVELS = {
	"level0" : "res://src/Scenes/debug.tscn",
	"level1" : "res://src/Scenes/Levels/level1.tscn",
	"level2" : "res://src/Scenes/Levels/level2.tscn"
}

func get_level_by_id(id):
	return LEVELS[id]
