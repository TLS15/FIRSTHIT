extends Area2D


@export var affiliation: TowerResource.Players
@export var level: int = 1

var target_unit
var target_position: Vector2


func _ready() -> void:
	TowerResource.match_color_to_team($Sprite2D, affiliation)



func _process(delta: float) -> void:
	var speed: float = 100 + 100 * level
	if is_instance_valid(target_unit):
		target_position = target_unit.global_position


	global_position = global_position.move_toward(target_position, speed * delta)

	if global_position.distance_to(target_position) < 10:
		if is_instance_valid(target_unit):
			target_unit.damage(10 + 20 * level)
		queue_free()
