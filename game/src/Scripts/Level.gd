extends Node

export var level_id = ""

onready var pack_button = $UI/Control/PackButton
onready var table = $Table
onready var pause_menu = $UI/Control/PauseMenu

func _ready():
	pause_menu.hide()

# There's a bug when you hold down the pack button while the pause menu is on,
# but honestly I don't know how to fix it
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.visible = !pause_menu.visible

func _on_Table_table_updated(level_completed):
	pack_button.disabled = !level_completed

func _on_PackButton_pressed():
	GameDataHandler.complete_level(level_id, table.currently_placed_pieces)
	get_tree().change_scene("res://src/Scenes/level_select.tscn") # Is this safe? no. Does it work? yes

func restart_level():
	get_tree().change_scene(LevelScenes.get_level_by_id(level_id))
	print("Restarted level.")
