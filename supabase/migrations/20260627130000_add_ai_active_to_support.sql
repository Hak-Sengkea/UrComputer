-- Add ai_active column to support_rooms
ALTER TABLE public.support_rooms 
ADD COLUMN ai_active boolean NOT NULL DEFAULT true;
