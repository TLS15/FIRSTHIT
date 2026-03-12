extends PopupMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void: # removing the underscore breaks the function
	var levels_available: int = ResourceLoader.list_directory("res://LevelData").size()
	
	var i: int = 0
	while i < levels_available:
		i += 1
		add_item("Level" + str(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
