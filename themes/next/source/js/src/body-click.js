var index = 0;
// var timestap;
jQuery(document).ready(function($) {
  $("body").click(function(e) {
    // if(index===0||index===1){
    //   timestap = Date.parse(new Date())/1000;
    // }else{
    //   if(Date.parse(new Date())/1000-timestap>7){
    //     index = 0;
    //     timestap = Date.parse(new Date())/1000;
    //   }
    // }

    var a = new Array("#8B00FF","#FF0000","#FF7F00","#FFFF00", "#00FF00", "#00FFFF","#0000FF");
      index++;

    var $i = $("<span/>").text("+"+index+"s");
    var x = e.pageX,
      y = e.pageY;
    $i.css({
      "z-index": 999999999999999999999999999999999999999999999999999999999999999999999,
      "top": y - 20,
      "left": x,
      "position": "absolute",
      "font-weight": "bold",
      "color": a[index%(a.length)]
    });
    $("body").append($i);
    $i.animate({
        "top": y - 180,
        "opacity": 0
      },
      1500,
      function() {
        $i.remove();
      });
  });
});
