extends Node2D

var player := Vector2(640, 400)
var target := player
var speed := 620.0
var touching := false
var touch_count := 0
var last_input := "等待觸控"
var animals = [
	{"p": Vector2(470,390), "name":"兔兔"},
	{"p": Vector2(815,420), "name":"小鹿"},
	{"p": Vector2(970,350), "name":"狐狸"}
]
var resources := {"木材": 12, "石材": 8, "食物": 15}
var pulse := 0.0

func _ready():
	set_process(true)
	set_process_input(true)
	queue_redraw()

func _process(delta):
	pulse += delta
	if player.distance_to(target) > 4.0:
		player = player.move_toward(target, speed * delta)
		queue_redraw()

func set_target(p: Vector2, source: String):
	target = p
	touch_count += 1
	last_input = "%s #%d  (%.0f, %.0f)" % [source, touch_count, p.x, p.y]
	queue_redraw()

func _input(event):
	if event is InputEventScreenTouch:
		touching = event.pressed
		if event.pressed:
			set_target(event.position, "觸控")
		else:
			last_input = "手指放開 #%d" % touch_count
			queue_redraw()
	elif event is InputEventScreenDrag:
		touching = true
		set_target(event.position, "拖曳")
	elif event is InputEventMouseButton and event.pressed:
		set_target(event.position, "滑鼠/模擬觸控")
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		set_target(event.position, "滑鼠拖曳")

func _draw():
	draw_rect(Rect2(0,0,1280,720), Color("#17252b"))
	var hills = PackedVector2Array([Vector2(0,270),Vector2(150,150),Vector2(280,260),Vector2(430,120),Vector2(600,270),Vector2(760,155),Vector2(920,250),Vector2(1080,130),Vector2(1280,260),Vector2(1280,430),Vector2(0,430)])
	draw_colored_polygon(hills, Color("#29443f"))
	draw_rect(Rect2(0,300,1280,420), Color("#476044"))
	draw_polygon(PackedVector2Array([Vector2(530,720),Vector2(600,420),Vector2(660,420),Vector2(760,720)]), PackedColorArray([Color("#aa956d")]))
	draw_rect(Rect2(520,190,260,230), Color("#c5aa78"))
	draw_rect(Rect2(490,230,60,190), Color("#ad8e62"))
	draw_rect(Rect2(750,230,60,190), Color("#ad8e62"))
	draw_polygon(PackedVector2Array([Vector2(500,230),Vector2(520,175),Vector2(540,230)]), PackedColorArray([Color("#744f43")]))
	draw_polygon(PackedVector2Array([Vector2(760,230),Vector2(780,175),Vector2(800,230)]), PackedColorArray([Color("#744f43")]))
	draw_polygon(PackedVector2Array([Vector2(520,190),Vector2(650,110),Vector2(780,190)]), PackedColorArray([Color("#805746")]))
	draw_rect(Rect2(615,320,70,100), Color("#513e35"))
	draw_circle(Vector2(650,285),32,Color("#f1c66d"))
	for p in [Vector2(150,300),Vector2(250,370),Vector2(1080,300),Vector2(1160,390),Vector2(360,290)]:
		draw_rect(Rect2(p.x-9,p.y,18,70),Color("#5b4432"))
		draw_circle(p,42,Color("#31533d"))
		draw_circle(p+Vector2(-22,-12),25,Color("#3e6748"))
	draw_rect(Rect2(80,500,300,150), Color("#665846"), false, 5)
	draw_string(ThemeDB.fallback_font, Vector2(105,535), "動物休息區・待建造", HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("#f3dfb2"))
	draw_string(ThemeDB.fallback_font, Vector2(105,575), "需要 木材 20 / 石材 12", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("#f0c983"))
	for a in animals:
		var p:Vector2 = a["p"]
		draw_circle(p,22,Color("#ead9bd"))
		draw_circle(p+Vector2(-10,-20),8,Color("#ead9bd"))
		draw_circle(p+Vector2(10,-20),8,Color("#ead9bd"))
		draw_circle(p+Vector2(-7,-3),3,Color("#332d2b"))
		draw_circle(p+Vector2(7,-3),3,Color("#332d2b"))
		draw_string(ThemeDB.fallback_font,p+Vector2(-25,42),a["name"],HORIZONTAL_ALIGNMENT_CENTER,50,18,Color.WHITE)
	draw_circle(player,25,Color("#e6b65c"))
	draw_circle(player+Vector2(0,-28),18,Color("#f0d1a4"))
	draw_line(player+Vector2(-14,10),player+Vector2(-22,36),Color("#443a31"),8)
	draw_line(player+Vector2(14,10),player+Vector2(22,36),Color("#443a31"),8)
	draw_circle(target, 16 + sin(pulse*5)*3, Color(1,0.9,0.45,0.4), false, 4)
	draw_rect(Rect2(20,20,1240,74),Color(0.05,0.07,0.08,0.88))
	draw_string(ThemeDB.fallback_font,Vector2(45,67),"ANIMAL HAVEN  動物家園 v0.2",HORIZONTAL_ALIGNMENT_LEFT,-1,28,Color("#ffe2a1"))
	draw_string(ThemeDB.fallback_font,Vector2(650,65),"木材 %d    石材 %d    食物 %d" % [resources["木材"],resources["石材"],resources["食物"]],HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color.WHITE)
	draw_rect(Rect2(330,638,620,66),Color(0.04,0.05,0.05,0.86))
	draw_string(ThemeDB.fallback_font,Vector2(350,666),"點擊或拖曳地面移動",HORIZONTAL_ALIGNMENT_CENTER,580,20,Color("#fff2ce"))
	draw_string(ThemeDB.fallback_font,Vector2(350,692),last_input,HORIZONTAL_ALIGNMENT_CENTER,580,18,Color("#9fe7d7"))
