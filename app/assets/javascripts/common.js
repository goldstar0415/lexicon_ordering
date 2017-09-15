$(document).ready(function(){
  
  $('.quantity-input').on("change paste keyup", function(e) {
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
        // el.val(0);
      }
      else if (val > max) {
        el.tooltipster('open', function(instance, helper){
          var msg = "Maximum Quantity is "+max+". Ordering more than "+max+" requires approval after order is placed.";
          instance.content(msg);
        }); 
        // el.val(0);
      }
      
    }, 300));

  });
  
  // $("#new_order").submit(function() {
  //   return !$(".quantity-input").hasClass('error');
  // })
  
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
  
  $('.quantity-input').tooltipster({
     animation: 'fade',
     delay: 200,
     timer: 3000,
     theme: 'tooltipster-noir',
     trigger: 'custom',
     maxWidth: '300',
     contentCloning: true
  });
  
});