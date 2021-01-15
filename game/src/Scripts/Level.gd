extends Node

export var level_id = ""

onready var pack_button = $UI/Control/PackButton
onready var table = $Table
onready var pause_menu = $UI/Control/PauseMenu
onready var end_level_screen = $UI/Control/EndLevelScreen

func _ready():
	pause_menu.hide()

# There's a bug when you hold down the pack button while the pause menu is on,
# but honestly I don't know how to fix it
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.visible = !pause_menu.visible

func toggle_pause():
	if end_level_screen.visible == false:
		pause_menu.visible = !pause_menu.visible

func set_up_end_level_screen(placed_pieces, total_pieces):
	
	for piece_display in end_level_screen.get_node("ItemsGotten").get_children():
		if placed_pieces.has(piece_display.name):
			piece_display.visible = true
	
	end_level_screen.get_node("PieceNum").text = "Pieces: %s out of %s" % [placed_pieces.size(), total_pieces]
	
	end_level_screen.show()

func _on_Table_table_updated(level_completed):
	pack_button.disabled = !level_completed

func _on_PackButton_pressed():
	
	var placed_pieces = []
	var total_pieces = 0
	
	for piece in table.get_children():
		total_pieces += 1
		if piece.placed:
			placed_pieces.append(piece.name)
	
	set_up_end_level_screen(placed_pieces, total_pieces)
	GameDataHandler.complete_level(level_id, placed_pieces.size())

func _on_Resume_pressed():
	pause_menu.visible = false

func restart_level():
	get_tree().change_scene(LevelScenes.get_level_by_id(level_id))
	print("Restarted level.")

func _on_Level_Select_pressed():
	get_tree().change_scene("res://src/Scenes/LevelSelect.tscn") # Is this safe? no. Does it work? yes

func _on_Continue_pressed():
	get_tree().change_scene("res://src/Scenes/LevelSelect.tscn")
