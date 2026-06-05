-- ==========================================
-- SEED DATA FOR CATEGORIES
-- ==========================================
INSERT INTO public.categories (id, name, icon, banner, description) VALUES
('c81dfa01-9f9e-4c74-a029-79257e84f501', 'Gaming Laptops', 'laptop.png', '/category_img/gaming_laptop_banner.jpg', 'Portable high-performance laptops built for gaming and productivity.'),
('c81dfa01-9f9e-4c74-a029-79257e84f502', 'PC Builds', 'cpu.png', '/category_img/component_banner.jpg', 'Custom-built desktop PCs tuned for gaming, work, and upgrades.'),
('c81dfa01-9f9e-4c74-a029-79257e84f503', 'PC Components', 'router.png', '/category_img/network_banner.jpg', 'CPUs, GPUs, RAM, storage, motherboards, PSUs, and cooling parts.'),
('c81dfa01-9f9e-4c74-a029-79257e84f504', 'Peripherals', 'keyboard.png', '/category_img/peripherals_banner.jpg', 'Keyboards, mice, headsets, monitors, and other desk essentials.'),
('c81dfa01-9f9e-4c74-a029-79257e84f505', 'PC Accessories', 'accessory.png', '/category_img/accessories_banner.jpg', 'Stands, adapters, RGB gear, cables, and cooling add-ons.'),
('c81dfa01-9f9e-4c74-a029-79257e84f506', 'Storage Devices', 'ssd.png', '/category_img/storage_banner.jpg', 'Fast SSDs, HDDs, and external drives for extra capacity.'),
('c81dfa01-9f9e-4c74-a029-79257e84f507', 'Networking', 'router.png', '/category_img/network_banner.jpg', 'Routers, Wi-Fi adapters, switches, and network expansion gear.')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  icon = EXCLUDED.icon,
  banner = EXCLUDED.banner,
  description = EXCLUDED.description;

-- ==========================================
-- SEED DATA FOR BRANDS
-- ==========================================
INSERT INTO public.brands (id, name, logo) VALUES
('b81dfa01-9f9e-4c74-a029-79257e84f601', 'ASUS', 'https://images.seeklogo.com/logo-png/17/2/asus-republic-of-gamers-logo-png_seeklogo-175206.png'),
('b81dfa01-9f9e-4c74-a029-79257e84f602', 'Apple', 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f603', 'MSI', 'https://upload.wikimedia.org/wikipedia/commons/9/9c/Msi-Logo.jpg'),
('b81dfa01-9f9e-4c74-a029-79257e84f604', 'Lenovo', 'https://upload.wikimedia.org/wikipedia/commons/0/05/Lenovo_logo_2015.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f605', 'Dell', 'https://upload.wikimedia.org/wikipedia/commons/4/48/Dell_Logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f606', 'HP', 'https://upload.wikimedia.org/wikipedia/commons/a/ad/HP_logo_2012.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f607', 'Acer', 'https://upload.wikimedia.org/wikipedia/commons/0/00/Acer_2011.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f608', 'Razer', 'https://upload.wikimedia.org/wikipedia/commons/6/6e/Razer_logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f609', 'Corsair', 'https://upload.wikimedia.org/wikipedia/commons/7/77/Corsair_logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f610', 'Samsung', 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f611', 'Gigabyte', 'https://upload.wikimedia.org/wikipedia/commons/8/85/Gigabyte_Technology_logo_20080107.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f612', 'Logitech', 'https://upload.wikimedia.org/wikipedia/commons/7/77/Logitech_logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f613', 'NVIDIA', 'https://upload.wikimedia.org/wikipedia/commons/2/21/Nvidia_logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f614', 'Intel', 'https://upload.wikimedia.org/wikipedia/commons/c/c9/Intel-logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f615', 'Custom', ''),
('b81dfa01-9f9e-4c74-a029-79257e84f616', 'AMD', 'https://upload.wikimedia.org/wikipedia/commons/2/2f/AMD_Logo.svg'),
('b81dfa01-9f9e-4c74-a029-79257e84f617', 'ASUS ROG', 'https://upload.wikimedia.org/wikipedia/commons/2/2f/ASUS_ROG_logo.svg')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  logo = EXCLUDED.logo;

-- ==========================================
-- SEED DATA FOR PRODUCTS
-- ==========================================
INSERT INTO public.products (id, name, price, brand_id, stock, category_id, image, description, rating) VALUES
(
  'd81dfa01-9f9e-4c74-a029-79257e84f701',
  'Acer Gaming Headphones',
  199.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f607', -- Acer
  32,
  'c81dfa01-9f9e-4c74-a029-79257e84f504', -- Peripherals
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/acer_headphones.jpg',
  'Immersive gaming headphones with surround sound and RGB accents.',
  4.6
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f702',
  'ASUS Gaming Laptop',
  1599.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f601', -- ASUS
  14,
  'c81dfa01-9f9e-4c74-a029-79257e84f501', -- Gaming Laptops
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/asus_laptop.jpg',
  'High-performance ASUS gaming laptop built for competitive gaming.',
  4.8
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f703',
  'ASUS ROG Headset',
  249.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f617', -- ASUS ROG
  21,
  'c81dfa01-9f9e-4c74-a029-79257e84f504', -- Peripherals
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/asus_rog_headphones.webp',
  'Premium ROG headset with crystal-clear sound and deep bass.',
  4.7
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f704',
  'Dell Gaming Laptop',
  1399.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f605', -- Dell
  10,
  'c81dfa01-9f9e-4c74-a029-79257e84f501', -- Gaming Laptops
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/dell_laptop.jpg',
  'Powerful Dell gaming laptop with RTX graphics and fast refresh display.',
  4.5
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f705',
  'NVIDIA RTX Graphics Card',
  899.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f613', -- NVIDIA
  8,
  'c81dfa01-9f9e-4c74-a029-79257e84f503', -- PC Components
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/gpu.jpg',
  'Next-generation graphics card designed for high-end gaming and rendering.',
  4.9
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f706',
  'RGB Gaming GPU',
  999.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f613', -- NVIDIA
  6,
  'c81dfa01-9f9e-4c74-a029-79257e84f503', -- PC Components
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/gpu1.png',
  'RGB-powered gaming GPU built for ultra performance and aesthetics.',
  4.8
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f707',
  'Intel Core i7 Processor',
  399.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f614', -- Intel
  26,
  'c81dfa01-9f9e-4c74-a029-79257e84f503', -- PC Components
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/intel_corei7.jpg',
  'High-speed Intel processor optimized for gaming and multitasking.',
  4.7
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f708',
  'Intel Core i9 Processor',
  599.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f614', -- Intel
  18,
  'c81dfa01-9f9e-4c74-a029-79257e84f503', -- PC Components
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/Intel_corei9.jpg',
  'Flagship Intel CPU delivering elite gaming and workstation performance.',
  4.9
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f709',
  'Custom Gaming PC Build',
  2499.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f615', -- Custom
  4,
  'c81dfa01-9f9e-4c74-a029-79257e84f502', -- PC Builds
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/pc_build.jpeg',
  'Ultimate custom-built RGB gaming PC with enthusiast-grade hardware.',
  5.0
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f710',
  'Corsair RGB RAM',
  149.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f609', -- Corsair
  40,
  'c81dfa01-9f9e-4c74-a029-79257e84f503', -- PC Components
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/ram.jpg',
  'High-speed DDR5 RGB memory designed for modern gaming systems.',
  4.6
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f711',
  'ROG Gaming Laptop',
  1899.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f617', -- ASUS ROG
  11,
  'c81dfa01-9f9e-4c74-a029-79257e84f501', -- Gaming Laptops
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/rog_laptop.jpg',
  'Premium ROG gaming laptop engineered for high FPS gaming.',
  4.9
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f712',
  'AMD Ryzen 9000 Series',
  699.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f616', -- AMD
  15,
  'c81dfa01-9f9e-4c74-a029-79257e84f503', -- PC Components
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/ryzen_amd9000series.jpg',
  'Next-generation Ryzen processor with exceptional gaming performance.',
  4.8
),
(
  'd81dfa01-9f9e-4c74-a029-79257e84f713',
  'ASUS TUF Gaming Laptop',
  1299.00,
  'b81dfa01-9f9e-4c74-a029-79257e84f601', -- ASUS
  17,
  'c81dfa01-9f9e-4c74-a029-79257e84f501', -- Gaming Laptops
  'https://bcldnermnresieeabyan.supabase.co/storage/v1/object/public/products/tuf_laptop.jpg',
  'Durable ASUS TUF gaming laptop with powerful cooling and performance.',
  4.7
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  price = EXCLUDED.price,
  brand_id = EXCLUDED.brand_id,
  stock = EXCLUDED.stock,
  category_id = EXCLUDED.category_id,
  image = EXCLUDED.image,
  description = EXCLUDED.description,
  rating = EXCLUDED.rating;
