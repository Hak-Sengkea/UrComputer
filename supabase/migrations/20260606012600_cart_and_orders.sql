-- ==========================================
-- 1. CREATE CARTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.carts (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL UNIQUE,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.carts ENABLE ROW LEVEL SECURITY;

-- Policies for carts
CREATE POLICY "Users can manage their own carts"
ON public.carts FOR ALL
USING (auth.uid() = user_id);

-- ==========================================
-- 2. MIGRATE EXISTING CART DATA
-- ==========================================
-- Create carts for any users who currently have cart_items
INSERT INTO public.carts (user_id)
SELECT DISTINCT user_id FROM public.cart_items
ON CONFLICT (user_id) DO NOTHING;

-- ==========================================
-- 3. RESTRUCTURE CART_ITEMS TABLE
-- ==========================================
-- Add cart_id column to cart_items (temporarily nullable)
ALTER TABLE public.cart_items ADD COLUMN IF NOT EXISTS cart_id uuid REFERENCES public.carts(id) ON DELETE CASCADE;

-- Map existing cart_items to the new carts using user_id
UPDATE public.cart_items ci
SET cart_id = c.id
FROM public.carts c
WHERE ci.user_id = c.user_id;

-- Make cart_id NOT NULL
ALTER TABLE public.cart_items ALTER COLUMN cart_id SET NOT NULL;

-- 3.1 Drop dependencies first to allow column removal
-- Drop old policy referencing user_id
DROP POLICY IF EXISTS "Users can manage their own cart items" ON public.cart_items;

-- Drop the old unique constraint that enforced unique (user_id, product_id)
ALTER TABLE public.cart_items DROP CONSTRAINT IF EXISTS cart_items_user_id_product_id_key;

-- 3.2 Drop the user_id column
ALTER TABLE public.cart_items DROP COLUMN IF EXISTS user_id;

-- 3.3 Add new constraints and policies
-- Add new unique constraint to prevent duplicate product entries in the same cart
ALTER TABLE public.cart_items ADD CONSTRAINT cart_items_cart_id_product_id_key UNIQUE (cart_id, product_id);

-- Create new policy checking if parent cart belongs to user
CREATE POLICY "Users can manage their own cart items"
ON public.cart_items FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM public.carts
        WHERE public.carts.id = public.cart_items.cart_id
        AND public.carts.user_id = auth.uid()
    )
);

-- ==========================================
-- 4. CREATE ORDERS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.orders (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
    status text DEFAULT 'pending'::text NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    total_amount numeric(10, 2) NOT NULL CHECK (total_amount >= 0),
    
    -- Address details captured at purchase time
    shipping_address text NOT NULL,
    shipping_city text NOT NULL,
    shipping_state text,
    shipping_zip text,
    
    -- Payment state
    payment_status text DEFAULT 'pending'::text NOT NULL CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')),
    payment_method text,
    
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

-- Policies for orders
CREATE POLICY "Users can manage their own orders"
ON public.orders FOR ALL
USING (auth.uid() = user_id);

-- ==========================================
-- 5. CREATE ORDER_ITEMS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.order_items (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id uuid REFERENCES public.orders(id) ON DELETE CASCADE NOT NULL,
    product_id uuid REFERENCES public.products(id) ON DELETE SET NULL,
    product_name text NOT NULL,
    quantity integer NOT NULL CHECK (quantity > 0),
    price numeric(10, 2) NOT NULL CHECK (price >= 0),
    discount numeric(5, 2) DEFAULT 0.0 CHECK (discount >= 0.0),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

-- Policies for order_items (Users can view and insert their own order items)
CREATE POLICY "Users can manage their own order items"
ON public.order_items FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM public.orders
        WHERE public.orders.id = public.order_items.order_id
        AND public.orders.user_id = auth.uid()
    )
);

-- ==========================================
-- 6. AUTOMATIC UPDATED_AT TRIGGER FOR ORDERS
-- ==========================================
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS trigger AS $$
BEGIN
  new.updated_at = timezone('utc'::text, now());
  RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_order_updated
  BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
