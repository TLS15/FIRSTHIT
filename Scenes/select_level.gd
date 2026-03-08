extends PopupMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open("res://LevelData")
	var i:int = 1
	for file in dir:
		add_item("Level" + str(i))
		++i


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
