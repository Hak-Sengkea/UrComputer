-- Migration to add specs JSONB column to products table
ALTER TABLE public.products 
ADD COLUMN IF NOT EXISTS specs jsonb DEFAULT '{}'::jsonb;
