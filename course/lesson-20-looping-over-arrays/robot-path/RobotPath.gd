extends Node2D

const EXPECTED_PATH = [Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(2, 2), Vector2(3, 2), Vector2(4, 2), Vector2(5, 2)]

const LINE_WIDTH := 4
const COLOR_PATH := Color(0.14902, 0.776471, 0.968627)

export var board_size := Vector2(6, 4)
export var cell_size := Vector2(80, 80)

var board_size_px := cell_size * board_size

onready var robot := $Robot


func _ready() -> void:
	robot.position = cell_to_position(Vector2.ZERO)


# EXPORT run
var robot_path = [Vector2(1, 0), Vector2(1, 1), Vector2(1, 2), Vector2(2, 2), Vector2(3, 2), Vector2(4, 2), Vector2(5, 2)]

func run():
	for cell in robot_path:
		robot.move_to(cell)
# /EXPORT run


func _run():
	robot.points.clear()
	robot.move_queue.clear()
	robot.position = cell_to_position(Vector2.ZERO)
	run()
	update()
	yield(robot, "goal_reached")
	Events.emit_signal("practice_run_completed")


# Draws a board grid centered on the node + motion path
func _draw() -> void:
	for x in range(board_size.x):
		for y in range(board_size.y):
			draw_rect(
				Rect2(Vector2(x, y) * cell_size - board_size_px / 2.0, Vector2.ONE * cell_size),
				Color.white,
				false,
				LINE_WIDTH
			)

	var points := PoolVector2Array([cell_to_position(Vector2.ZERO)])
	for cell in robot_path:
		points.append(cell_to_position(cell))
	draw_polyline(points, COLOR_PATH, LINE_WIDTH)


func cell_to_position(cell: Vector2):
	return cell * cell_size - board_size_px / 2.0 + cell_size / 2.0
