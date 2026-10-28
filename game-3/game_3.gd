extends Control

@onready var base: Control = $Base
@onready var base_2: Control = $Base2
@export var testing: bool

func _ready() -> void :
    base.cup.visible = false
    base_2.cup.visible = false

func _on_african_math_banner_pressed():
    Global.clear_all()
    Global.reset_clear_all()
