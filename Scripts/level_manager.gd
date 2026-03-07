extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level(level: LevelResource):
	for tower in level.towers:
		var instance = load("res://Scenes/castle.tscn").instantiate()
		add_child(instance)
		instance.assign_resource(tower)
