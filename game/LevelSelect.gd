extends Control

export(Dictionary) var levels = {}

func _ready():
	for btn in get_children():
		btn.connect("pressed", self, "load_level", [levels[btn.name]])

func load_level(level):
	get_tree().change_scene(level)
