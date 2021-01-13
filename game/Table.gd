extends TileMap

const TABLE_SIZE = Vector2(5,5)
enum SLOT {OCCUPIED, ALLOW, DENY, FIXED}

var rot_mat := Transform2D(Vector2(0, -1), Vector2(1, 0), Vector2.ZERO)

var current_piece : Piece

func _ready():
	for child in get_children():
		if child is Piece:
			child.connect("selected", self, "select_piece", [child])

func _input(event):
	
	if event is InputEventMouseButton:
		# Deselects currently held piece. It's handled here to avoid some hiccups
		if event.button_index == BUTTON_LEFT and not event.is_pressed():
			deselect_piece()
		
		# Handles piece rotation
		elif event.button_index == BUTTON_RIGHT and event.is_pressed():
			rotate_piece(get_canvas_transform().xform_inv(event.position))
	
	# Updates currently held cell position and table preview on mouse motion
	if event is InputEventMouseMotion:
		if(current_piece):
			update_piece_pos(event.relative)
			update_table()

func select_piece(piece):
	current_piece = piece
	current_piece.placed = false

func update_piece_pos(pos):
	current_piece.position += pos/scale # Adjust for scaling by 12

func rotate_piece(mouse_pos):
	if current_piece:
		var o_pos = current_piece.position
		var relative_pos = o_pos - to_local(mouse_pos)
		current_piece.position = Vector2.ZERO
		current_piece.rotation -= PI/2
		relative_pos = rot_mat.xform(relative_pos)
		current_piece.position = relative_pos + to_local(mouse_pos)
		
		for i in range(current_piece.relative_spaces.size()):
			get_piece_space()[i] = rot_mat.xform(get_piece_space()[i])
		
		print(current_piece.relative_spaces)
		update_table()

# Attempts to place a piece at a position.
func try_place_piece():
	
	var piece_pos = world_to_map(current_piece.position.round())
	
	if not is_in_board(piece_pos) or get_cellv(piece_pos) == SLOT.OCCUPIED or get_cellv(piece_pos) == SLOT.FIXED:
		return false
	
	for offset in get_piece_space():
		if not is_in_board(piece_pos + offset) or get_cellv(piece_pos + offset) == SLOT.OCCUPIED or get_cellv(piece_pos + offset) == SLOT.FIXED:
			return false
	
	return true

func deselect_piece():
	if(current_piece != null):
		
		var map_pos = world_to_map(current_piece.position.round())
		
		if(try_place_piece() == true):
			current_piece.placed = true
		else:
			current_piece.position = current_piece.original_position
			current_piece.placed = false
		
		current_piece = null
		update_table()
		check_completion()

func update_table():
	
	var occupied_slots = []
	
	for piece in get_children():
		if piece.placed:
			var pos = world_to_map(piece.position.round())
			occupied_slots.append(pos)
			for offset in piece.relative_spaces:
				occupied_slots.append(pos + offset)
	
	for y in range(TABLE_SIZE.y):
		for x in range(TABLE_SIZE.x):
			
			# Cleans the space
			set_cell(x, y, -1)
			
			# Draws an occupied slot if there is one
			if occupied_slots.has(Vector2(x,y)):
				set_cell(x, y, SLOT.OCCUPIED)
			else:
				# Draws the current piece placement preview (if there is one)
				if current_piece:
					var cur_piece_pos = world_to_map(current_piece.position.round())
					
					if(Vector2(x,y) == cur_piece_pos):
						set_cell(x, y, SLOT.ALLOW)
					
					for offset in current_piece.relative_spaces:
						if(Vector2(x,y) == cur_piece_pos + offset and is_in_board(cur_piece_pos + offset)):
							set_cell(x, y, SLOT.ALLOW)
						

func get_piece_space():
	return current_piece.relative_spaces

func check_completion():
	
	var required_pieces_placed = true
	for child in get_children():
		if child.victory_requirement == true and child.placed == false:
			required_pieces_placed = false
			break
	
	if required_pieces_placed == true:
		print("GAME ENDED")

func is_in_board(pos):
	var is_inside_x = pos.x >= 0 && pos.x < TABLE_SIZE.x
	var is_inside_y = pos.y >= 0 && pos.y < TABLE_SIZE.y
	
	return is_inside_x and is_inside_y
