extends MarginContainer



var num_grids = 1
var current_slide = 1
var board_width = 1130
var cup_width = 188

@onready var boards: HBoxContainer = $VBoxContainer / HBoxContainer / Control / Boards
@onready var cups: HBoxContainer = $VBoxContainer / HBoxContainer2 / Control / Cups
@onready var carousel_container: CarouselContainer = $VBoxContainer / HBoxContainer / Control / CarouselContainer











func _on_left_button_pressed() -> void :
    carousel_container._left()


func _on_right_button_pressed() -> void :
    carousel_container._right()


func _on_button_pressed() -> void :
    SceneManager.change_scene("res://game-1/game_1.tscn")



func _on_beads_left_button_pressed() -> void :
    var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.tween_property(cups, "position:x", cups.position.x + cup_width, 0.5)


func _on_beads_right_button_pressed() -> void :
    var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.tween_property(cups, "position:x", cups.position.x - cup_width, 0.5)
