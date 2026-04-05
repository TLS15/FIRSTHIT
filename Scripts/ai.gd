extends Node2D
var towers: Array
var friendly_towers: Array
var enemy_towers: Array
var frontline_tower
var weak_point
var enemy_weak_point
var affiliation = TowerResource.Players.RED
var towers_score = {}

func sense():
	towers = $"../../LevelManager".towers
	for tower in towers:
		towers_score.get_or_add(tower, 0)
		if affiliation == tower.affiliation:
			friendly_towers.append(tower)
		else:
			enemy_towers.append(tower)

	for tower in towers: # score for health
		towers_score.set(tower, towers_score.get(tower) + tower.health)
		
		for connected_tower in tower.connections:
			if connected_tower.affiliation == affiliation: # For each connection 20 score
				towers_score.set(connected_tower,towers_score.get(connected_tower) + 20)
			else:
				towers_score.set(connected_tower,towers_score.get(connected_tower) - 20)
				

func think():
	var weakest_score = 999
	for tower in towers:
		if towers_score.get(tower) < weakest_score:
			weakest_score = towers_score.get(tower)
			weak_point = tower
		
	
func act():
	for tower in friendly_towers: 
		if tower.available_connections > 0 and tower != weak_point:
			connect_towers(tower, weak_point)

func connect_towers(origin, target):
	$"../../LevelManager".ai_add_connection(origin.tower_id, target.tower_id)

	

func _on_proccess_timeout() -> void:
	sense()
	think()
	act()
