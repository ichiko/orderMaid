# 21_gameview_floor.coffee
# require enchant.js
# require 21_gameview.coffee


class FloorScene extends BaseScene
	constructor: (stageInfo) ->
		super
		@stageInfo = stageInfo

		@talking = false

		@createLayers()
		@batchEnd()

	createLayers: ->
		tileWidth = GameView.settings.Map.TileSize
		tileHeight = GameView.settings.Map.TileSize

		groundMap = new Map(tileWidth, tileHeight)
		groundMap.image = @game.assets[GameView.settings.Map.Image00]
		groundMap.loadData.apply(groundMap, mapLoader.map)
		groundMap.collisionData = mapLoader.collision;

		middleMap = new Map(tileWidth, tileHeight)
		middleMap.image = @game.assets[GameView.settings.Map.Image00]
		middleMap.loadData.apply(middleMap, mapLoader.middleground)

		foregroundMap = new Map(tileWidth, tileHeight)
		foregroundMap.image = @game.assets[GameView.settings.Map.Image00]
		foregroundMap.loadData.apply(foregroundMap, mapLoader.foreground)

		@maid = new Maid(9, 13)

		@characterLayer = new CharacterLayer
		@noticeLayer = new CustomLayer()

		label = new Label()
		label.text = 'press SPACE to START'
		label.font = '32px bold'
		label.width = 380
		label.x = GameView.settings.ScreenWidth / 2 - label.width / 2
		label.y = GameView.settings.ScreenHeight / 2 - 32
		@noticeLayer.addChild label

		@addChild groundMap
		@addChild @characterLayer
		@addChild middleMap
		@addChild @maid
		@addChild foregroundMap
		@addChild @noticeLayer

		@currentMap = groundMap

	# ---- 入力 ----

	# シーンで処理が完結するときtrueを返す
	onenterkeySpace: ->
		if @talking
			who = @getFrontPerson()
			if who?
				who.said()
				@talking = false
				return true

		status = @game.status()
		switch status
			when StageInfo.STATE_MAIN_PRE_ORDER_TO_CHEF
				who = @getFrontPerson()
				if who?
					if who instanceof Customer
						@noticeLayer.addChild who.sayNoDishDelivered()
						@talking = true
						return true
					else if who instanceof Chef
						@noticeLayer.addChild who.sayWhatCook()
						@talking = true
		return false

	onenterkeyCursor: (dict) ->
		switch dict
			when GameView.Direction.Left
				@maid.left(@currentMap)
			when GameView.Direction.Right
				@maid.right(@currentMap)
			when GameView.Direction.Up
				@maid.up(@currentMap)
			when GameView.Direction.Down
				@maid.down(@currentMap)

	getFrontPerson: ->
		targetPos = @maid.getCollisionPoint()
		who = @characterLayer.who(targetPos[0], targetPos[1])

	# ---- 描画処理 ----

	clearNotice: ->
		@noticeLayer.clear()

	showOrdersAndChef: ->
		# clear
		@clearNotice()
		@characterLayer.clearCustomer()
		# set Chef
		@chef = new Chef(7, 0)
		@characterLayer.addChild @chef
		# set customers
		orderList = @stageInfo.get('customers')
		orderList.each (order) =>
			customer = new Customer(order.get('cell_x'), order.get('cell_y'))
			customer.setImage(order.get('charIconNo'))
			customer.model = order
			@characterLayer.addChild customer
			@noticeLayer.addChild customer.sayOrder()

	noticeHowtoStartServe: ->
		label = new Label()
		label.text = "press Space to Start Service"
		label.x = 220
		label.y = GameView.settings.ScreenHeight - 32
		@noticeLayer.addChild label

	closeOrderTweet: ->
		@clearNotice()

	startCookingAnimation: ->
		@chef.said()
		@talking = false

		@chef.animationTL = true
		@chef.setDirection(GameView.Direction.Up)
		@chef.tl.delay(@game.fps * 1).then =>
			@chef.tl.moveTo(32 * 7, 32 * -1, @game.fps).then =>
				@chef.setDirection(GameView.Direction.Right)
				@chef.tl.delay(@game.fps * 1).then =>
					@chef.tl.moveTo(32 * 10, 32 * -1, @game.fps).then =>
						@chef.setDirection(GameView.Direction.Up)
						@chef.tl.delay(@game.fps).then =>
							@chef.setDirection(GameView.Direction.Right)
							@chef.tl.delay(@game.fps / 2).then =>
								@chef.setDirection(GameView.Direction.Left)
								@chef.tl.delay(@game.fps / 2).then =>
									@chef.setDirection(GameView.Direction.Right)
									@chef.tl.delay(@game.fps / 2).then =>
										@chef.setDirection(GameView.Direction.Left)
										@chef.tl.moveTo(32 * 7, 0, @game.fps).then =>
											@chef.setDirection(GameView.Direction.Down)
											@batchEnd()
											@game.didCook()

	noticeCookDone: ->
		@noticeLayer.addChild @chef.sayDone()
		@talking = true

class CustomLayer extends Group
	constructor: ->
		super

	clear: (func) ->
		i = 0
		len = @childNodes.length
		target = []
		while i < len
			elm = @childNodes[i]
			if (! (func?)) or func(elm)
				target.push elm
			i++
		i = 0
		len = target.length
		while i < len
			@removeChild target[i]
			i++

class CharacterLayer extends CustomLayer
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
		@clear (elm)->
			elm instanceof Customer

class AvatorBase extends Sprite
	constructor: (width, height, cell_x, cell_y) ->
		super width, height
		@game = GameView.game
		@cell_x = cell_x
		@cell_y = cell_y
		@offset_x = @offset_y = 0
		@vx = @vy = 0
		@speed = 4
		@moveDelay = 1 #Math.floor(@game.fps / 10)
		@walkDelay = 9
		@tickMove = @tickWalk = 0
		@direction = GameView.Direction.Down
		@animationTL = false
		@n = 0

		@update()

	onenterframe: ->
		if ! @animationTL and @moveAnimationTimeout()
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

	setDirection: (dict) ->
		@direction = dict
		@frame = @direction * 4

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
			@setDirection GameView.Direction.Up
			return
		if ! map.hitTest(@cell_x * map.tileWidth, (@cell_y - 1) * map.tileHeight) and @enableMoveToUp()
			@cell_y--
			@vy = GameView.settings.Map.TileSize
	right: (map) ->
		if @isWalking()
			return
		if @direction != GameView.Direction.Right
			@setDirection GameView.Direction.Right
			return
		if ! map.hitTest((@cell_x + 1) * map.tileWidth, @cell_y * map.tileHeight) and @enableMoveToRight()
			@cell_x++
			@vx = - GameView.settings.Map.TileSize
	down: (map) ->
		if @isWalking()
			return
		if @direction != GameView.Direction.Down
			@setDirection GameView.Direction.Down
			return
		if ! map.hitTest(@cell_x * map.tileWidth, (@cell_y + 1) * map.tileHeight) and @enableMoveToDown()
			@cell_y++
			@vy = - GameView.settings.Map.TileSize
	left: (map) ->
		if @isWalking()
			return
		if @direction != GameView.Direction.Left
			@setDirection GameView.Direction.Left
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
		@tweet(GameView.helper.getDishName(@model.get('dishId')))

	sayWant: ->
		@tweet(@model.get('waitingMsg'))

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
