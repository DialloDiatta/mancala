
@tool
extends EditorPlugin



const SIGNAL_LENS_EDITOR_PANEL = preload("res://addons/signal_lens/editor/signal_lens_editor_panel.tscn")



const AUTOLOAD_NAME = "SignalLens"


var debugger: SignalLensDebugger = null


var remote_node_inspector: SignalLensRemoteNodeInspector = null


var editor_panel: SignalLensEditorPanel = null




func initialize():

    debugger = SignalLensDebugger.new()
    remote_node_inspector = SignalLensRemoteNodeInspector.new()


    add_inspector_plugin(remote_node_inspector)
    add_debugger_plugin(debugger)


    setup_project_settings()



    remote_node_inspector.node_selected.connect(debugger.request_node_data_from_remote)


    editor_panel = SIGNAL_LENS_EDITOR_PANEL.instantiate()
    debugger.setup_editor_panel(editor_panel)



    debugger.received_node_data_from_remote.connect(editor_panel.draw_node_data)



    debugger.received_signal_emission_from_remote.connect(editor_panel.draw_signal_emission)



    editor_panel.node_data_requested.connect(debugger.request_node_data_from_remote)


    debugger.started.connect(editor_panel.start_session)
    debugger.stopped.connect(editor_panel.stop_session)



    remote_node_inspector.node_selected.connect(editor_panel.assign_node_path)



func setup_project_settings():

    var setting_resize_panel_on_open = "addons/Signal Lens/resize_panel_on_open"
    if not ProjectSettings.has_setting(setting_resize_panel_on_open):
        ProjectSettings.set_setting(setting_resize_panel_on_open, true)
    ProjectSettings.add_property_info({
        "name": setting_resize_panel_on_open, 
        "type": TYPE_BOOL, 
        "hint": TYPE_BOOL, 
        "hint_string": TYPE_BOOL
        })
    ProjectSettings.set_initial_value(setting_resize_panel_on_open, true)
    ProjectSettings.set_as_basic(setting_resize_panel_on_open, true)


    var setting_height_to_resize_to = "addons/Signal Lens/height_to_resize_to"
    if not ProjectSettings.has_setting(setting_height_to_resize_to):
        ProjectSettings.set_setting(setting_height_to_resize_to, 500)
    ProjectSettings.add_property_info({
        "name": setting_height_to_resize_to, 
        "type": TYPE_FLOAT, 
        "hint": TYPE_FLOAT, 
        "hint_string": TYPE_FLOAT
        })
    ProjectSettings.set_initial_value(setting_height_to_resize_to, 500)
    ProjectSettings.set_as_basic(setting_height_to_resize_to, true)



func cleanup():

    remove_debugger_plugin(debugger)
    remove_inspector_plugin(remote_node_inspector)


    remote_node_inspector = null
    debugger = null
    editor_panel = null




func _enter_tree() -> void :
    initialize()

func _exit_tree() -> void :
    cleanup()

func _enable_plugin():
    add_autoload_singleton(AUTOLOAD_NAME, "res://addons/signal_lens/autoload/signal_lens_autoload.gd")

func _disable_plugin():
    remove_autoload_singleton(AUTOLOAD_NAME)
