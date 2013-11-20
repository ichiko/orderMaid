/**
 * mapLoader.js ｖ 0.0.1
 * The MIT Lisence
 * Copyright (c) 2011 Tetsuroh Kunieda
 * 
 * How to use > http://d.hatena.ne.jp/tetsuroh/20111118/1321599538
 * 
 * 2011/11/18 v0.0.0 
 * 2011/11/20 v0.0.1 オブジェクトレイヤに配置されたオブジェクトの読み込みに対応
 * 2011/11/21 v0.0.2 enchant.jsのコードをいじらないように修正
 * 2013/11/01 v0.0.3 改変 ロードするデータを back/middle/fore の3階層に変更 by Ichiko Moro
 */
(function(window, namespace, undefined) {
  /**
   * マップローダー
   * @object
   * @param {Array} map マップ（背景）
   * @param {Array} collision 当たり判定
   * @param {Array} foreground マップ（前景）
   */
  var mapLoader = {};
  //名前空間を設定
  if(!window[namespace]) {
    window[namespace] = mapLoader;
  }
  mapLoader.file = null;

  /*
   * window.onloadにゲームの処理が入ってる（はず）なので一旦避難させて
   　* マップを読み込み終わってから実行させる
   　*/
  mapLoader.onload = window.onload;

  /*
   * マップを読み込む
   */
  window.onload = function() {
    mapLoader.file = mapLoader.file || 'map.tmx';
    HTTP.getText(mapLoader.file, mapParser);
  };
  function xmlParser(data) {
    console.dir(data);
  }

  /*
   * サイ本からパクった非同期通信処理
   */
  var HTTP = {};
  HTTP._factories = [
  function() {
    return new XMLHttpRequest();
  },

  function() {
    return new ActiveXObject('Msxml2.XMLHTTP');
  },

  function() {
    return new ActiveXObject('Microsoft.XMLHTTP');
  }

  ];

  HTTP._factory = null;

  HTTP.newRequest = function() {
    if(HTTP._factory != null)
      return HTTP._factory();

    for(var i = 0;i < HTTP._factories.length;i++) {
      try {
        var factory = HTTP._factories[i];
        var request = factory();
        if(request != null) {
          HTTP._factory = factory;
          return request;
        }
      } catch(e) {
        console.log(e);
        continue;
      }
    }
  };
  HTTP.getText = function(url, callback) {
    var request = HTTP.newRequest();
    request.onreadystatechange = function() {
      if(request.readyState == 4 && request.status == 200
      || request.readyState == 4 && request.status === 0) {
        callback(request.responseText);
      }
    };
    request.open('GET', url);
    request.send(null);
  };
  HTTP.getXML = function(url, callback) {
    var request = HTTP.newRequest();
    request.onreadystatechange = function() {
      if(request.readyState == 4 && request.status == 200
      || request.readyState == 4 && request.status === 0) {
        callback(request/*.responseXML*/);
      }
    };
    request.open('GET', url);
    request.send(null);

  };
  var createFromAttr = function(source, target) {
  	if(typeof source != typeof {} && typeof target != typeof {}){
  	  return;
  	}
	if(source.localName == 'property'){
        target[source.getAttribute('name')] = source.getAttribute('value');
        return;
	}
    for(var i in source.attributes) {
      if(source.attributes.hasOwnProperty(i)) {
      	console.log(i);
        target[source.attributes[i].name] = source.attributes[i].value;
      }
    }
  };

  /**
   * mapデータをパースする
   * @param {String} str 解析対象の文字列
   * @return {Array}
   */
  function mapParser(str) {
    try {
      mapLoader.map = [];
      mapLoader.collision = [];
      mapLoader.foreground = [];
      mapLoader.middleground = [];
      mapLoader.objects = {};

      mapLoader.xml = document.createElement('div');//XML.parser(str);
      mapLoader.xml.innerHTML = str;
      var layers = mapLoader.xml.getElementsByTagName('layer');

      for(var i = 0;i < layers.length;i++) {//レイヤー
        var isCollision = layers[i].getAttribute('name').toLowerCase() === 'collision';
        var isForeground = /^foreground/.test(layers[i].getAttribute('name').toLowerCase());
        var isMiddleground = /^middle/.test(layers[i].getAttribute('name'.toLowerCase()));
        var isUnvisible = layers[i].getAttribute('visible') === '0';

        var encoding = layers[i].getElementsByTagName('data')[0].getAttribute('encoding');
        if(encoding !== 'csv') {
          alert('Tiled Map Editorの編集＞設定から「レイヤーデータの保持方法」をCSVに設定してください');
          return false;
        }

        if(isUnvisible && !isCollision)
          continue;
        var lines = layers[i].getElementsByTagName('data')[0].innerHTML.split(',\n');
        //レイヤーごとの行
        for(var j = 0;j < lines.length;j++) {
          var params = lines[j].split(',');
          //行ごとのパラメータ
          for(var k = 0;k < params.length;k++) {
            if(isCollision) {
              params[k] = params[k] > 0?1:0;
            } else {
              params[k] = parseInt(params[k], 10) - 1;
            }
          }
          lines[j] = params;
        }
        if(isCollision) {
          mapLoader.collision = lines;
        } else if(isForeground) {
          mapLoader.foreground.push(lines);
        } else if (isMiddleground) {
          mapLoader.middleground.push(lines);
        } else {
          mapLoader.map.push(lines);
        }
      }

      var objects = mapLoader.xml.getElementsByTagName('object');
      mapLoader.objDOM = objects;
      for(var j = 0;j < objects.length;j++) {
        var name = objects[j].getAttribute('name');
        if(name) {
          mapLoader.objects[name] = {};
          console.dir(objects);
          createFromAttr(objects[j], mapLoader.objects[name]);
          var properties = objects[j].getElementsByTagName('property');
          for(var k = 0;k < properties.length;k++){
	         createFromAttr(properties[k], mapLoader.objects[name]);
          }
        }
      }
      mapLoader.onload();
    } catch (e) {
      console.log(e);
    }
  }
})(this, 'mapLoader');