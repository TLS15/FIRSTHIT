extends Area2D

@export var health: int = 30
@export var damage: int = 30
@export var affiliation: TowerResource.Players = TowerResource.Players.GREEN # Only for testing


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += 1
	
