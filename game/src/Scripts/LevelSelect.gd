extends Control

var level_data : Dictionary

onready var buttons = $Buttons

func _ready():
	# Gets save data level information
	level_data = GameDataHandler.get_level_data()
	
	# Links the level loading with every button, and associates the save data with each level tooltip
	for btn in buttons.get_children():
		btn.connect("pressed", self, "load_level", [btn.name])
		
		if level_data[btn.name].unlocked == false:
			btn.disabled = true
		else:
			btn.set_level_info(level_data[btn.name].items_got,
							   level_data[btn.name].item_num,
							   level_data[btn.name].completed)

func load_level(id):
	get_tree().change_scene(LevelScenes.get_level_by_id(id))
	print("Changing level to " + id)
