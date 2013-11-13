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

class OrderMaid extends Game
	constructor: (stageInfo) ->
		super GameView.settings.ScreenWidth, GameView.settings.ScreenHeight
		@fps = GameView.settings.Fps
		@preload GameView.Preload.Images
		OrderMaid.game = @
		@stageInfo = stageInfo

		@keybind(32, "space")

		@onload = ->
			console.log "OrderMaid.onload"
			@loadMainScene()

	loadMainScene: ->
		main = new FloorScene(@stageInfo)
		@pushScene main
		@stageInfo.set('status', StageInfo.STATE_MAIN_READY)

	startTakeOrder: ->
		# 注文を描画する
		@stageInfo.set('status', StageInfo.STATE_MAIN_TAKE_ORDER)
		
	didTakeOrder: ->
		# 移動できるようになる
		@stageInfo.set('status', StageInfo.STATE_MAIN_PRE_ORDER_TO_CHEF)

	orderToChef: ->
		# シェフに注文を指示する
		orderPanel = new OrderPanelScene(@stageInfo)
		@pushScene orderPanel
		@stageInfo.set('status', StageInfo.STATE_MAIN_ORDER_TO_CHEF)

	didOrderToChef: ->
		# 注文完了、調理アニメーション
		@stageInfo.set('status', StageInfo.STATE_MAIN_COOKING)

	didCook: ->
		# 調理完了、シェフから受け取れるようになる


	startFloorServe: ->
		# 移動できるようになる
		console.log @stageInfo
		@popScene()
		#@currentScene.startServe()
		@stageInfo.set('status', StageInfo.STATE_MAIN_DELIVER_DISH)

	startServeDish: ->
		# 客は選択済み
		@stageInfo.set('status', StageInfo.STATE_MAIN_SERVE_DISH)

	showChoisePanel: ->
		# 選択画面を表示する
		cookingList = @stageInfo.get('cookingList')
		choisePanel = new ChoisePanelScene(cookingList)
		@pushScene choisePanel
		@stageInfo.set('status', StageInfo.STATE_MAIN_SELECT_DISH)

	didSelectServeDish: (dish) ->
		# 結果判定して、表示
		@stageInfo.set('status', StageInfo.STATE_MAIN_CHECK_DISH)

	didServeDish: ->
		# (結果を確認した後) すべてのオーダーを処理していたら、ゲーム終了
		customers = @stageInfo.get('customers')
		if customers.contains( { isDelivered: false} )
			@stageInfo.set('status', StageInfo.STATE_MAIN_DELIVER_DISH)
		else
			@stageInfo.set('status', StageInfo.STATE_MAIN_ALL_DELIVERED)

	startResultScene: ->
		# 結果画面を表示する

class FloorScene extends Scene
	constructor: (stageInfo) ->
		super
		@game = OrderMaid.game
		@stageInfo = stageInfo



class CharacterLayer extends Group
	constructor: ->
		super

	who: (cell_x, cell_y) ->
		i = 0
		len = @childNodes.length
		while i < len
			chara = @childNodes[i]
			if chara instanceof AvatorBase and chara.cell_x == cell_x and chara.cell_y == cell_y
				return chara
			i++
		return null

	clearCustomer: ->
		i = 0
		len = @childNodes.length
		while i < len
			elm = @childNodes[i]
			if elm instanceof Customer
				@removeChild elm
			i++

class AvatorBase extends Sprite
	constructor: (width, height, cell_x, cell_y) ->
		super width, height
		@game = OrderMaid.game
		@cell_x = cell_x
		@cell_y = cell_y
		@offset_x = @offset_y = 0
		@vx = @vy = 0
		@speed = 4
		@moveDelay = 1 #Math.floor(@game.fps / 10)
		@walkDelay = 10
		@tickMove = @tickWalk = 0
		@direction = GameView.Direction.Down
		@n = 0

		@update()

	onenterframe: ->
		if @moveAnimationTimeout()
			@updatePosition()
		if @walkAnimationTimeout()
			@updateWalkAnimation()

	moveAnimationTimeout: ->
		@tickMove++
		if @tickMove > @moveDelay
			@tickMove = 0
			return true
		return false
	walkAnimationTimeout: ->
		@tickWalk++
		if @tickWalk > @walkDelay
			@tickWalk = 0
			return true
		return false

	getPixelX: ->
		@cell_x * GameView.settings.Map.TileSize + @offset_x
	getPixelY: ->
		@cell_y * GameView.settings.Map.TileSize + @offset_y

	update: ->
		@updatePosition()
		@updateWalkAnimation()

	updatePosition: ->
		x = @getPixelX()
		y = @getPixelY()
		if ! @isWalking()
			@frame = @direction * 4
		if @vx != 0
			x += @vx
			@vx -= (@vx / Math.abs(@vx)) * @speed
		if @vy != 0
			y += @vy
			@vy -= (@vy / Math.abs(@vy)) * @speed
		@x = x
		@y = y
	updateWalkAnimation: ->
		if @vx != 0 || @vy != 0
			@frame = @direction * 4 + (@n % 4)
			@n++

	isWalking: ->
		@vx != 0 or @vy != 0

	enableMoveToUp: ->
		@cell_y > 0
	enableMoveToRight: ->
		@cell_x < GameView.settings.Map.Width - 1
	enableMoveToDown: ->
		@cell_y < GameView.settings.Map.Height - 1
	enableMoveToLeft: ->
		@cell_x > 0

	up: (map) ->
		if @isWalking()
			return
		if @direction != GameView.Direction.Up
			@direction = GameView.Direction.Up
			return
		if ! map.hitTest(@cell_x * map.tileWidth, (@cell_y - 1) * map.tileHeight) and @enableMoveToUp()
			@cell_y--
			@vy = GameView.settings.Map.TileSize
	right: (map) ->
		if @isWalking()
			return
		if @direction != GameView.Direction.Right
			@direction = GameView.Direction.Right
			return
		if ! map.hitTest((@cell_x + 1) * map.tileWidth, @cell_y * map.tileHeight) and @enableMoveToRight()
			@cell_x++
			@vx = - GameView.settings.Map.TileSize
	down: (map) ->
		if @isWalking()
			return
		if @direction != GameView.Direction.Down
			@direction = GameView.Direction.Down
			return
		if ! map.hitTest(@cell_x * map.tileWidth, (@cell_y + 1) * map.tileHeight) and @enableMoveToDown()
			@cell_y++
			@vy = - GameView.settings.Map.TileSize
	left: (map) ->
		if @isWalking()
			return
		if @direction != GameView.Direction.Left
			@direction = GameView.Direction.Left
			return
		if ! map.hitTest((@cell_x - 1) * map.tileWidth, @cell_y * map.tileHeight) and @enableMoveToLeft()
			@cell_x--
			@vx = GameView.settings.Map.TileSize

class Maid extends AvatorBase
	constructor: (cell_x, cell_y) ->
		super GameView.settings.Maid.Width, GameView.settings.Maid.Height, cell_x, cell_y
		@image = @game.assets[GameView.settings.Maid.Image]
		@offset_y = -16
		@update()

	getCollisionPoint: ->
		if ! @isWalking()
			target_x = @cell_x
			if @direction == GameView.Direction.Left
				target_x--
			else if @direction == GameView.Direction.Right
				target_x++
			target_y = @cell_y
			if @direction == GameView.Direction.Up
				target_y -= 2
			else if @direction == GameView.Direction.Down
				target_y++
			return [target_x, target_y]
		else
			return [@cell_x, @cell_y]

class Chef extends AvatorBase
	constructor: (cell_x, cell_y) ->
		super GameView.settings.Chef.Width, GameView.settings.Chef.Height, cell_x, cell_y
		@image = @game.assets[GameView.settings.Chef.Image]
		@offset_y = 0

	sayWhatCook: ->
		@tweet('注文は?')

	sayDone: ->
		@tweet('おまちー')

	said: ->
		parent = @ttweet.parentNode
		parent.removeChild @ttweet

	tweet: (msg) ->
		tw_width = 146
		tw_height = 32
		@ttweet = new TTweet(tw_width, tw_height, TTweet.TOP, TTweet.CENTER)
		@ttweet.text(msg)
		@ttweet.x = this.x - tw_width / 2 + 16
		@ttweet.y = this.y + tw_height + 8
		return @ttweet

class Customer extends AvatorBase
	constructor: (cell_x, cell_y) ->
		super GameView.settings.Customer.Width, GameView.settings.Customer.Height, cell_x, cell_y
		# @image は外部から指定してください
		# 座っている場合、@offset_y = 0
		@model = null

	setImage: (id) ->
		if id == 1
			@image = @game.assets[GameView.settings.Customer.Image01]
		else
			@image = @game.assets[GameView.settings.Customer.Image02]

	sayOrder: ->
		@tweet(@model.get('dishName'))

	sayWant: ->
		@tweet(@model.get('waitMsg'))

	sayNoDishDelivered: ->
		@tweet(@model.get('hasNoDishMsg'))

	tweet: (msg) ->
		tw_width = 128
		tw_height = 32
		@ttweet = new TTweet(tw_width, tw_height, TTweet.BOTTOM, TTweet.CENTER)
		@ttweet.text(msg)
		@ttweet.x = this.x - tw_width / 2 + 16
		@ttweet.y = this.y - tw_height - 12
		return @ttweet

	said: ->
		parent = @ttweet.parentNode
		parent.removeChild @ttweet
