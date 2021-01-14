extends TextureButton

func _ready():
	$Panel.hide()

func _on_mouse_entered():
	if not disabled:
		$Panel.show()

func _on_mouse_exited():
	if not disabled:
		$Panel.hide()

func set_level_info(record_pieces, max_pieces, completed):
	$Panel/VBoxContainer/ItemsGot.text = "Pieces: %s/%s" % [record_pieces, max_pieces]
