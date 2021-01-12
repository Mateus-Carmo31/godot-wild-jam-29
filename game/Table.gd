extends TileMap

const TABLE_SIZE = Vector2(5,5)

var current_piece : Piece

func _ready():
	for child in get_child(0).get_children():
		if child is Piece:
			child.connect("selected", self, "select_piece", [child])
#			child.connect("deselected", self, "deselect_piece")

func _input(event):
	# Deselects currently held piece. It's handled here to avoid some hiccups
	if event is InputEventMouseButton:
		if not event.is_pressed():
			deselect_piece()
	
	# Updates currently held cell position and table preview on mouse motion
	if event is InputEventMouseMotion:
		if(current_piece):
			update_piece_pos(event.relative)
			
			if(is_in_board(world_to_map(current_piece.position.round()))):
				update_table()

func select_piece(piece):
	current_piece = piece
	current_piece.is_placed = false

func update_piece_pos(pos):
	current_piece.position += pos

# Attempts to place a piece at a position.
# TODO: check if space is occupied as well
func try_place_piece():
	
	var piece_pos = world_to_map(current_piece.position.round())
	
	if not is_in_board(piece_pos):
		return false
	
	for offset in get_piece_space():
		if not is_in_board(piece_pos + offset):
			return false
	
	return true

func deselect_piece():
	if(current_piece != null):
		
		var map_pos = world_to_map(current_piece.position.round())
		
		if(try_place_piece() == true):
			current_piece.is_placed = true
		else:
			current_piece.position = current_piece.original_position
			current_piece.is_placed = false
		
		current_piece = null
		update_table()

func update_table():
	
	var occupied_slots = []
	
	for piece in get_child(0).get_children():
		if piece.is_placed:
			var pos = world_to_map(piece.position.round())
			occupied_slots.append(pos)
			for offset in piece.relative_spaces:
				occupied_slots.append(pos + offset)
	
	for y in range(-TABLE_SIZE.y/2, ceil(TABLE_SIZE.y/2)):
		for x in range(-TABLE_SIZE.x/2, ceil(TABLE_SIZE.x/2)):
			
			# Cleans the space
			set_cell(x, y, -1)
			
			# Draws an occupied slot if there is one
			if occupied_slots.has(Vector2(x,y)):
				set_cell(x, y, 1)
			else:
				# Draws the current piece placement preview (if there is one)
				if current_piece:
					var cur_piece_pos = world_to_map(current_piece.position.round())
					
					if(Vector2(x,y) == cur_piece_pos):
						set_cell(x, y, 2)
					
					for offset in current_piece.relative_spaces:
						if(Vector2(x,y) == cur_piece_pos + offset and is_in_board(cur_piece_pos + offset)):
							set_cell(x, y, 2)
						

func get_piece_space():
	return current_piece.relative_spaces

func is_in_board(pos):
	var is_inside_x = pos.x >= -TABLE_SIZE.x/2 && pos.x < TABLE_SIZE.x/2
	var is_inside_y = pos.y >= -TABLE_SIZE.y/2 && pos.y < TABLE_SIZE.y/2
	
	return is_inside_x and is_inside_y
