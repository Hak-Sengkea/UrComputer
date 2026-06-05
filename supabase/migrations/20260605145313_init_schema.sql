-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. CATEGORIES TABLE
-- ==========================================
CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    icon text,
    banner text,
    description text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

-- Allow public read access (anyone can view categories)
CREATE POLICY "Allow public read access to categories" 
ON public.categories FOR SELECT 
USING (true);


-- ==========================================
-- 2. BRANDS TABLE
-- ==========================================
CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    logo text,
    description text,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;

-- Allow public read access (anyone can view brands)
CREATE POLICY "Allow public read access to brands" 
ON public.brands FOR SELECT 
USING (true);


-- ==========================================
-- 3. PRODUCTS TABLE
-- ==========================================
CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name text NOT NULL,
    description text,
    price numeric(10, 2) NOT NULL,
    discount numeric(5, 2) DEFAULT 0.0,
    category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
    brand_id uuid REFERENCES public.brands(id) ON DELETE SET NULL,
    image text,
    stock integer DEFAULT 0,
    rating numeric(3, 2) DEFAULT 0.0,
    reviews_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

-- Allow public read access (anyone can view products)
CREATE POLICY "Allow public read access to products" 
ON public.products FOR SELECT 
USING (true);


-- ==========================================
-- 4. PROFILES TABLE (Linked to Supabase Auth)
-- ==========================================
CREATE TABLE public.profiles (
    id uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email text NOT NULL,
    first_name text,
    last_name text,
    phone text,
    profile_image text,
    updated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profile Policies
CREATE POLICY "Allow users to read their own profile" 
ON public.profiles FOR SELECT 
USING (auth.uid() = id);

CREATE POLICY "Allow users to update their own profile" 
ON public.profiles FOR UPDATE 
USING (auth.uid() = id);

-- TRIGGER: Automatically create a profile when a new user registers via Supabase Auth
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, first_name, last_name, phone)
  VALUES (
    new.id,
    new.email,
    COALESCE(new.raw_user_meta_data->>'first_name', ''),
    COALESCE(new.raw_user_meta_data->>'last_name', ''),
    new.raw_user_meta_data->>'phone'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- ==========================================
-- 5. ADDRESSES TABLE
-- ==========================================
CREATE TABLE public.addresses (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    label text DEFAULT 'Home'::text,
    street text NOT NULL,
    city text NOT NULL,
    state text,
    zip text,
    is_default boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.addresses ENABLE ROW LEVEL SECURITY;

-- Address Policies
CREATE POLICY "Users can manage their own addresses" 
ON public.addresses FOR ALL 
USING (auth.uid() = user_id);


-- ==========================================
-- 6. WISHLISTS TABLE (Many-to-Many Relationship)
-- ==========================================
CREATE TABLE public.wishlists (
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    product_id uuid REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    PRIMARY KEY (user_id, product_id)
);

ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

-- Wishlist Policies
CREATE POLICY "Users can manage their own wishlist" 
ON public.wishlists FOR ALL 
USING (auth.uid() = user_id);


-- ==========================================
-- 7. CART_ITEMS TABLE (Persists Cart in Database)
-- ==========================================
CREATE TABLE public.cart_items (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    product_id uuid REFERENCES public.products(id) ON DELETE CASCADE NOT NULL,
    quantity integer DEFAULT 1 NOT NULL CHECK (quantity > 0),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE (user_id, product_id)
);

ALTER TABLE public.cart_items ENABLE ROW LEVEL SECURITY;

-- Cart Policies
CREATE POLICY "Users can manage their own cart items" 
ON public.cart_items FOR ALL 
USING (auth.uid() = user_id);


-- =========================================================================
-- 8. STORAGE BUCKETS CONFIGURATION
-- =========================================================================

-- Insert buckets if they don't exist
INSERT INTO storage.buckets (id, name, public) 
VALUES 
  ('brands', 'brands', true),
  ('banners', 'banners', true),
  ('products', 'products', true)
ON CONFLICT (id) DO NOTHING;

-- 1. Brands Bucket Policies
CREATE POLICY "Allow public read access to brands storage"
ON storage.objects FOR SELECT
USING (bucket_id = 'brands');

CREATE POLICY "Allow authenticated users to manage brand logos"
ON storage.objects FOR ALL
USING (bucket_id = 'brands' AND auth.role() = 'authenticated')
WITH CHECK (bucket_id = 'brands' AND auth.role() = 'authenticated');

-- 2. Banners Bucket Policies
CREATE POLICY "Allow public read access to banners storage"
ON storage.objects FOR SELECT
USING (bucket_id = 'banners');

CREATE POLICY "Allow authenticated users to manage banners"
ON storage.objects FOR ALL
USING (bucket_id = 'banners' AND auth.role() = 'authenticated')
WITH CHECK (bucket_id = 'banners' AND auth.role() = 'authenticated');

-- 3. Products Bucket Policies
CREATE POLICY "Allow public read access to products storage"
ON storage.objects FOR SELECT
USING (bucket_id = 'products');

CREATE POLICY "Allow authenticated users to manage product images"
ON storage.objects FOR ALL
USING (bucket_id = 'products' AND auth.role() = 'authenticated')
WITH CHECK (bucket_id = 'products' AND auth.role() = 'authenticated');
