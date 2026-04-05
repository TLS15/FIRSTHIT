extends Area2D


@export var affiliation: TowerResource.Players
@export var level: int = 1

var target_unit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.set_self_modulate(Color.RED)
	match affiliation:
		0: $Sprite2D.set_self_modulate(Color.DARK_BLUE)
		1: $Sprite2D.set_self_modulate(Color.GREEN)
		2: $Sprite2D.set_self_modulate(Color.DARK_RED)
		3: $Sprite2D.set_self_modulate(Color.YELLOW)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed: float = 100 + 100 * level
	if is_instance_valid(target_unit):
		global_position = global_position.move_toward(target_unit.global_position, speed * delta)
		
		if global_position.distance_to(target_unit.global_position) < 10:
			target_unit.damage(10 + 20 * level)
			queue_free()
	else: # maybe try the next enemy?
		queue_free()
