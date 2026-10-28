


@tool
class_name SignalLensEditorPanel
extends Control



const TUTORIAL_TEXT: String = "Select a node in the remote scene"



const DEFAULT_EMISSION_DURATION: float = 1.0



const DEFAULT_CONNECTION_OPACITY: float = 0.3



enum Direction{LEFT, RIGHT}


signal node_data_requested(node_path)


var current_node: NodePath = ""



var block_new_inspections: bool = false


var keep_emissions: bool = false



var emission_speed_multiplier: float = 1.0



var pulsing_connections: Array = []


@export var graph_edit: GraphEdit
@export var node_path_line_edit: LineEdit
@export var refresh_button: Button
@export var clear_button: Button
@export var inactive_text: Label
@export var warning_text: Label
@export var pin_checkbox: CheckButton
@export var keep_emissions_checkbox: CheckButton
@export var emission_speed_slider: Slider
@export var emission_speed_icon: Button


func _ready() -> void :
    _get_parent_editor_split()
    clear_button.icon = EditorInterface.get_base_control().get_theme_icon("Clear", "EditorIcons")
    refresh_button.icon = EditorInterface.get_base_control().get_theme_icon("Reload", "EditorIcons")
    pin_checkbox.icon = EditorInterface.get_base_control().get_theme_icon("Pin", "EditorIcons")
    keep_emissions_checkbox.icon = EditorInterface.get_base_control().get_theme_icon("Override", "EditorIcons")
    emission_speed_icon.icon = EditorInterface.get_base_control().get_theme_icon("Timer", "EditorIcons")


func request_node_data():
    node_data_requested.emit(current_node)



func receive_node_data(data: Array):
    draw_node_data(data)


func start_session():
    clear_graph()
    pin_checkbox.button_pressed = false
    keep_emissions_checkbox.button_pressed = false
    emission_speed_slider.editable = true
    emission_speed_icon.disabled = false
    node_path_line_edit.placeholder_text = TUTORIAL_TEXT
    inactive_text.hide()



func stop_session():
    clear_graph()
    pin_checkbox.disabled = true
    keep_emissions_checkbox.disabled = true
    refresh_button.disabled = true
    clear_button.disabled = true
    emission_speed_slider.editable = false
    emission_speed_icon.disabled = true
    node_path_line_edit.text = ""
    pin_checkbox.button_pressed = false
    keep_emissions_checkbox.button_pressed = false
    inactive_text.show()
    warning_text.hide()
    warning_text.text = ""



func assign_node_path(target_node: NodePath):

    if block_new_inspections: return


    refresh_button.disabled = target_node.is_empty()


    current_node = target_node


    node_path_line_edit.text = current_node






func clear_graph():

    if graph_edit.get_child_count() == 0: return


    clean_connection_activity()

    for child: Node in graph_edit.get_children():





        if child.name == "_connection_layer": continue
        child.free()

    graph_edit.minimap_enabled = false
    graph_edit.minimap_enabled = true






func draw_node_data(data: Array):

    if block_new_inspections: return


    clear_graph()





    await get_tree().create_timer(0.1).timeout


    var target_node_name = data[0]


    if target_node_name == "Root":
        warning_text.show()
        warning_text.text = "Root node inspection is not supported."
        return
    else:
        warning_text.hide()


    var target_node_signal_data: Array = data[1]



    var target_node: SignalLensGraphNode = create_node(target_node_name, "(Signals)")
    graph_edit.add_child(target_node)

    var current_signal_index = 0


    for signal_data in target_node_signal_data:

        var slot_color = get_slot_color(current_signal_index, target_node_signal_data.size())

        create_button_slot(signal_data["signal"], target_node, Direction.RIGHT, slot_color)


        var callables_for_current_signal = signal_data["callables"]
        for callable_index in range(callables_for_current_signal.size()):
            var object_name: String = callables_for_current_signal[callable_index]["object_name"]
            var callable_method: String = callables_for_current_signal[callable_index]["method_name"]



            if graph_edit.has_node(object_name):
                var callable_node = graph_edit.get_node(object_name)





                if callable_node.name == target_node.name:
                    var target_callables_node
                    if !graph_edit.has_node(target_node_name + " (Callables)"):
                        target_callables_node = create_node(target_node_name + " (Callables)")
                        graph_edit.add_child(target_callables_node)
                        target_callables_node.position_offset += Vector2(250, 0)
                    else:
                        target_callables_node = get_node(target_node_name + " (Callables)")
                    create_button_slot(callable_method, target_callables_node, Direction.LEFT, slot_color)
                    graph_edit.connect_node(target_node.name, current_signal_index, target_callables_node.name, target_callables_node.get_child_count() - 1)
                else:
                    create_button_slot(callable_method, callable_node, Direction.LEFT, slot_color)
                    graph_edit.connect_node(target_node.name, current_signal_index, callable_node.name, callable_node.get_child_count() - 1)
            else:
                var callable_node: SignalLensGraphNode = create_node(object_name, "(Callables)")
                create_button_slot(callable_method, callable_node, Direction.LEFT, slot_color)
                graph_edit.add_child(callable_node)


                callable_node.position_offset += Vector2(callable_node.get_index() * 250, callable_node.get_index() * 50)
                graph_edit.connect_node(target_node.name, current_signal_index, callable_node.name, callable_node.get_child_count() - 1)

        current_signal_index += 1



    if clear_button.disabled:
        clear_button.disabled = false
    if pin_checkbox.disabled:
        pin_checkbox.disabled = false
    if keep_emissions_checkbox.disabled:
        keep_emissions_checkbox.disabled = false
    if emission_speed_slider.editable:
        emission_speed_slider.editable = true
        emission_speed_icon.disabled = false

func create_node(node_name: String, title_appendix: String = "") -> SignalLensGraphNode:
    var new_node = SignalLensGraphNode.new()
    new_node.name = node_name
    new_node.title = node_name + " " + title_appendix
    return new_node

func create_button_slot(button_text: String, parent_node: GraphNode, slot_direction: Direction, slot_color: Color):
    var signal_button: Button = Button.new()
    signal_button.flat = true
    signal_button.name = button_text
    signal_button.text = button_text
    parent_node.add_child(signal_button)
    signal_button.pressed.connect(_on_signal_button_pressed.bind(parent_node, signal_button.get_index()))
    signal_button.focus_exited.connect(clean_connection_activity)
    parent_node.set_slot(signal_button.get_index(), slot_direction == Direction.LEFT, 0, slot_color, slot_direction == Direction.RIGHT, 0, slot_color)

func get_slot_color(slot_index, signal_amount) -> Color:
    var hue = float(slot_index) / float(signal_amount)
    return Color.from_hsv(hue, 1.0, 0.5, DEFAULT_CONNECTION_OPACITY)

func clean_connection_activity():
    for connection in graph_edit.get_connection_list():
        graph_edit.set_connection_activity(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"], 0)





func draw_signal_emission(data: Array):

    if graph_edit.get_child_count() <= 1: return
    var target_node: GraphNode = graph_edit.get_child(1)
    var port_index = get_port_index_from_signal_name(data[1])
    if port_index == -1: return
    for connection in graph_edit.get_connection_list():
        if connection["from_node"] == target_node.name && connection["from_port"] == port_index:
            pulse_connection(connection)


func pulse_connection(connection: Dictionary) -> void :
    if connection not in pulsing_connections: pulsing_connections.append(connection)

    var from_node = connection["from_node"]
    var from_port = connection["from_port"]
    var to_node = connection["to_node"]
    var to_port = connection["to_port"]

    if keep_emissions:
        graph_edit.set_connection_activity(from_node, from_port, to_node, to_port, 1.0)
    else:
        fade_out_connection(connection)

func fade_out_connection(connection: Dictionary):
    var tween: = create_tween()
    var fade_out_duration = DEFAULT_EMISSION_DURATION * emission_speed_multiplier
    var from_node = connection["from_node"]
    var from_port = connection["from_port"]
    var to_node = connection["to_node"]
    var to_port = connection["to_port"]

    tween.tween_method(
        func(value): graph_edit.set_connection_activity(from_node, from_port, to_node, to_port, value), 1.0, 0.0, fade_out_duration
    ).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

    tween.tween_callback( func(): pulsing_connections.erase(connection))

func get_port_index_from_signal_name(signal_name: String):
    var target_node = graph_edit.get_child(1)
    for child in target_node.get_children():
        if child.name == signal_name:
            return child.get_index()
    return -1

func keep_signal_emissions():
    keep_emissions = true

func dont_keep_signal_emissions():
    for connection in pulsing_connections:
        fade_out_connection(connection)
    keep_emissions = false








var _editor_dock



var _original_panel_size: float


func _get_parent_editor_split():
    var base = EditorInterface.get_base_control()
    var waiting: = base.get_children()
    while not waiting.is_empty():
        var node: = waiting.pop_back() as Node
        if node.name.find("DockVSplitCenter") >= 0:
            _editor_dock = node
            _original_panel_size = _editor_dock.split_offset
            if visible:
                _resize_panel( - ProjectSettings.get_setting("addons/Signal Lens/height_to_resize_to"))
            else:
                _resize_panel(0)
        else:
            waiting.append_array(node.get_children())


func _resize_panel(new_size: float):
    if _can_resize_panel():
        _editor_dock.split_offset = new_size


func _can_resize_panel() -> bool:

    if not ProjectSettings.get_setting("addons/Signal Lens/resize_panel_on_open"): return false


    if not _editor_dock: return false
    return true


func _on_visibility_changed() -> void :

    if visible and is_visible_in_tree():
        _resize_panel( - ProjectSettings.get_setting("addons/Signal Lens/height_to_resize_to"))
    else:
        _resize_panel(_original_panel_size)






func _on_refresh_button_pressed() -> void :
    if current_node.is_empty(): return
    request_node_data()

func _on_signal_button_pressed(graph_node: GraphNode, internal_index: int):
    graph_edit.set_selected(null)
    clean_connection_activity()
    for connection in graph_edit.get_connection_list():
        if (connection["from_node"] == graph_node.name && connection["from_port"] == internal_index) or (connection["to_node"] == graph_node.name && connection["to_port"] == internal_index):
            graph_edit.set_connection_activity(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"], 0.75)

func _on_graph_edit_node_selected(node: Node) -> void :
    var graph_node = node as GraphNode
    for connection in graph_edit.get_connection_list():
        if connection["to_node"] == graph_node.name:
            graph_edit.set_connection_activity(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"], 0.75)

func _on_graph_edit_node_deselected(node: Node) -> void :
    var graph_node = node as GraphNode
    for connection in graph_edit.get_connection_list():
        if connection["to_node"] == graph_node.name:
            graph_edit.set_connection_activity(connection["from_node"], connection["from_port"], connection["to_node"], connection["to_port"], 0)

func _on_clear_button_pressed() -> void :
    clear_graph()

func _on_repo_button_pressed() -> void :
    OS.shell_open("https://github.com/yannlemos/signal-lens")

func _on_pin_checkbox_toggled(toggled_on: bool) -> void :
    block_new_inspections = toggled_on

func _on_emission_speed_slider_value_changed(value: float) -> void :
    emission_speed_multiplier = value

func _on_keep_emissions_checkbox_toggled(toggled_on: bool) -> void :
    if toggled_on:
        keep_signal_emissions()
    else:
        dont_keep_signal_emissions()
