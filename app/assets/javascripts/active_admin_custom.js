$(document).ready(function(){

  $(".edit-quantity-btn").click(function() {
  	$(this).prev().prev().hide();
  	$(this).prev().show();
  	$(this).next().show();
  	$(this).hide();
  })
  $(".cancel-quantity-btn").click(function() {
    var _this = $(this);
    var $qnt = _this.prev().prev();
  	$qnt.prev().show();
  	$qnt.hide();
  	$(this).hide();
  	$(this).prev().show();

    if (parseInt($qnt.val()) > parseInt(_this.attr("data-max")) ||
    parseInt($qnt.val()) < parseInt(_this.attr("data-min"))) {
      $qnt.prev().removeClass("fit_quantity");
      $qnt.prev().addClass("high_quantity");
    }else {
      $qnt.prev().removeClass("high_quantity");
      $qnt.prev().addClass("fit_quantity");
    }
    $.ajax({
      url:'/order_items/update',
      type: 'PUT',
      dataType: 'json',
      data: {
        id: _this.attr("data-id"),
        quantity: _this.prev().prev().val()
      },
      success: function(result) {
        $qnt.prev().text(result.quantity)
      }
    })
  })

  $('.quantity-input').on("paste keyup keypress", function(e) {
    var code = e.keyCode || e.which;
    if(code == 13) { //Enter keycode
      e.preventDefault();
      return false;
    }
    var el = $(this);
    var val = parseInt(el.val());
    var min = parseInt(el.data("min"));
    var max = parseInt(el.data("max"));
    if(val == 0) {
      return true;
    }

    window.clearTimeout($(this).data("timeout"));
    el.data("timeout", setTimeout(function () {
      var val = parseInt(el.val());

      if (val < min) {
        el.tooltipster('open', function(instance, helper){
          instance.content("Minimum allowed value is "+ min +".");
        });
      }
      else if (val > max) {
        el.tooltipster('open', function(instance, helper){
          var msg = "Maximum Quantity is "+max+". Ordering more than "+max+" requires approval after order is placed.";
          instance.content(msg);
        });
      }

    }, 300));

  });

  $(".cart-submit").click(function(e) {
    e.preventDefault();
    $('#new_order').submit();
    return false;
  })

  $('.quantity-input').tooltipster({
     animation: 'fade',
     delay: 200,
     timer: 3000,
     theme: 'tooltipster-noir',
     trigger: 'custom',
     maxWidth: '300',
     contentCloning: true
  });
})
