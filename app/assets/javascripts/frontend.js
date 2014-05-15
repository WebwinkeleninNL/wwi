//= require jquery
//= require jquery.customSelect
//= require jquery.nouislider
//= require jquery.cookie
//= require jquery.modal
//= require angular

var myshopApp = angular.module('myshopApp', ['ngRoute']);

myshopApp.config(['$routeProvider',function($routeProvider) {

}]);


$.cookie.defaults = {path: '/', secure: false, expires: 365};

function add_product_to_basket(basket, product){
  basket.find('ul').append(basket_item_template(product));
};

function store_product_id_to_cookie(id){
  var ids = $.cookie('product_ids');

  $.cookie('product_ids', ids == undefined ? id : [ids, id].join(','));
}

function basket_item_template(product){
  return "<li data-id='" + product.id + "' data-price='"+product.price+"'><img src='" + product.image_url + "' height='50'/>"+
  "<a href='" + product.url +"'>" + product.name +"</a>"+
  "<span class='price'><span class='currency'>&euro;</span>"+
  product.price +"<a href='#' class='delete'><img src='/assets/frontend/minicart_popup_delete.png' alt='Verwijderen'/></a></span>"+
  "</li>"
};

function set_total(){
  var total_price = $('.minicart_popup_total .price');
  var total_price_cap = $('.minicart .price');
  var total_items_cap = $('.minicart .items');
  var total_price_value = parseFloat($.cookie('basket_item_total_price') || 0, 10);
  var total_items = parseInt($.cookie('basket_items') || 0, 10)

  total_price.html( total_price_value );
  total_price_cap.html( total_price_value );
  total_items_cap.html( total_items )
}

function update_total(price, inc_value){
  var inc_value = inc_value || 1;
  var total_price = $('.minicart_popup_total .price');
  var total_price_cap = $('.minicart .price');
  var total_items_cap = $('.minicart .items');
  var total_price_value = parseFloat($.cookie('basket_item_total_price') || 0, 10);
  var total_items = parseInt($.cookie('basket_items') || 0, 10)

  // UI
  total_price.html( total_price_value + price );
  total_price_cap.html( total_price_value + price );
  total_items_cap.html( total_items + inc_value );

  // Cookies
  $.cookie('basket_item_total_price', total_price_value + price);
  $.cookie('basket_items', total_items + inc_value);
};

function add_product_to_cookie(product){
  var key = 'basket_item_'+product.id,
      value = 'id='+ product.id +';name='+product.name+';image_url='+product.image_url+';price='+product.price+';url='+product.url;
  $.cookie( key, value );
};

function fill_basket_from_cookies(){
  var $basket_container = $('#minicart_popup');

  var product_ids = $.cookie('product_ids') === undefined ? [] : $.cookie('product_ids').split(','),
      i=null, product = null;
  if( product_ids.length > 0 ){
    for(i = 0; i < product_ids.length; i++){
      product = $.cookie('basket_item_'+product_ids[i]);
      if( product !== undefined ){
        add_product_to_basket($basket_container, build_product_from_string( product ));
      }
    }
    set_total();
  }
};

function build_product_from_string(input){
  var product = {};

  var key_values = input.split(';'), key = null, value=null, tmp=null, i = null;

  for(i = 0; i < key_values.length; i++){
    tmp = key_values[i].split('=');
    key = tmp[0];
    value = tmp[1];
    product[key] = value;
  }

  return product;
}

function remove_item_from_basket(e){
  e.preventDefault();

  var self = $(this),
      product_elem = self.parents('li'),
      product_id = product_elem.data('id'),
      product_ids = $.cookie('product_ids'),
      product_price = product_elem.data('price');

  // remove from cookies
  $.removeCookie('basket_item_'+product_id);
  product_ids = product_ids.replace(product_id,'');
  $.cookie('product_ids', product_ids);

  update_total(-product_price, -1)

  // remove from DOM
  product_elem.remove();
}

$(function(){
  fill_basket_from_cookies();
  $('#minicart-outer').mouseover(function() {
    var $popup = $('#minicart_popup');
    $popup.fadeIn('fast');
    $(this).mouseleave(function() {
      $popup.fadeOut('fast');
    });
  });

  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  var flash_notice = $('.flash_notice')

  $('[name="shoppingBag"]').bind('click', add_item_to_basket);
  $(document.body).on('click', '#minicart-outer ul li a.delete', remove_item_from_basket);

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
  //$('.shoppingbag a span.items').html($.cookie('shoppingbag'));


  $('.register').bind('click', function(e){
    e.preventDefault();

    $('#register-form').modal();
  });

  // $('.register-close').bind('click', function(e){
  //   e.preventDefault();

  //   window.close();
  //   return true;
  // });

});

/* functions for basket */

function add_item_to_basket(e){
  e.preventDefault();
  var self = $(this);
  var p = $('.product-info');

  var is_product_new_for_basket = $.cookie('product_ids') === undefined ? true : $.cookie('product_ids').split(',').indexOf(p.data('id').toString()) == -1;

  if( is_product_new_for_basket ){

    var product = {
      id: p.data('id'),
      url: p.data('url'),
      name: p.data('name'),
      image_url: p.data('image-url'),
      price: parseFloat(p.data('price'), 10),
      variant_id: p.data('variant-id'),
      quantity: parseInt($('input[name="quantity"]').val(), 10)
    };

    var $basket_container = $('#minicart_popup');

    $.ajax({
      url: '/shopping/cart_items',
      type: 'POST',
      data: {
        'cart_item': {
          'quantity': product.quantity,
          'variant_id': product.variant_id
        }
      },
      dataType: 'json',
      success: function(data, status, xhr){
        add_product_to_cookie(product);
        update_total(product.price);
        store_product_id_to_cookie(product.id);

        add_product_to_basket($basket_container, product);
        $basket_container.fadeIn('fast');
      },
      error: function(xhr, status, errorThrown){
        flash_notice.html('Error');
      },
    })
  }
};

