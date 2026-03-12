extends Node2D
@export var tower_id: int
@export var tower_data: TowerResource
@export var occupants: int
@export var available_connections: int = 50
@export var affiliation: TowerResource.Players
var connections: Array[int]

signal press_received(tower_id)

func assign_resource(resource: TowerResource):
	tower_data = resource
	position = tower_data.location
	occupants = tower_data.occupants
	affiliation = tower_data.affiliation
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_pressed():
		#print("is pressed")
		emit_signal("press_received", tower_id)
