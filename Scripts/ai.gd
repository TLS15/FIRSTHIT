extends Node2D
var towers: Array
var friendly_towers: Array
var enemy_towers: Array
var frontline_tower
var weak_point
var enemy_weak_point
var affiliation = TowerResource.Players.RED
var towers_score = {}
var keys: Array

func sense():
	towers_score.clear()
	friendly_towers.clear()
	enemy_towers.clear()
	keys.clear()
	
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
	
	keys = towers_score.keys()

	keys.sort_custom(func(a, b):
		return towers_score[a] < towers_score[b]
	)

func think():
	#var weakest_score = 999
	#for tower in towers:
		#if towers_score.get(tower) < weakest_score:
			#weakest_score = towers_score.get(tower)
			#weak_point = tower
	pass	
	
func act():
	
	for tower in keys: # searches for weakest ally tower and upgrades
		if tower.affiliation == affiliation:
			tower.set_level(tower.level + 1)
			break

	#for tower in friendly_towers: 
		#if tower.get_available_connections() > 0 and tower != weak_point and !tower.connections.has(weak_point):
			#connect_towers(tower, weak_point)
	# Try to attack, reinforce the lowest tower
	
	for tower in friendly_towers: 
		if tower.get_available_connections() > 0: # and tower != weak_point and !tower.connections.has(weak_point):
			for weak_tower in keys:
				if connect_towers(tower, weak_tower):
					break

func connect_towers(origin, target) -> bool:
	if $"../../LevelManager".line_is_colliding(origin, target) or origin == target or origin.connections.has(target):
		return false
	$"../../LevelManager".add_connection(origin, target)
	return true
	

func _on_proccess_timeout() -> void:
	sense()
	think()
	act()
