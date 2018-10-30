var index = 0;
var timestap;
jQuery(document).ready(function($) {
  $("body").click(function(e) {
    // var a = new Array("天真","富强", "民主", "文明", "和谐", "自由", "平等", "公正" ,"法治", "爱国", "敬业", "诚信", "友善");
    if(index===0||index===1){
      timestap = Date.parse(new Date())/1000;
    }else{
      if(Date.parse(new Date())/1000-timestap>7){
        index = 0;
        timestap = Date.parse(new Date())/1000;
      }
    }
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
      "color": "#ff6651"
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
