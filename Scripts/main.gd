extends Node2D

var coins = 1000
var shown = false

var windMill = preload("res://Scenes/windmill.tscn")
var solarPanel = preload("res://Scenes/solarpanel.tscn")

var timeForADay = 10

var numberOfWindMills = 0
var numberOfSolarPanels = 0
var TimeInSeconds = timeForADay

var numberOfUpgradedWindMills = 0
var numberOfUpgradedSolarPanels = 0

var windSpeed = 3
var lightIndex = 8.0

var day = 0

@onready var final_message: Label = $FinalMessage

@onready var label: Label = $Camera2D/Labels/coins
@onready var time: Label = $Camera2D/Labels/time

@onready var wind: Label = $Camera2D/Labels/wind
@onready var light: Label = $Camera2D/Labels/light

@onready var windmill_amount: Label = $Camera2D/Labels/WindmillAmount
@onready var u_windmill_amount: Label = $Camera2D/Labels/UWindmillAmount
@onready var solar_amount: Label = $Camera2D/Labels/SolarAmount
@onready var u_solar_amount: Label = $Camera2D/Labels/USolarAmount

@onready var forecast: Label = $Forecast
@onready var dayText: Label = $Camera2D/Labels/dayText

@onready var upgrade_w: Button = $Camera2D/Buttons/upgradeW
@onready var upgrade_s: Button = $Camera2D/Buttons/upgradeS

var last_forecast_day = -5
var tempLight = 8

const possibleMessages = [
  "Light intensity will become 9 as the sun emerges from behind the clouds for the next 5 days.",
  "Wind  intensity will become 2 as a nearby mountain range blocks strong gusts for the next 5 days.",
  "Light intensity will become 6 as a thick fog begins to roll in for the next 5 days.",
  "Wind  intensity will become 4 as a distant storm generates mild breezes for the next 5 days.",
  "Light intensity will become 8 as the sky clears after a brief shower for the next 5 days.",
  "Wind  intensity will become 7 as a coastal breeze picks up strength for the next 5 days.",
  "Light intensity will become 5 as a dense cloud partially obscures the sun for the next 5 days.",
  "Wind  intensity will become 3 as trees act as natural windbreakers for the next 5 days.",
  "Light intensity will become 2 as heavy rainfall blocks most sunlight for the next 5 days.",
  "Wind  intensity will become 9 as a storm front moves rapidly through for the next 5 days.",
  "Light intensity will become 7 as the sun sets and dusk begins for the next 5 days.",
  "Wind  intensity will become 5 as air pressure equalizes over the plains for the next 5 days.",
  "Light intensity will become 4 as haze from distant fires fills the sky for the next 5 days.",
  "Wind  intensity will become 6 as a jet stream influences local weather for the next 5 days.",
  "Light intensity will become 1 as a solar eclipse reaches its peak for the next 5 days.",
  "Wind  intensity will become 8 as strong winds sweep across open fields for the next 5 days.",
  "Light intensity will become 3 as thick smog reduces visibility for the next 5 days.",
  "Wind  intensity will become 0 as the atmosphere becomes completely still for the next 5 days.",
  "Light intensity will become 0 as night fully takes over for the next 5 days.",
  "Wind  intensity will become 1 as the air remains calm before a storm for the next 5 days."
];

func _process(delta: float) -> void:
	if day == 60:
		LEFINALE()
	else:
		ManagePlacements()
		ManageMoney(delta)
		ManageTime(delta)
		ManageUI()
		AiForecast(delta)

func ManagePlacements():
	if Input.is_action_just_pressed("Place") and Input.is_action_pressed("holdW") and coins >=100:
		coins -= 100
		label.text = "COINS: " + str(coins)
		instWindMill(get_global_mouse_position())
	if Input.is_action_just_pressed("Place") and Input.is_action_pressed("holdS") and coins >= 200:
		coins -= 200
		label.text = "COINS: " + str(coins)
		instSolarPanel(get_global_mouse_position())

func ManageMoney(delta):
	if numberOfUpgradedWindMills >= 1:
		coins = coins + (5 * (windSpeed * (numberOfUpgradedWindMills * delta)))
	else:
		coins = coins + (windSpeed * (numberOfWindMills * delta))
	if time.text == "DAYTIME":
		if numberOfUpgradedSolarPanels >=1:
			coins = coins + (5 * (4 * (lightIndex * (numberOfUpgradedSolarPanels * delta))))
		else:
			coins = coins + (4 * (lightIndex * (numberOfSolarPanels * delta)))

func ManageTime(delta):
	if TimeInSeconds > 0:
		TimeInSeconds -= delta
		time.text = "DAYTIME"
		if lightIndex == 0:
			lightIndex = tempLight
		
	elif TimeInSeconds < 0:
		time.text = "NIGHTTIME"
		TimeInSeconds -= delta
		
		if lightIndex != 0:
			tempLight = lightIndex
			lightIndex = 0
		
		if TimeInSeconds < -timeForADay:
			TimeInSeconds = timeForADay
			day += 1

func ManageUI():
	dayText.text = "DAY: " + str(day)
	
	label.text = "COINS: " + str(coins)
	wind.text = "Wind Speed: " + str(windSpeed) + " knots"
	
	light.text = "Light Index: " + str(lightIndex)
	
	windmill_amount.text = "WINDMILLS: " + str(numberOfWindMills)
	u_windmill_amount.text = "UPGRADED WINDMILLS: " + str(numberOfUpgradedWindMills)
	solar_amount.text = "SOLAR PANELS: " + str(numberOfSolarPanels)
	u_solar_amount.text = "UPGRADED SOLAR PANELS: " + str(numberOfUpgradedSolarPanels)

func AiForecast(_delta):
	var rng = RandomNumberGenerator.new()
	
	if day % 5 == 0 and last_forecast_day != day:
		last_forecast_day = day
		forecast.visible = true
		
		var randomnumber = rng.randi_range(0, 19)
		forecast.text = possibleMessages[randomnumber]
		
		if possibleMessages[randomnumber][0] == "L":
			lightIndex = int(possibleMessages[randomnumber][28])
		else:
			windSpeed = int(possibleMessages[randomnumber][28])
	
	elif day % 5 !=0:
		forecast.visible = false

func instWindMill(pos):
	var WindMill = windMill.instantiate()
	WindMill.position = pos
	add_child(WindMill)
	numberOfWindMills += 1

func instSolarPanel(pos):
	var SolarPanel = solarPanel.instantiate()
	SolarPanel.position = pos
	add_child(SolarPanel)
	numberOfSolarPanels += 1

func _on_upgrade_w_pressed() -> void:
	if numberOfWindMills >= 1 and coins >= 500:
		numberOfUpgradedWindMills += 1
		numberOfWindMills -= 1
		coins -= 500

func _on_upgrade_s_pressed() -> void:
	if numberOfSolarPanels >= 1 and coins >= 500:
		numberOfUpgradedSolarPanels += 1
		numberOfSolarPanels -= 1
		coins -= 500

func LEFINALE():
	'''dayText.visible = false
	label.visible = false 
	wind.visible = false
	light.visible = false 
	windmill_amount.visible = false
	u_windmill_amount.visible = false 
	solar_amount.visible = false
	u_solar_amount.visible = false
	upgrade_w.visible = false
	upgrade_s.visible = false
	time.visible = false'''
	
	forecast.visible = false
	final_message.text = "IN 60 DAYS YOU MADE £" + str(coins)
	
