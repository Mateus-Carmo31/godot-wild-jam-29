extends Node

export var level_id = ""

onready var pack_button = $UI/Control/PackButton
onready var table = $Table
onready var end_level_screen = $UI/Control/EndLevelScreen
onready var anim_player = $AnimationPlayer


# Does a little reveal effect on the end screen, and also sets it up
# TODO: add sfx
func set_up_end_level_screen(placed_pieces, total_pieces):
	
	end_level_screen.get_node("CompleteText").show()
	
	# These timers just help control the flow of the display
	yield(get_tree().create_timer(0.5), "timeout")
	
	for piece_display in end_level_screen.get_node("ItemsGotten").get_children():
		if placed_pieces.has(piece_display.name):
			piece_display.visible = true
		
		yield(get_tree().create_timer(0.5), "timeout")
	
	end_level_screen.get_node("PieceNum").text = "Objects: %s out of %s" % [placed_pieces.size(), total_pieces]
	end_level_screen.get_node("PieceNum").show()
	
	end_level_screen.get_node("Retry").show()
	end_level_screen.get_node("Continue").show()

func _on_Table_table_updated(level_completed):
	pack_button.disabled = !level_completed
	
	if table.current_piece:
		$UI/Control/DioramaBubble.show()
		if table.current_piece.victory_requirement:
			$UI/Control/DioramaBubble/Label.text = table.current_piece.name + "!"
		else:
			$UI/Control/DioramaBubble/Label.text = table.current_piece.name
	else:
		$UI/Control/DioramaBubble.hide()

func _on_PackButton_pressed():
	
	# None of that gamebreaking, double click bullshit
	pack_button.disabled = true
	
	# Gathers info on the pieces in the table, then feeds it to the handler
	var placed_pieces = []
	var total_pieces = 0
	
	for piece in table.get_children():
		total_pieces += 1
		if piece.placed:
			placed_pieces.append(piece.name)
	
	GameDataHandler.complete_level(level_id, placed_pieces.size())
	
	anim_player.play("TransitionOut")
	yield(anim_player, "animation_finished")
	
	end_level_screen.show()
	
	anim_player.play("TransitionIn")
	yield(anim_player, "animation_finished")
	
	set_up_end_level_screen(placed_pieces, total_pieces)

func restart_level():
	get_tree().change_scene(LevelScenes.get_level_by_id(level_id))
	print("Restarted level.")

func _on_Level_Select_pressed():
	anim_player.play("TransitionOut")
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://src/Scenes/LevelSelect.tscn") # Is this safe? no. Does it work? yes

func _on_Continue_pressed():
	anim_player.play("TransitionOut")
	yield(anim_player, "animation_finished")
	get_tree().change_scene("res://src/Scenes/LevelSelect.tscn")
