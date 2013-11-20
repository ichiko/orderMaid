# gameview_main.coffee
# require enchant.js
# require model.coffee

enchant()

# 定数
GameView = {}
GameView.settings = 
	ScreenWidth:  640
	ScreenHeight: 480
	Fps: 40
	Map:
		Image00: 'images/shop_inside.png'
		TileSize:  32
		Width: 20
		Height: 15
	Maid:
		Image:  'images/char_maid.png'
		Width:  32
		Height: 48
	Chef:
		Image:  'images/char_chef.png'
		Width: 32
		Height: 48
	Customer:
		Width: 32
		Height: 48
		Image01: 'images/char_jacket.png'
		Image02: 'images/char_monkblue.png'
	OrderPanel:
		Width: 420
		Height: 320
		Color:  '#d7b66e'
		BorderWidth: 8
		BorderColor: '#a4702a'
		Font:   '24px cursive'
GameView.Direction =
	Up:    3
	Down:  0
	Right: 2
	Left:  1
GameView.Preload =
	Images: [
		GameView.settings.Map.Image00,
		GameView.settings.Maid.Image,
		GameView.settings.Chef.Image,
		GameView.settings.Customer.Image01,
		GameView.settings.Customer.Image02
		]

class OrderMaidGameView extends Game
	constructor: (stageInfo) ->
		super GameView.settings.ScreenWidth, GameView.settings.ScreenHeight

		@fps = GameView.settings.Fps
		@preload GameView.Preload.Images

		GameView.game = @
		@stageInfo = stageInfo
		@prevTick = 0

		# キー入力の受付設定(SPACEと、やじるしキーを使う)
		@keybind(32, "space")
		@addEventListener("spacebuttondown", @onenterkeySpace)

		@onload = ->
			console.log "OrderMaid.onload"

	onenterkeySpace: ->
		return if ! @checkInputDelay()
		return if ! @enableSpaceKeyInput()

	onenterkeyCursor: ->
		return if ! @checkInputDelay()
		return if ! @enableCursorKeyInput()

	onenterframe: ->
		input = @.input
		if input.left or input.right or input.up or input.down
			@onenterkeyCursor()

	# 入力ディレイ
	checkInputDelay: ->
		now = @getCurrentMilli()
		if (now - @prevTick) > OrderMaid.settings.Input.DelayMs
			@prevTick = now
			return true
		return false

	getCurrentMilli: ->
		date = new Date()
		return date.getTime()

	# Sceneは処理中か
	sceneIsReady: ->
		@currentScene.isReady

	# SPACEキー入力を受付るか
	enableSpaceKeyInput: ->
		return false if ! @sceneIsReady()
		switch @status()
			when StageInfo.STATE_MAIN_READY, StageInfo.STATE_MAIN_TAKE_ORDER, StageInfo.STATE_MAIN_PRE_ORDER_TO_CHEF, StageInfo.STATE_MAIN_ORDER_TO_CHEF, StageInfo.STATE_MAIN_DISH_READY, StageInfo.STATE_MAIN_TAKE_DISH_FROM_CHEF, StageInfo.STATE_MAIN_DELIVER_DISH, StageInfo.STATE_MAIN_SERVE_DISH, StageInfo.STATE_MAIN_SELECT_DISH, StageInfo.STATE_MAIN_CHECK_DISH, StageInfo.STATE_MAIN_ALL_DELIVERED
				return true
		return false

	# やじるしキー入力を受付るか
	enableCursorKeyInput: ->
		return false if ! @sceneIsReady()
		switch @status()
			when StageInfo.STATE_MAIN_PRE_ORDER_TO_CHEF, StageInfo.STATE_MAIN_ORDER_TO_CHEF, StageInfo.STATE_MAIN_DISH_READY, StageInfo.STATE_MAIN_DELIVER_DISH, StageInfo.STATE_MAIN_SELECT_DISH
				return true
		return false

	# ---- 状態管理系 ----

	loadStage: ->
		@pushFloorScene()
		@stageInfo.set('status', StageInfo.STATE_MAIN_READY)

	startTakeOrder: ->
		# 注文を描画する
		@stageInfo.set('status', StageInfo.STATE_MAIN_TAKE_ORDER)

	didTakeOrder: ->
		# 移動できるようになる
		@stageInfo.set('status', StageInfo.STATE_MAIN_PRE_ORDER_TO_CHEF)

	orderToChef: ->
		# シェフに注文を指示する
		@pushOrderScene()
		@stageInfo.set('status', StageInfo.STATE_MAIN_ORDER_TO_CHEF)

	didOrderToChef: ->
		# 注文完了、調理アニメーション
		@popScene()
		# @currentScene.startCooking()
		@stageInfo.set('status', StageInfo.STATE_MAIN_COOKING)

	didCook: ->
		# 調理完了、シェフから受け取れるようになる
		@stageInfo.set('status', StageInfo.STATE_MAIN_DISH_READY)

	takeFromChef: ->
		# シェフから調理品を受け取る
		@stageInfo.set('status', StageInfo.STATE_MAIN_TAKE_DISH_FROM_CHEF)

	startFloorServe: ->
		# 移動できるようになる
		console.log @stageInfo
		#@currentScene.startServe()
		@stageInfo.set('status', StageInfo.STATE_MAIN_DELIVER_DISH)

	startServeDish: ->
		# 客は選択済み
		@stageInfo.set('status', StageInfo.STATE_MAIN_SERVE_DISH)

	showChoisePanel: ->
		@pushChoiseScene()
		@stageInfo.set('status', StageInfo.STATE_MAIN_SELECT_DISH)

	didSelectServeDish: (dish) ->
		# 結果判定して、表示
		@popScene()
		@stageInfo.set('status', StageInfo.STATE_MAIN_CHECK_DISH)

	didServeDish: ->
		# (結果を確認した後) すべてのオーダーを処理していたら、ゲーム終了
		customers = @stageInfo.get('customers')
		if customers.where( { isDelivered: false} ).length > 0
			@stageInfo.set('status', StageInfo.STATE_MAIN_DELIVER_DISH)
		else
			@startResultScene()

	startResultScene: ->
		# 結果画面を表示する
		@pushResultScene()
		@stageInfo.set('status', StageInfo.STATE_MAIN_ALL_DELIVERED)


	# ---- getter ----

	status: ->
		return @stageInfo.get('status')

	# ---- scene control ----

	pushFloorScene: ->
		main = new FloorScene(@stageInfo)
		@pushScene main

	pushOrderScene: ->
		orderPanel = new OrderPanelScene(@stageInfo)
		@pushScene orderPanel

	pushChoiseScene: ->
		# 選択画面を表示する
		cookingList = @stageInfo.get('cookingList')
		choisePanel = new ChoisePanelScene(cookingList)
		@pushScene choisePanel

	pushResultScene: ->

# ---- 共通処理クラス ----

class BaseScene extends Scene
	constructor: ->
		super
		@game = GameView.game
		@isReady = false

	batchStart: ->
		@isReady = false

	batchEnd: ->
		@isReady = true

class BasePanelScene extends BaseScene
	
	drawBackPanel: ->
		screenWidth = GameView.settings.ScreenWidth
		screenHeight = GameView.settings.ScreenHeight
		panelWidth = GameView.settings.OrderPanel.Width
		panelHeight = GameView.settings.OrderPanel.Height
		borderWidth = GameView.settings.OrderPanel.BorderWidth

		border = new Sprite(panelWidth, panelHeight)
		border.backgroundColor = GameView.settings.OrderPanel.BorderColor
		border.x = (screenWidth - border.width) / 2
		border.y = (screenHeight - border.height) / 2
		@addChild border

		backpanel = new Sprite(panelWidth - borderWidth * 2, panelHeight - borderWidth * 2)
		backpanel.backgroundColor = GameView.settings.OrderPanel.Color
		backpanel.x = (screenWidth - backpanel.width) / 2
		backpanel.y = (screenHeight - backpanel.height) / 2
		@addChild backpanel

	createOrderedLabel: (x, y_offset, y_interval, n) ->
		label = new Label()
		label.font = GameView.settings.OrderPanel.Font
		label.x = x
		label.y = y_offset + y_interval * n
		return label

class BaseCursor extends Label
	constructor: (max_y) ->
		super
		@text = "→"
		@font = GameView.settings.OrderPanel.Font
		@cursor_y = 0
		@max_y = max_y
		@update()

	update: ->
		@x = 0
		@y = 0

	up: ->
		if @cursor_y > 0
			@cursor_y--
			@update()

	down: ->
		if @cursor_y < @max_y
			@cursor_y++
			@update()
