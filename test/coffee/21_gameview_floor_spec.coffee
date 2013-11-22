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

describe 'AvatorBase', ->

	describe 'AnimationTimeout', ->
		avator = null

		beforeEach ->
			new OrderMaidGameView()
			avator = new AvatorBase(32, 32, 1, 2)

		it '初期化後、カウンタは0', ->
			expect(avator.tickMove).toEqual(0)
			expect(avator.tickWalk).toEqual(0)

		it '移動カウンタは、2回に一回、真を返す', ->
			expect(avator.moveAnimationTimeout()).toBe(false)
			expect(avator.moveAnimationTimeout()).toBe(true)
			expect(avator.moveAnimationTimeout()).toBe(false)
			expect(avator.moveAnimationTimeout()).toBe(true)

		it '歩行アニメーションは、10回に一回、真を返す', ->
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(false)
			expect(avator.walkAnimationTimeout()).toBe(true)
			expect(avator.walkAnimationTimeout()).toBe(false)

	describe 'getPixel', ->
		beforeEach ->
			new OrderMaidGameView()

		it '座標(0,0)において、計算が正しい', ->
			avator = new AvatorBase(35, 35, 0, 0)
			expect(avator.getPixelX()).toEqual(0)
			expect(avator.getPixelY()).toEqual(0)

		it '座標(1,1)において、計算が正しい', ->
			avator = new AvatorBase(35, 35, 1, 1)
			expect(avator.getPixelX()).toEqual(32)
			expect(avator.getPixelY()).toEqual(32)

		it '座標(2,5)において、計算が正しい', ->
			avator = new AvatorBase(35, 35, 2, 5)
			expect(avator.getPixelX()).toEqual(64)
			expect(avator.getPixelY()).toEqual(160)

		it '座標(2,5)において、加算offset付きの計算が正しい', ->
			avator = new AvatorBase(35, 35, 2, 5)
			avator.offset_x = 4
			avator.offset_y = 6
			expect(avator.getPixelX()).toEqual(68)
			expect(avator.getPixelY()).toEqual(166)

		it '座標(2,5)において、減算offset付きの計算が正しい', ->
			avator = new AvatorBase(35, 35, 2, 5)
			avator.offset_x = -8
			avator.offset_y = -3
			expect(avator.getPixelX()).toEqual(56)
			expect(avator.getPixelY()).toEqual(157)

	describe 'X方向の移動(座標更新)', ->
		avator = null

		beforeEach ->
			new OrderMaidGameView()

		it '移動前の状態が正しい', ->
			avator = new AvatorBase(35, 35, 4, 6)
			expect(avator.x).toEqual(32 * 4)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		it '移動する必要がないときには、値を変更しない', ->
			avator.updatePosition()
			expect(avator.x).toEqual(32 * 4)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		describe '右へ移動するとき(1)', ->
			beforeEach ->
				avator.cell_x = 5
				avator.vx = - 32
				avator.updatePosition()

			it 'Xセル座標が正しい', ->
				expect(avator.cell_x).toEqual(5)
			it 'Yセル座標が正しい', ->
				expect(avator.cell_y).toEqual(6)
			it 'X座標が正しい', ->
				expect(avator.x).toEqual(32 * 4 + 0)
			it 'Y座標が正しい', ->
				expect(avator.y).toEqual(32 * 6)
			it '方向は変化しない', ->
				expect(avator.direction).toEqual(0)
			it '残りのX移動量が正しい', ->
				expect(avator.vx).toEqual(- 28)
			it '残りのY移動量が正しい', ->
				expect(avator.vy).toEqual(0)
			it '状態が移動中である', ->
				expect(avator.isWalking()).toBe(true)

		it '右へ移動するとき(2)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 + 4)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(- 24)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '右へ移動するとき(3)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 + 8)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(- 20)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '右へ移動するとき(4)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 + 12)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(- 16)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '右へ移動するとき(5)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 + 16)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(- 12)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '右へ移動するとき(6)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 + 20)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(- 8)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '右へ移動するとき(7)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 + 24)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(- 4)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '右へ移動するとき(8)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 + 28)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		it '右への移動が完了したとき', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(5)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 5)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		describe '左へ移動するとき(1)', ->
			beforeEach ->
				avator.cell_x = 3
				avator.vx = 32
				avator.updatePosition()

			it 'Xセル座標が正しい', ->
				expect(avator.cell_x).toEqual(3)
			it 'Yセル座標が正しい', ->
				expect(avator.cell_y).toEqual(6)
			it 'X座標が正しい', ->
				expect(avator.x).toEqual(32 * 4)
			it 'Y座標が正しい', ->
				expect(avator.y).toEqual(32 * 6)
			it '方向は変化しない', ->
				expect(avator.direction).toEqual(0)
			it '残りのX移動量が正しい', ->
				expect(avator.vx).toEqual(28)
			it '残りのY移動量が正しい', ->
				expect(avator.vy).toEqual(0)
			it '状態が移動中である', ->
				expect(avator.isWalking()).toBe(true)

		it '左へ移動するとき(2)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 - 4)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(24)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '左へ移動するとき(3)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 - 8)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(20)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '左へ移動するとき(4)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 - 12)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(16)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '左へ移動するとき(5)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 - 16)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(12)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '左へ移動するとき(6)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 - 20)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(8)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '左へ移動するとき(7)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 - 24)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(4)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(true)

		it '左へ移動するとき(8)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 4 - 28)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		it '左への移動が完了したとき', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(3)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 3)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

	describe 'Y方向の移動(座標更新)', ->
		avator = null
		beforeEach ->
			new OrderMaidGameView()

		it '移動前の状態が正しい', ->
			avator = new AvatorBase(35, 35, 9, 5)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		it '移動する必要がないときには、値を更新しない', ->
			avator.updatePosition()
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		describe '下へ移動するとき(1)', ->
			beforeEach ->
				avator.cell_y = 6
				avator.vy = - 32
				avator.updatePosition()

			it 'Xセル座標が正しい', ->
				expect(avator.cell_x).toEqual(9)
			it 'Yセル座標が正しい', ->
				expect(avator.cell_y).toEqual(6)
			it 'X座標が正しい', ->
				expect(avator.x).toEqual(32 * 9)
			it 'Y座標が正しい', ->
				expect(avator.y).toEqual(32 * 5)
			it '方向は変化しない', ->
				expect(avator.direction).toEqual(0)
			it '残りのX移動量が正しい', ->
				expect(avator.vx).toEqual(0)
			it '残りのY移動量が正しい', ->
				expect(avator.vy).toEqual(-28)
			it '状態が移動中である', ->
				expect(avator.isWalking()).toBe(true)

		it '下へ移動するとき(2)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 + 4)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(- 24)

			expect(avator.isWalking()).toBe(true)

		it '下へ移動するとき(3)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 + 8)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(- 20)

			expect(avator.isWalking()).toBe(true)

		it '下へ移動するとき(4)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 + 12)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(- 16)

			expect(avator.isWalking()).toBe(true)

		it '下へ移動するとき(5)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 + 16)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(- 12)

			expect(avator.isWalking()).toBe(true)

		it '下へ移動するとき(6)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 + 20)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(- 8)

			expect(avator.isWalking()).toBe(true)

		it '下へ移動するとき(7)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 + 24)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(- 4)

			expect(avator.isWalking()).toBe(true)

		it '下へ移動するとき(8)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 + 28)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		it '下への移動が完了したとき', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(6)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 6)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		describe '上へ移動するとき(1)', ->
			beforeEach ->
				avator.cell_y = 4
				avator.vy = 32
				avator.updatePosition()

			it 'Xセル座標が正しい', ->
				expect(avator.cell_x).toEqual(9)
			it 'Yセル座標が正しい', ->
				expect(avator.cell_y).toEqual(4)
			it 'X座標が正しい', ->
				expect(avator.x).toEqual(32 * 9)
			it 'Y座標が正しい', ->
				expect(avator.y).toEqual(32 * 5)
			it '方向は変化しない', ->
				expect(avator.direction).toEqual(0)
			it '残りのX移動量が正しい', ->
				expect(avator.vx).toEqual(0)
			it '残りのY移動量が正しい', ->
				expect(avator.vy).toEqual(28)
			it '状態が移動中である', ->
				expect(avator.isWalking()).toBe(true)

		it '上へ移動するとき(2)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 - 4)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(24)

			expect(avator.isWalking()).toBe(true)

		it '上へ移動するとき(3)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 - 8)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(20)

			expect(avator.isWalking()).toBe(true)

		it '上へ移動するとき(4)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 - 12)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(16)

			expect(avator.isWalking()).toBe(true)

		it '上へ移動するとき(5)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 - 16)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(12)

			expect(avator.isWalking()).toBe(true)

		it '上へ移動するとき(6)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 - 20)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(8)

			expect(avator.isWalking()).toBe(true)

		it '上へ移動するとき(7)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 - 24)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(4)

			expect(avator.isWalking()).toBe(true)

		it '上へ移動するとき(8)', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 5 - 28)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

		it '上への移動が完了したとき', ->
			avator.updatePosition()
			expect(avator.cell_x).toEqual(9)
			expect(avator.cell_y).toEqual(4)
			expect(avator.x).toEqual(32 * 9)
			expect(avator.y).toEqual(32 * 4)
			expect(avator.direction).toEqual(0)
			expect(avator.vx).toEqual(0)
			expect(avator.vy).toEqual(0)

			expect(avator.isWalking()).toBe(false)

	describe 'アニメーション(下向き)', ->
		avator = null

		beforeEach ->
			new OrderMaidGameView()
			avator = new AvatorBase(35, 35, 2, 2)

		it '移動せず下を向いたとき', ->
			avator.setDirection 0
			expect(avator.frame).toEqual(0)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(0)

		it '移動中', ->
			avator.setDirection 0
			avator.cell_y++
			avator.vy = - 32
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(0)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(1)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(2)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(3)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(0)

	describe 'アニメーション(左向き)', ->
		avator = null

		beforeEach ->
			new OrderMaidGameView()
			avator = new AvatorBase(35, 35, 2, 3)

		it '移動せず左を向いたとき', ->
			avator.setDirection 1
			expect(avator.frame).toEqual(4)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(4)

		it '移動中', ->
			avator.setDirection 1
			avator.cell_x--
			avator.vx = 32
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(4)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(5)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(6)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(7)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(4)

	describe 'アニメーション(右向き)', ->
		avator = null

		beforeEach ->
			new OrderMaidGameView()
			avator = new AvatorBase(35, 35, 2, 5)

		it '移動せず右を向いたとき', ->
			avator.setDirection 2
			expect(avator.frame).toEqual(8)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(8)

		it '移動中', ->
			avator.setDirection 2
			avator.cell_x++
			avator.vx = - 32
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(8)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(9)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(10)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(11)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(8)

	describe 'アニメーション(上向き)', ->
		avator = null

		beforeEach ->
			new OrderMaidGameView()
			avator = new AvatorBase(35, 35, 3, 7)

		it '移動せず上を向いたとき', ->
			avator.setDirection 3
			expect(avator.frame).toEqual(12)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(12)

		it '移動中', ->
			avator.setDirection 3
			avator.cell_y--
			avator.vy = 32
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(12)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(13)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(14)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(15)
			avator.updateWalkAnimation()
			expect(avator.frame).toEqual(12)