# 21_gameview_floor_spec.coffee
# target 21_gameview_floor.coffee

describe 'CustomerLayer', ->
	describe 'clear', ->
		beforeEach ->
			new OrderMaidGameView()

		it '空のときは、状態が変化しない', ->
			layer = new CustomLayer()
			expect(layer.childNodes.length).toEqual(0)
			layer.clear()
			expect(layer.childNodes.length).toEqual(0)

		it '全て消去するとき、空になる', ->
			layer = new CustomLayer()
			layer.addChild( new Sprite(3, 4) )
			layer.addChild( new Sprite(5, 9) )
			layer.addChild( new Sprite(2, 3) )
			expect(layer.childNodes.length).toEqual(3)
			layer.clear()
			expect(layer.childNodes.length).toEqual(0)

		it '判定関数を指定するとき、空にはならない', ->
			layer = new CustomLayer()
			layer.addChild( new Sprite(24, 24) )
			layer.addChild( new Sprite(20, 20) )
			layer.addChild( new Customer(1, 2) )
			layer.addChild( new Customer(3, 8) )
			layer.addChild( new Customer(10, 9) )
			expect(layer.childNodes.length).toEqual(5)
			layer.clear( (elm) ->
				elm instanceof Customer
			)
			expect(layer.childNodes.length).toEqual(2)

describe 'CharacterLayer', ->
	describe 'who', ->
		layer = null

		beforeEach ->
			new OrderMaidGameView()
			layer = new CharacterLayer()

		it '子要素を持たないとき、null', ->
			expect(layer.who(3,3)).toBe(null)

		it 'キャラクタでない子要素を持つとき、null', ->
			layer.addChild( new Sprite(24, 24) )
			expect(layer.who(3,3)).toBe(null)

		it '子要素としてAvatorBaseを持つが、指定セルにいないとき、null', ->
			layer.addChild( new AvatorBase(24, 24, 2, 4) )
			expect(layer.who(3,3)).toBe(null)

		it '子要素としてAvatorBaseを持ち、指定セルにいるとき、nullでない', ->
			layer.addChild( new AvatorBase(24, 24, 5, 5) )
			expect(layer.who(5,5)).not.toBe(null)

	# 画像リソースに依存するため、テストに失敗する
	#	it '子要素としてChefを持つが、指定セルにいないとき、null', ->
	#		layer.addChild( new Chef(3,5) )
	#		expect(layer.who(5,5)).toBe(null)
	#
	#	it '子要素としてChefを持ち、指定セルにいるとき、nullでない', ->
	#		layer.addChild( new Chef(4,4) )
	#		expect(layer.who(4,4)).not.toBe(null)

		it '子要素としてCustomerを持つが、指定セルにいないとき、null', ->
			layer.addChild( new Customer(6,7) )
			expect(layer.who(6,6)).toBe(null)

		it '子要素としてCustomerを持ち、指定セルにいるとき、nullでない', ->
			layer.addChild( new Customer(6,6) )
			expect(layer.who(6,6)).not.toBe(null)

	describe 'clearCustomer', ->
		layer = null

		beforeEach ->
			new OrderMaidGameView()
			layer = new CharacterLayer()

		it '空のときは、状態が変化しない', ->
			expect(layer.childNodes.length).toEqual(0)
			layer.clear()
			expect(layer.childNodes.length).toEqual(0)

		it 'Customerを持たないとき、状態が変化しない', ->
			layer.addChild( new AvatorBase(24, 24, 10, 11) )
			layer.addChild( new AvatorBase(24, 24, 10, 12) )
			expect(layer.childNodes.length).toEqual(2)
			layer.clearCustomer()
			expect(layer.childNodes.length).toEqual(2)

		it 'Customerを持つとき、その要素分減る', ->
			layer.addChild( new AvatorBase(24, 24, 10, 11) )
			layer.addChild( new Customer(2, 4) )
			layer.addChild( new Customer(11, 6) )
			expect(layer.childNodes.length).toEqual(3)
			layer.clearCustomer()
			expect(layer.childNodes.length).toEqual(1)
