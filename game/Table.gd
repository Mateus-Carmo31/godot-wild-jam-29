extends TileMap

const TABLE_SIZE = Vector2(6,6)

func _process(delta):
	var mouse_hover_pos = world_to_map(get_local_mouse_position())
	
	var is_inside_x = mouse_hover_pos.x >= -TABLE_SIZE.x/2 && mouse_hover_pos.x < TABLE_SIZE.x/2
	var is_inside_y = mouse_hover_pos.y >= -TABLE_SIZE.y/2 && mouse_hover_pos.y < TABLE_SIZE.y/2
	
	if(is_inside_x && is_inside_y):
		update_table(mouse_hover_pos)

func update_table(pos):
	
	# Get space occupied by piece (from center)
	var offsets = get_piece_space()
	
	for y in range(-TABLE_SIZE.y/2, TABLE_SIZE.y/2):
		for x in range(-TABLE_SIZE.x/2, TABLE_SIZE.x/2):
			# Check center
			if(Vector2(x,y) == pos):
				set_cell(x, y, 2)
				continue
			else:
				# Check offsets from center
				var matched = false
				for offset in offsets:
					if(Vector2(x,y) == pos + offset):
						set_cell(x, y, 2)
						matched = true
						break
				
				if(not matched):
					set_cell(x, y, 0)
			
	print(pos, pos + offsets[0], pos + offsets[1])

func get_piece_space():
	return [Vector2(-1,0), Vector2(1,0)]
