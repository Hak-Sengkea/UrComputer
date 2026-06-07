import 'package:mobile/models/cart.dart';
import 'package:mobile/models/cart_items.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CartRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Cart> GetOrCreateCart(String userId) async {
    try{
      final response = await _supabase.from('carts').select().eq('user_id',userId).maybeSingle();
      if(response != null){
        return Cart.fromJson(response);
      }else{
        const uuid = Uuid();
        final newCart = Cart(id: uuid.v4(), userId: userId, items: []);
        await _supabase.from('carts').insert(newCart.toJson());

        return newCart;
      }
    }catch(error){
      throw Exception('Failed to get or create cart');
    }
  }

  Future<List<CartItems>> GetCartItems(String cartId) async {
    final response = await _supabase
    .from('cart_items')
    .select('*, product:products(*)')
    .eq('cart_id', cartId);

    return (response as List).map((json) => CartItems.fromJson(json)).toList();
  }

  Future<void> AddToCart(String cartId,String productId,int quantity) async {
    try{
      await _supabase.from('cart_items').upsert({
        'cart_id': cartId,
        'product_id': productId,
        'quantity': quantity,
      }, onConflict: 'cart_id, product_id');
    }catch(error){
      throw Exception('Failed to add item to cart');
    }
  }

  Future<void> updateItemQuantity(String itemId,int quantity) async {
    await _supabase.from('cart_items').update({
      'quantity': quantity,
    }).eq('id', itemId);
  }

  Future<void> removeFromCart(String itemId) async {
    await _supabase.from('cart_items').delete().eq('id', itemId);
  }

  Future<void> clearCart(String cartId) async {
    await _supabase.from('cart_items').delete().eq('cart_id', cartId);
  }
}