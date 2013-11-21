// code9leap_16598
// 2012/10/19   吹き出しクラスVer.2 by v416
// 2013/11/07   func text の文字描画の縦位置を修正。吹き出しの中央に表示するようにした。

TTweet = enchant.Class.create(enchant.Sprite, {
    initialize : function(w, h, line, align) {
        enchant.Sprite.call(this, w, h + TTweet.TAIL);
        this.line = line;
        this.align = align;
        this.image = new Surface(w, h + TTweet.TAIL);
        this.liner = new Surface(w, h);
        var t = TTweet.TAIL;
        var s = TTweet.SIZE;
        var c = TTweet.CURVE;
        this.outCurve = {
            lt : {x:0, y:0},
            rt : {x:w, y:0},
            rd : {x:w, y:h},
            ld : {x:0, y:h}
        };
        this.inCurve = {
            lt : {x:0+s, y:0+s},
            rt : {x:w-s, y:0+s},
            rd : {x:w-s, y:h-s},
            ld : {x:0+s, y:h-s}
        };
        var o = this.outCurve;
        var i = this.inCurve;
        
        with(this.liner.context) {
            fillStyle = 'black';
            strokeStyle = 'black';
            beginPath();
            moveTo(o.lt.x, o.lt.y+c);
            quadraticCurveTo(o.lt.x, o.lt.y, o.lt.x+c, o.lt.y);
            lineTo(o.rt.x-c, o.rt.y);
            quadraticCurveTo(o.rt.x, o.rt.y, o.rt.x, o.rt.y+c);
            lineTo(o.rd.x, o.rd.y-c);
            quadraticCurveTo(o.rd.x, o.rd.y, o.rd.x-c, o.rd.y);
            lineTo(o.ld.x+c, o.ld.y);
            quadraticCurveTo(o.ld.x, o.ld.y, o.ld.x, o.ld.y-c);
            closePath();
            fill();
            stroke();
            // 抜く
	        fillStyle = 'white';
            beginPath();
            moveTo(i.lt.x, o.lt.y+c);
            quadraticCurveTo(i.lt.x, i.lt.y, o.lt.x+c, i.lt.y);
            lineTo(o.rt.x-c, i.rt.y);
            quadraticCurveTo(i.rt.x, i.rt.y, i.rt.x, o.rt.y+c);
            lineTo(i.rd.x, o.rd.y-c);
            quadraticCurveTo(i.rd.x, i.rd.y, o.rd.x-c, i.rd.y);
            lineTo(o.ld.x+c, i.ld.y);
            quadraticCurveTo(i.ld.x, i.ld.y, i.ld.x, o.ld.y-c);
            closePath();
            fill();
        };
        // しっぽ
        var b = {
            x:this.align==TTweet.LEFT ?TTweet.HORN:
              this.align==TTweet.RIGHT?this.width-TTweet.HORN:this.width/2,
            y:this.line==TTweet.TOP?0:this.height
        };
        var triangle = {
            c:{x:b.x  ,y:b.y},
            l:{x:b.x-TTweet.TAIL/2,y:b.y+(this.line==TTweet.TOP?1:-1)*TTweet.TAIL},
            r:{x:b.x+TTweet.TAIL/2,y:b.y+(this.line==TTweet.TOP?1:-1)*TTweet.TAIL}
        };
        with(this.image.context) {
            fillStyle = 'black';
            strokeStyle = 'black';
            beginPath();
            moveTo(triangle.l.x,triangle.l.y);
            lineTo(triangle.c.x,triangle.c.y);
            lineTo(triangle.r.x,triangle.r.y);
            closePath();
            fill();
            stroke();
        };
        //this.clear();
    },
    clear : function() {
        this.image.draw(this.liner, 0, this.line == TTweet.TOP ? TTweet.TAIL : 0);
    },
    text : function(text) {
        this.clear();
        with(this.image.context) {
	        fillStyle = 'black';
            textAlign = 'center';
            textBaseline = 'middle';
            fillText(text,this.width/2,this.height/2 + (this.line==TTweet.TOP?TTweet.TAIL / 2:-TTweet.TAIL / 2));
        };
    }
});
TTweet.TAIL   =  8;
TTweet.SIZE   =  2;
TTweet.CURVE  = 16;
TTweet.HORN   = 16;
TTweet.TOP    = "top";
TTweet.BOTTOM = "bottom";
TTweet.CENTER = "center";
TTweet.LEFT   = "left";
TTweet.RIGHT  = "right";
