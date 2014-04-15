//= require jquery
//= require jquery.customSelect
//= require jquery.nouislider
//= require jquery.cookie

function add_product_to_basket(basket, product){
  basket.find('.items').append("<li><a href='/products/"+product.url+"'>"+product.name +"</a><a class='delete' href='#delete'>x</a></li>");
}
$.removeCookie('basket-items');
$.removeCookie('shoppingbag');

$(function(){
  var mini_basket = $('.mini-basket');

  if($.cookie('basket-items') !== undefined){
    var products = $.cookie('basket-items').split(';'), product = null, tmp = null;
    if(products.length > 0){
      for (var i = products.length - 1; i >= 0; i--) {
        tmp = products[i].split(',');
        product = {
          url: tmp.split('url:')[1],
          name: tmp.split('name:')[1],
          variant_id: tmp.split('sku:')[1]
        };

        add_product_to_basket(mini_basket, product);
      };
    }
  }

  var flash_notice = $('.flash_notice')

  $('.shoppingbag > a').bind('click', function(e){
    e.preventDefault();
    mini_basket.toggle();
  });

  $('[name="shoppingBag"]').bind('click', function(e){
    e.preventDefault();
    var self = $(this);

    if( !self.hasClass('pressed') ){
      self.addClass('pressed');
    var qty = parseInt($('input[name="quantity"]').val());

    var shoppingbag = $('.shoppingbag a span.items');
    var items = parseInt(shoppingbag.html());
    var total = items + qty;

    shoppingbag.html(total);
    mini_basket.toggle();


    var p = $('.product-info');
    var product = {
      url: p.data('url'),
      name: p.data('name'),
      variant_id: p.data('variant-id')
    }

    // save to cookie
    $.cookie('shoppingbag', total);

    var products = $.cookie('basket-items');
    products += "name:"+product.name+",url:"+product.url+',sku:'+product.variant_id+';'
    $.cookie('basket-items', products);

      $.ajax({
        url: '/shopping/cart_items',
        type: 'POST',
        data: {
          'cart_item': {
            'quantity': qty,
            'variant_id': product.variant_id
          }
        },
        dataType: 'json',
        success: function(data, status, xhr){
          add_product_to_basket(mini_basket, product);
        },
        error: function(xhr, status, errorThrown){
          flash_notice.html('Error');
        },
      })
    }
  });

  $('.mini-basket .delete').bind('click', function(e){
    e.preventDefault();

    $(this).parent().remove();
    $.removeCookie('basket-items');
    $.removeCookie('shoppingbag');
  })


  $('select.styled').customSelect();
  $('.slide-up-tabs li span a').bind('click', function(e){
    e.preventDefault();

    $(this).parents('li').find('> ul').slideToggle();
    $(this).parents('li').toggleClass('open');

  });

  $('.quantity .minus').bind('click', function(e){
    e.preventDefault();

    var qty = $('input[name="quantity"]');
    var old = parseInt(qty.val());

    if(old > 1){
      qty.val(old - 1);
    }

    return false;
  });
  $('.quantity .plus').bind('click', function(e){
    e.preventDefault();

    var qty = $('input[name="quantity"]');
    var old = parseInt(qty.val());

    qty.val(old + 1);

    return false;
  });

  // Setting up busket items
  $('.shoppingbag a span.items').html($.cookie('shoppingbag'));
})