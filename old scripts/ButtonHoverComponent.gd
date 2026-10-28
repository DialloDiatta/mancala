
extends Control
class_name ButtonHoverComponent


@export var tween_intensity: float = 1.03
@export var tween_duration: float = 0.1

@onready var button = get_parent()


func _ready() -> void :
    button.mouse_entered.connect(_on_mouse_entered)
    button.mouse_exited.connect(_on_mouse_exited)


    button.pivot_offset = button.size / 2


func start_tween(object: Object, property: String, final_val: Variant, duration: float):
    var tween = create_tween()
    tween.tween_property(object, property, final_val, duration)

func _on_mouse_entered():
    print("something")
    start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)

func _on_mouse_exited():
    start_tween(button, "scale", Vector2.ONE, tween_duration)
