extends Node2D
@export var tower_id: int
@export var tower_data: TowerResource
@export var occupants: int
@export var available_connections: int = 50
var connections: Array[int]

signal press_received(tower_id)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func assign_resource(resource: TowerResource):
	tower_data = resource
	position = tower_data.location
	occupants = tower_data.occupants
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		#print("is pressed")
		emit_signal("press_received", tower_id)

		
