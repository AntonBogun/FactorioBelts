#Godot 4.0
extends GraphEdit

var screen:Control
var popup:BeltCreatePopup

func test(a,b,c):
	prints(a,b,c)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen=get_parent()
	popup=screen.get_node("BeltCreate")
	popup.connect_to_signal(create_node)
	#print(Callable.a)

func to_graph_coordinates(screen_pos: Vector2):
	return (screen_pos+scroll_offset)/zoom;

func create_node(node_id: int, screen_pos: Vector2):
#	prints("screen_pos, scroll_offset, zoom:", zoom, screen_pos, scroll_offset) 
	
	var graph_pos = to_graph_coordinates(screen_pos)
	
#	prints("graph pos:", graph_pos)

	var node=preload("res://graph_node.tscn").instantiate()
	node.init(popup.id_to_name(node_id))
	add_child(node)
	# node.finalize_slots()
#	prints("ACTUAL",node.get_child(0).get_child(0).size)
	node.connect_to_delete(del_node.bind(node.name))
	node.position_offset=graph_pos



var LM_delay=0.05
var LM_timer=0
var LM_pressed=false

func _input(event:InputEvent):
	#set popup visible and at position of MouseClick
	if event is InputEventMouseMotion:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
#				print("right click on graph")
				if popup.is_visible():
					popup.hide()
				popup.show_popup(get_global_mouse_position())
				LM_timer=0
			return
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and popup.is_visible():
				LM_pressed=true
				LM_timer=0
			return
	# print(event)
	LM_pressed=false
	# print("2")
	popup.hide()
	# pass
	# if event is InputEventKey and event.keycode==KEY_DELETE:
	# 	for i in range(get_child_count()):
	# 		var node=get_child(i)
	# 		if node.selected:
	# 			del_node(node.name)

func _process(delta):
	LM_pressed=LM_pressed and popup.is_visible()
	if LM_pressed:
		LM_timer+=delta
		if LM_timer>LM_delay:
			LM_pressed=false
			popup.hide()


# func _on_popup_request(position):
# 	popup.show_popup(position)

# From_ID : Port_ID : [To_Name, To_Port]
var graph_from={}
# To_ID : Port_ID : [From_Name, From_Port]
var graph_to={}

func add_edge(from_node, from_port, to_node, to_port):
	prints("[GraphEdit] connecting:",from_node, from_port, to_node, to_port)
	if not graph_from.has(from_node):
		graph_from[from_node]={}
	if not graph_to.has(to_node):
		graph_to[to_node]={}
	graph_from[from_node][from_port]=[to_node, to_port]
	graph_to[to_node][to_port]=[from_node, from_port]
	connect_node(from_node, from_port, to_node, to_port)

func del_edge(from_node, from_port, to_node, to_port):
	prints("[GraphEdit] disconnecting:",from_node, from_port, to_node, to_port)
	if graph_from.has(from_node):
		if graph_from[from_node].has(from_port):
			graph_from[from_node].erase(from_port)
	if graph_to.has(to_node):
		if graph_to[to_node].has(to_port):
			graph_to[to_node].erase(to_port)
	disconnect_node(from_node, from_port, to_node, to_port)

func del_port(node, port, is_from=true):
	prints("[GraphEdit] disconnecting port:",node, port)
	if is_from:
		if graph_from.has(node):
			if graph_from[node].has(port):
				del_edge(node, port, graph_from[node][port][0], graph_from[node][port][1])
	else:
		if graph_to.has(node):
			if graph_to[node].has(port):
				del_edge(graph_to[node][port][0], graph_to[node][port][1], node, port)


func _on_connection_request(from_node, from_port, to_node, to_port):
	var _to_add=not is_node_connected(from_node, from_port, to_node, to_port)
	del_port(from_node, from_port)
	del_port(to_node, to_port, false)
	if _to_add:
		add_edge(from_node, from_port, to_node, to_port)
		


func _on_disconnection_request(from_node, from_port, to_node, to_port):
	del_edge(from_node, from_port, to_node, to_port)
	#prints("disconnection request",from_node, from_port, to_node, to_port)


func _on_connection_to_empty(from_node, from_port, release_position):
	del_port(from_node, from_port)


func _on_connection_from_empty(to_node, to_port, release_position):
	del_port(to_node, to_port, false)


func del_node(node_name):
	prints("[GraphEdit] deleting node:",node_name)
	if graph_from.has(node_name):
		for port in graph_from[node_name]:
			del_edge(node_name, port, graph_from[node_name][port][0], graph_from[node_name][port][1])
		graph_from.erase(node_name)
	if graph_to.has(node_name):
		for port in graph_to[node_name]:
			del_edge(graph_to[node_name][port][0], graph_to[node_name][port][1], node_name, port)
		graph_to.erase(node_name)
#	print("DELETE",get_node(String(node_name)).get_child(0).get_child(0).size)
	get_node(String(node_name)).queue_free()
	


func _on_delete_nodes_request(nodes):
	for n in nodes:
		del_node(n.name)

