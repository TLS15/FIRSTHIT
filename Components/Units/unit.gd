extends Area2D

@export var health: int = 30
@export var damage: int = 30
@export var affiliation: TowerResource.Players


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
	position.x += 1
	
