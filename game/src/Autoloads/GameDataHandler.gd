extends Node

var game_save = "user://game_save.save"

# Level Data structure
#
#	id (Level Number):
#	{
#		item_num (Number of items in level)
#		items_got (Number of items acquired)
#		unlocked
#		completed
#	}

var level_data = {}

func _ready():
	load_level_data()

func complete_level(level_id, score_num):
	
	if not level_data.has(level_id):
		printerr("Level data dict does not contain id!")
		return
	
	# Update level information in the data dictionary
	level_data[level_id].completed = true
	if level_data[level_id].items_got < score_num:
		level_data[level_id].items_got = score_num
	
	# Unlocks all the levels the completed level would unlock
	for id in level_data[level_id].unlocks:
		if level_data.has(id):
			level_data[id].unlocked = true
		else:
			printerr("Level data dict does not contain id!")

func save_level_data(_level_data = null):
	print(_level_data)

# TODO: Implement actual saving in a file
func load_level_data():
	var dummy_data = {
		"level0" : {
			"item_num" : 6,
			"items_got" : 0,
			"unlocked" : true,
			"completed" : false,
			"unlocks" : ["level1"]
		},
		"level1" : {
			"item_num" : 6,
			"items_got" : 0,
			"unlocked" : false,
			"completed" : false,
			"unlocks" : []
		}
	}
	level_data = dummy_data

func get_level_data():
	return level_data
