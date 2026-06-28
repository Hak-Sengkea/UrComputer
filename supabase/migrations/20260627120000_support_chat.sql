-- ==========================================
-- 1. SUPPORT ROOMS TABLE
-- ==========================================
CREATE TABLE public.support_rooms (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    customer_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    status text DEFAULT 'open'::text CHECK (status IN ('open', 'closed')),
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.support_rooms ENABLE ROW LEVEL SECURITY;

-- Allow users to view and insert their own rooms
CREATE POLICY "Users can manage their own support rooms"
ON public.support_rooms FOR ALL
USING (auth.uid() = customer_id);

-- ==========================================
-- 2. SUPPORT MESSAGES TABLE
-- ==========================================
CREATE TABLE public.support_messages (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    room_id uuid REFERENCES public.support_rooms(id) ON DELETE CASCADE NOT NULL,
    sender_id uuid REFERENCES public.profiles(id) ON DELETE SET NULL,
    sender_name text NOT NULL DEFAULT 'User',
    is_from_customer boolean NOT NULL DEFAULT true,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.support_messages ENABLE ROW LEVEL SECURITY;

-- Allow users to view messages in their own support rooms
CREATE POLICY "Users can view messages in their rooms"
ON public.support_messages FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM public.support_rooms r
        WHERE r.id = room_id AND r.customer_id = auth.uid()
    )
);

-- Allow users to insert messages in their own support rooms
CREATE POLICY "Users can insert messages in their rooms"
ON public.support_messages FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.support_rooms r
        WHERE r.id = room_id AND r.customer_id = auth.uid()
    )
);

-- ==========================================
-- 3. TELEGRAM MESSAGE MAPPINGS TABLE
-- ==========================================
CREATE TABLE public.telegram_message_mappings (
    telegram_message_id bigint PRIMARY KEY,
    room_id uuid REFERENCES public.support_rooms(id) ON DELETE CASCADE NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE public.telegram_message_mappings ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for support_messages
ALTER PUBLICATION supabase_realtime ADD TABLE public.support_messages;
